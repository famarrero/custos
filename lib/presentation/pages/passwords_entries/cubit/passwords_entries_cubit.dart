import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'passwords_entries_cubit.freezed.dart';
part 'passwords_entries_state.dart';

class PasswordsEntriesCubit extends Cubit<PasswordsEntriesState> {
  PasswordsEntriesCubit()
    : super(PasswordsEntriesState(passwordsEntries: BaseState.initial()));

  final PasswordEntryRepository passwordEntryRepository = di();

  StreamSubscription<List<PasswordEntryEntity>>? _passwordsEntriesSubscription;

  Future<void> watchPasswordsEntries() async {
    emit(state.copyWith(passwordsEntries: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _passwordsEntriesSubscription?.cancel();

    _passwordsEntriesSubscription = passwordEntryRepository
        .watchPasswordsEntries()
        .listen(
          (passwordsEntries) {
            emit(
              state.copyWith(
                passwordsEntries:
                    passwordsEntries.isEmpty
                        ? BaseState.empty()
                        : BaseState.data(passwordsEntries),
              ),
            );
          },
          onError: (e) {
            emit(
              state.copyWith(
                passwordsEntries: BaseState.error(
                  AppFailure(AppError.unknown, message: e.toString()),
                ),
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _passwordsEntriesSubscription?.cancel();
    return super.close();
  }
}

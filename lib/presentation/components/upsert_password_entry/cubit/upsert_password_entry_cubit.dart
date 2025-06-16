import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_password_entry_cubit.freezed.dart';
part 'upsert_password_entry_state.dart';

class UpsertPasswordEntryCubit extends Cubit<UpsertPasswordEntryState> {
  UpsertPasswordEntryCubit()
    : super(
        UpsertPasswordEntryState(upsertPasswordEntryState: BaseState.initial()),
      );

  final PasswordEntryRepository passwordEntryRepository = di();

  Future<void> upsertPasswordEntry({
    required PasswordEntryEntity passwordEntry,
  }) async {
    try {
      emit(state.copyWith(upsertPasswordEntryState: BaseState.loading()));

      await passwordEntryRepository.upsertPasswordEntry(
        passwordEntry: passwordEntry,
      );

      emit(state.copyWith(upsertPasswordEntryState: BaseState.data(true)));
    } catch (e) {
      emit(
        state.copyWith(
          upsertPasswordEntryState: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }
}

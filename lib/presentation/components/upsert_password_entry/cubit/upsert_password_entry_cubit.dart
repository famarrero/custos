import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_password_entry_cubit.freezed.dart';
part 'upsert_password_entry_state.dart';

class UpsertPasswordEntryCubit extends Cubit<UpsertPasswordEntryState> {
  UpsertPasswordEntryCubit()
    : super(
        UpsertPasswordEntryState(
          upsertPasswordEntryState: BaseState.initial(),
          groups: BaseState.initial(),
        ),
      );

  final PasswordEntryRepository passwordEntryRepository = di();
  final GroupRepository groupRepository = di();

  StreamSubscription<List<GroupEntity>>? _groupsSubscription;

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

  Future<void> watchGroups() async {
    emit(state.copyWith(groups: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _groupsSubscription?.cancel();

    _groupsSubscription = groupRepository.watchGroups().listen(
      (groups) {
        emit(
          state.copyWith(
            groups: BaseState.data(groups.isNotEmpty ? groups : []),
          ),
        );
      },
      onError: (e) {
        emit(
          state.copyWith(
            groups: BaseState.error(
              AppFailure(AppError.unknown, message: e.toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }
}

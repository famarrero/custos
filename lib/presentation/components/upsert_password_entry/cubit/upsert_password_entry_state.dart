part of 'upsert_password_entry_cubit.dart';

@freezed
abstract class UpsertPasswordEntryState with _$UpsertPasswordEntryState {
  const UpsertPasswordEntryState._();

  const factory UpsertPasswordEntryState({
    required BaseState<bool> upsertPasswordEntryState,
    required BaseState<List<GroupModel>> groups,
  }) = _UpsertPasswordEntryState;
}

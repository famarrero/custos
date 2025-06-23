part of 'upsert_password_entry_cubit.dart';

@freezed
abstract class UpsertPasswordEntryState with _$UpsertPasswordEntryState {
  const UpsertPasswordEntryState._();

  const factory UpsertPasswordEntryState({
    required BaseState<List<GroupEntity>> groups,
    required BaseState<PasswordEntryEntity> getPasswordEntryState,
    required BaseState<bool> upsertPasswordEntryState,
  }) = _UpsertPasswordEntryState;
}

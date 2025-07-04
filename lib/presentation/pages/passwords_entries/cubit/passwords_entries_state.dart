part of 'passwords_entries_cubit.dart';

@freezed
abstract class PasswordsEntriesState with _$PasswordsEntriesState {
  const PasswordsEntriesState._();

  const factory PasswordsEntriesState({
    required BaseState<List<PasswordEntryEntity>> passwordsEntries,
    required BaseState<List<GroupEntity>> groups,
    String? query,
    GroupEntity? selectedGroup,
  }) = _PasswordsEntriesState;
}

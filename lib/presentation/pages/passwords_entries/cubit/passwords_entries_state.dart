part of 'passwords_entries_cubit.dart';

@freezed
abstract class PasswordsEntriesState with _$PasswordsEntriesState {
  const PasswordsEntriesState._();

  const factory PasswordsEntriesState({
    required BaseState<List<PasswordEntryModel>> passwordsEntries,
  }) = _PasswordsEntriesState;
}

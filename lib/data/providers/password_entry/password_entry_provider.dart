import 'package:custos/data/models/password_entry/password_entry_model.dart';

abstract class PasswordEntryProvider {
  Future<List<PasswordEntryModel>> getPasswordsEntries();

  Stream<List<PasswordEntryModel>> watchPasswordsEntries();

  Future<PasswordEntryModel?> getPasswordEntry({required String id});

  Future<PasswordEntryModel> upsertPasswordEntry({required PasswordEntryModel passwordEntry});

  Future<void> deletePasswordEntry({required String id});
}

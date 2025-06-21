import 'package:custos/data/models/password_entry/password_entry_entity.dart';

abstract class PasswordEntryRepository {
  Future<List<PasswordEntryEntity>> getPasswordsEntries();

  Stream<List<PasswordEntryEntity>> watchPasswordsEntries();

  Future<PasswordEntryEntity> getPasswordEntry({required String id});

  Future<PasswordEntryEntity> upsertPasswordEntry({required PasswordEntryEntity passwordEntry});

  Future<void> deletePasswordEntry({required String id});
}

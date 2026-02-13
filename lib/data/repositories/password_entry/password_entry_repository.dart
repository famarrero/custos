import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_entity.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';

abstract class PasswordEntryRepository {
  Future<List<PasswordEntryEntity>> getPasswordsEntries();

  Stream<List<PasswordEntryEntity>> watchPasswordsEntries();

  Future<PasswordEntryEntity?> getPasswordEntry({required String id});

  Future<PasswordEntryEntity> upsertPasswordEntry({required PasswordEntryEntity passwordEntry});

  Future<void> deletePasswordEntry({required String id});

  Future<List<RepeatedPasswordGroupEntity>> getRepetitivePasswordsGroups();

  Future<PasswordStrengthGroupEntity> getPasswordsByStrength();

  Future<List<PasswordEntryEntity>> getOlderPasswordsEntries({int days = 180});
}

import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_model.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_model.dart';

abstract class PasswordEntryProvider {
  Future<List<PasswordEntryModel>> getPasswordsEntries();

  Stream<List<PasswordEntryModel>> watchPasswordsEntries();

  Future<PasswordEntryModel?> getPasswordEntry({required String id});

  Future<PasswordEntryModel> upsertPasswordEntry({required PasswordEntryModel passwordEntry});

  Future<PasswordEntryModel> upsertPasswordEntryWithUpdatedAt({required PasswordEntryModel passwordEntry});

  Future<void> deletePasswordEntry({required String id});

  Future<List<RepeatedPasswordGroupModel>> getRepetitivePasswordsGroups();

  Future<PasswordStrengthGroupModel> getPasswordsByStrength();

  Future<List<PasswordEntryModel>> getOlderPasswordsEntries({int days = 180});
}

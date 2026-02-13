import 'package:collection/collection.dart';
import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/aux_mehods.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_model.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_model.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/di_container.dart';

class PasswordEntryProviderImpl implements PasswordEntryProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<List<PasswordEntryModel>> getPasswordsEntries() async {
    return hiveDatabase.getPasswordEntryBox.values.cast<PasswordEntryModel>().toList();
  }

  @override
  Stream<List<PasswordEntryModel>> watchPasswordsEntries() async* {
    final box = hiveDatabase.getPasswordEntryBox;
    yield box.values.cast<PasswordEntryModel>().toList();

    yield* box.watch().map((_) => box.values.cast<PasswordEntryModel>().toList());
  }

  @override
  Future<PasswordEntryModel?> getPasswordEntry({required String id}) async {
    return hiveDatabase.getPasswordEntryBox.get(id);
  }

  @override
  Future<PasswordEntryModel> upsertPasswordEntry({required PasswordEntryModel passwordEntry}) async {
    await hiveDatabase.getPasswordEntryBox.put(passwordEntry.id, passwordEntry);
    return passwordEntry;
  }

  @override
  Future<PasswordEntryModel> upsertPasswordEntryWithUpdatedAt({required PasswordEntryModel passwordEntry}) async {
    final box = hiveDatabase.getPasswordEntryBox;

    final PasswordEntryModel? existing = box.get(passwordEntry.id);

    // Caso 1: no existe → insertar
    if (existing == null) {
      await box.put(passwordEntry.id, passwordEntry);
      return passwordEntry;
    }

    // Caso 2: existe → comparar updatedAt
    if (passwordEntry.updatedAt.isAfter(existing.updatedAt)) {
      await box.put(passwordEntry.id, passwordEntry);
      return passwordEntry;
    }

    // Caso 3: existe pero es más viejo → no tocar
    return existing;
  }

  @override
  Future<void> deletePasswordEntry({required String id}) {
    return hiveDatabase.getPasswordEntryBox.delete(id);
  }

  @override
  Future<List<RepeatedPasswordGroupModel>> getRepetitivePasswordsGroups() async {
    final entries = await getPasswordsEntries();

    // Agrupar internamente por contraseña
    final groupedByPassword = groupBy(entries, (e) => e.password);

    final List<RepeatedPasswordGroupModel> result = [];
    var index = 1;

    for (final group in groupedByPassword.values) {
      if (group.length > 1) {
        result.add(RepeatedPasswordGroupModel(id: 'group$index', passwordsEntries: group));
        index++;
      }
    }

    return result;
  }

  @override
  Future<PasswordStrengthGroupModel> getPasswordsByStrength() async {
    final entries = await getPasswordsEntries();

    final List<PasswordEntryModel> weak = [];
    final List<PasswordEntryModel> medium = [];
    final List<PasswordEntryModel> strong = [];

    for (final entry in entries) {
      final strength = AuxMethods.evaluatePasswordStrength(entry.password);

      switch (strength) {
        case PasswordStrength.weak:
          weak.add(entry);
          break;
        case PasswordStrength.medium:
          medium.add(entry);
          break;
        case PasswordStrength.strong:
          strong.add(entry);
          break;
      }
    }

    return PasswordStrengthGroupModel(weak: weak, medium: medium, strong: strong);
  }

  @override
  // Get all passwords entries that were edited before a certain number of days
  Future<List<PasswordEntryModel>> getOlderPasswordsEntries({int days = 180}) async {
    final entries = await getPasswordsEntries();
    return entries.where((e) => e.passwordEditedAt.isBefore(DateTime.now().subtract(Duration(days: days)))).toList();
  }
}

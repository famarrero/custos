import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/di_container.dart';

class PasswordEntryProviderImpl implements PasswordEntryProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<List<PasswordEntryModel>> getPasswordsEntries() async {
    return hiveDatabase.getPasswordEntryBox.values
        .cast<PasswordEntryModel>()
        .toList();
  }

  @override
  Stream<List<PasswordEntryModel>> watchPasswordsEntries() async* {
    final box = hiveDatabase.getPasswordEntryBox;
    yield box.values.cast<PasswordEntryModel>().toList();

    yield* box.watch().map(
      (_) => box.values.cast<PasswordEntryModel>().toList(),
    );
  }

  @override
  Future<PasswordEntryModel?> getPasswordEntry({required String id}) async {
    return hiveDatabase.getPasswordEntryBox.get(id);
  }

  @override
  Future<PasswordEntryModel> upsertPasswordEntry({
    required PasswordEntryModel passwordEntry,
  }) async {
    await hiveDatabase.getPasswordEntryBox.put(passwordEntry.id, passwordEntry);
    return passwordEntry;
  }

  @override
  Future<void> deletePasswordEntry({required String id}) {
    return hiveDatabase.getPasswordEntryBox.delete(id);
  }
}

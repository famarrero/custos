import 'package:custos/core/services/hive_database.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/di_container.dart';

class PasswordEntryProviderImpl implements PasswordEntryProvider {
  final HiveDatabase hiveDatabase = di();

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
  Future<PasswordEntryModel> getPasswordEntry({required String id}) async {
    return hiveDatabase.getPasswordEntryBox.get(id);
  }

  @override
  Future<int> upsertPasswordEntry({
    required PasswordEntryModel passwordEntry,
  }) async {
    return hiveDatabase.getPasswordEntryBox.add(passwordEntry);
  }

  @override
  Future<void> deletePasswordEntry({required String id}) {
    return hiveDatabase.getPasswordEntryBox.delete(id);
  }
}

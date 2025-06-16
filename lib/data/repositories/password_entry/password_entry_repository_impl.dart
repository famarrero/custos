import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';

class PasswordEntryRepositoryImpl implements PasswordEntryRepository {
  final PasswordEntryProvider passwordEntryProvider = di();

  @override
  Future<List<PasswordEntryEntity>> getPasswordsEntries() async {
    return (await passwordEntryProvider.getPasswordsEntries())
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Stream<List<PasswordEntryEntity>> watchPasswordsEntries() {
    return passwordEntryProvider.watchPasswordsEntries().map(
      (models) => models.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Future<PasswordEntryEntity> getPasswordEntry({required String id}) async {
    return (await passwordEntryProvider.getPasswordEntry(id: id)).toEntity();
  }

  @override
  Future<int> upsertPasswordEntry({
    required PasswordEntryEntity passwordEntry,
  }) async {
    return passwordEntryProvider.upsertPasswordEntry(
      passwordEntry: passwordEntry.toModel(),
    );
  }

  @override
  Future<void> deletePasswordEntry({required String id}) async {
    passwordEntryProvider.deletePasswordEntry(id: id);
  }
}

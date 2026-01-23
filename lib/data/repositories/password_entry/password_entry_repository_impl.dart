import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_entity.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';

class PasswordEntryRepositoryImpl implements PasswordEntryRepository {
  final PasswordEntryProvider passwordEntryProvider = di();
  final VersionRepository versionRepository = di();

  @override
  Future<List<PasswordEntryEntity>> getPasswordsEntries() async {
    final models = await passwordEntryProvider.getPasswordsEntries();
    final entities = await Future.wait(models.map((e) => e.toEntity()));
    return entities;
  }

  @override
  Stream<List<PasswordEntryEntity>> watchPasswordsEntries() {
    return passwordEntryProvider.watchPasswordsEntries().asyncMap((
      models,
    ) async {
      return await Future.wait(models.map((e) => e.toEntity()));
    });
  }

  @override
  Future<PasswordEntryEntity?> getPasswordEntry({required String id}) async {
    return (await passwordEntryProvider.getPasswordEntry(id: id))?.toEntity();
  }

  @override
  Future<PasswordEntryEntity> upsertPasswordEntry({
    required PasswordEntryEntity passwordEntry,
  }) async {
    await versionRepository.incrementVersion();
    return (await passwordEntryProvider.upsertPasswordEntry(
      passwordEntry: passwordEntry.toModel(),
    )).toEntity();
  }

  @override
  Future<void> deletePasswordEntry({required String id}) async {
    await versionRepository.incrementVersion();
    passwordEntryProvider.deletePasswordEntry(id: id);
  }

  @override
  Future<List<RepeatedPasswordGroupEntity>> getRepetitivePasswordsGroups() async {
    final models = await passwordEntryProvider.getRepetitivePasswordsGroups();
    final entities = await Future.wait(models.map((e) => e.toEntity()));
    return entities;
  }

  @override
  Future<PasswordStrengthGroupEntity> getPasswordsByStrength() async {
    final passwordStrengthGroupModel = await passwordEntryProvider.getPasswordsByStrength();
    return passwordStrengthGroupModel.toEntity();
  }
}

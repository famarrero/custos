import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/version/version_model.dart';
import 'package:custos/data/providers/version/version_provider.dart';
import 'package:custos/di_container.dart';

class VersionProviderImpl implements VersionProvider {
  final HiveDatabaseService hiveDatabase = di();

  static const String _versionKey = 'version_key';
  @override
  Future<int> getVersion() async {
    return (hiveDatabase.getVersionBox.get(_versionKey))?.version ?? 1;
  }

  @override
  Stream<int> watchVersion() {
    final box = hiveDatabase.getVersionBox;

    return box.watch(key: _versionKey).map((event) {
      final model = event.value as VersionModel?;
      return model?.version ?? 1;
    });
  }

  @override
  Future<int> incrementVersion() async {
    final box = hiveDatabase.getVersionBox;

    final currentVersion = box.get(_versionKey);
    final newVersion = (currentVersion?.version ?? 1) + 1;

    final updatedVersion = VersionModel(version: newVersion);

    await box.put(_versionKey, updatedVersion);

    return newVersion;
  }
}

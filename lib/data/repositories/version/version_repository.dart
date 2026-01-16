import 'package:custos/data/models/version/version_model.dart';

abstract class VersionRepository {
  Future<VersionModel?> getVersion();

  Future<int> incrementVersion();
}

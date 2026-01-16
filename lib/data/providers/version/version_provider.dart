import 'package:custos/data/models/version/version_model.dart';

abstract class VersionProvider {
  Future<VersionModel?> getVersion();

  Stream<int> watchVersion();

  Future<int> incrementVersion();
}

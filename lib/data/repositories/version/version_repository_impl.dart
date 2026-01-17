import 'package:custos/data/providers/version/version_provider.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';

class VersionRepositoryImpl implements VersionRepository {
  final VersionProvider versionProvider = di();

  @override
  Future<int> getVersion() async {
    return versionProvider.getVersion();
  }

  @override
  Future<int> incrementVersion() async {
    return versionProvider.incrementVersion();
  }
}

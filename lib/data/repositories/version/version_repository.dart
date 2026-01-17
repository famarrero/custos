abstract class VersionRepository {
  Future<int> getVersion();

  Future<int> incrementVersion();
}

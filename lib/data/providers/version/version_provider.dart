abstract class VersionProvider {
  Future<int> getVersion();

  Stream<int> watchVersion();

  Future<int> incrementVersion();
}

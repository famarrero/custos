abstract class VersionProvider {
  Future<int> getVersion();

  Stream<int> watchVersion();

  Future<int> upsertVersion({required int version});

  Future<int> incrementVersion();
}

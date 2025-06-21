abstract class SecureStorageProvider {
  /// Read secure value
  Future<String?> readValue({required String key});

  /// Write secure value
  Future<void> writeValue({required String key, required String value});

  // Delete value based in key
  Future<void> deleteValue({required String key});

  /// Return true if a the key founded
  Future<bool> containsKey({required String key});
}

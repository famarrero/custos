abstract class SecureStorageProvider {
  /// Read secure value
  Future<String?> readValue({required String key});

  /// Write secure value
  Future<void> writeValue({required String key, required String value});

  /// Write secure value with biometric protection
  /// The value will be encrypted with biometric authentication required
  Future<void> writeValueWithBiometrics({required String key, required String value});

  /// Read secure value with biometric protection
  /// The value will require biometric authentication to be read
  Future<String?> readValueWithBiometrics({required String key});

  // Delete value based in key
  Future<void> deleteValue({required String key});

  /// Return true if a the key founded
  Future<bool> containsKey({required String key});
}

abstract class PreferencesProvider {
  /// Get an int value
  Future<int?> getInt({required String key});

  /// Save an int value
  Future<void> setInt({required int value, required String key});

  /// Get an string value
  Future<String?> getString({required String key});

  /// Save an string value
  Future<void> setString({required String value, required String key});
  
  /// Save an bool value
  Future<bool?> getBool({required String key});
  
  /// Get an bool value
  Future<void> setBool({required bool value, required String key});

  /// Remove a preference key
  Future<void> remove({required String key});
}

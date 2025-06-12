import 'package:custos/data/providers/preferences/preferences_provider.dart';
import 'package:custos/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProviderImpl extends PreferencesProvider {
  final SharedPreferences sharedPreferences = di();

  @override
  Future<int?> getInt({required String key}) async =>
      sharedPreferences.getInt(key);

  @override
  Future<void> setInt({required int value, required String key}) async =>
      await sharedPreferences.setInt(key, value);

  @override
  Future<String?> getString({required String key}) async =>
      sharedPreferences.getString(key);

  @override
  Future<void> setString({required String value, required String key}) async =>
      await sharedPreferences.setString(key, value);

  @override
  Future<bool?> getBool({required String key}) async =>
      sharedPreferences.getBool(key);

  @override
  Future<void> setBool({required bool value, required String key}) async =>
      await sharedPreferences.setBool(key, value);

  @override
  Future<void> remove({required String key}) async =>
      await sharedPreferences.remove(key);
}

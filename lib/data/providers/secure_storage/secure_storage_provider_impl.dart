import 'package:custos/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:custos/di_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProviderImpl extends SecureStorageProvider {
  final FlutterSecureStorage flutterSecureStorage = di();

  @override
  Future<String?> readValue({required String key}) async =>
      flutterSecureStorage.read(key: key);

  @override
  Future<void> writeValue({required String key, required String value}) async =>
      await flutterSecureStorage.write(key: key, value: value);

  @override
  Future<bool> containsKey({required String key}) async =>
      await flutterSecureStorage.containsKey(key: key);
}

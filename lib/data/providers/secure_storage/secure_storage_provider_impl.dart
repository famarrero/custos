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
  Future<void> writeValueWithBiometrics({required String key, required String value}) async {
    // Usar las mismas opciones de seguridad que las escrituras normales
    // El SO manejará automáticamente la seguridad del almacenamiento
    // La biométrica se verificará antes de llamar a este método usando local_auth
    await flutterSecureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> readValueWithBiometrics({required String key}) async {
    // Usar las mismas opciones de seguridad que las lecturas normales
    // El SO manejará automáticamente la seguridad del almacenamiento
    // La biométrica se verificará antes de llamar a este método usando local_auth
    return await flutterSecureStorage.read(key: key);
  }

  @override
  Future<void> deleteValue({required String key}) async =>
      await flutterSecureStorage.delete(key: key);

  @override
  Future<bool> containsKey({required String key}) async =>
      await flutterSecureStorage.containsKey(key: key);
}

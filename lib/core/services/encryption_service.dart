import 'dart:typed_data';

import 'package:custos/core/utils/crypto_utils.dart' as crypto_utils;
import 'package:encrypt/encrypt.dart';

/// Servicio para manejar operaciones de encriptación/desencriptación
abstract class EncryptionService {
  /// Genera un salt aleatorio de la longitud especificada
  List<int> generateSalt([int length = 16]);

  /// Deriva una clave de encriptación basada en masterKey y salt usando PBKDF2
  List<int> deriveEncryptionKey(String masterKey, List<int> salt);

  /// Deriva una clave de encriptación de forma asíncrona (en isolate para no bloquear UI)
  Future<List<int>> deriveEncryptionKeyAsync(String masterKey, List<int> salt);

  /// Genera una clave aleatoria de 32 bytes (para AES-256)
  List<int> generateRandomKey();

  /// Cifra datos con AES-GCM usando una clave derivada
  /// Retorna un mapa con 'iv' (nonce) y 'encryptedKey' en base64
  /// Nota: AES-GCM incluye el tag de autenticación automáticamente en el ciphertext
  Future<Map<String, String>> encryptWithAESGCM({required List<int> data, required List<int> key});

  /// Descifra datos con AES-GCM usando una clave derivada
  /// Nota: AES-GCM verifica automáticamente el tag de autenticación al descifrar
  Future<List<int>> decryptWithAESGCM({
    required String ivBase64,
    required String encryptedDataBase64,
    required List<int> key,
  });

  /// Cifra texto con AES-CBC usando una clave derivada
  /// Retorna un mapa con 'iv' y 'encryptedData' en base64
  Future<Map<String, String>> encryptTextWithAESCBC({required String text, required List<int> key});

  /// Descifra texto con AES-CBC usando una clave derivada
  Future<String> decryptTextWithAESCBC({
    required String ivBase64,
    required String encryptedDataBase64,
    required List<int> key,
  });
}


class EncryptionServiceImpl implements EncryptionService {
  @override
  List<int> generateSalt([int length = 16]) {
    return crypto_utils.generateSalt(length);
  }

  @override
  List<int> deriveEncryptionKey(String masterKey, List<int> salt) {
    return crypto_utils.deriveEncryptionKey(masterKey, salt);
  }

  @override
  Future<List<int>> deriveEncryptionKeyAsync(String masterKey, List<int> salt) async {
    return crypto_utils.deriveEncryptionKeyAsync(masterKey, salt);
  }

  @override
  List<int> generateRandomKey() {
    // Genera una clave aleatoria de 32 bytes para AES-256
    return crypto_utils.generateSalt(32);
  }

  @override
  Future<Map<String, String>> encryptWithAESGCM({required List<int> data, required List<int> key}) async {
    // Crear clave AES desde key (32 bytes para AES-256)
    final aesKey = Key(Uint8List.fromList(key.take(32).toList()));

    // Generar nonce aleatorio (12 bytes para AES-GCM)
    final iv = IV.fromSecureRandom(12);

    // Cifrar datos con AES-GCM (incluye autenticación automáticamente)
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.gcm));
    final encrypted = encrypter.encryptBytes(data, iv: iv);

    return {'iv': iv.base64, 'encryptedKey': encrypted.base64};
  }

  @override
  Future<List<int>> decryptWithAESGCM({
    required String ivBase64,
    required String encryptedDataBase64,
    required List<int> key,
  }) async {
    // Crear clave AES desde key (32 bytes para AES-256)
    final aesKey = Key(Uint8List.fromList(key.take(32).toList()));

    // Decodificar IV (nonce) y datos cifrados
    final iv = IV.fromBase64(ivBase64);
    final encrypted = Encrypted.fromBase64(encryptedDataBase64);

    // Descifrar datos con AES-GCM (verifica autenticación automáticamente)
    // Si el tag es inválido o los datos fueron modificados, lanzará una excepción
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.gcm));
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);

    return decrypted;
  }

  @override
  Future<Map<String, String>> encryptTextWithAESCBC({required String text, required List<int> key}) async {
    // Crear clave AES desde key (32 bytes para AES-256)
    final aesKey = Key(Uint8List.fromList(key.take(32).toList()));

    // Generar IV aleatorio (16 bytes para AES-CBC)
    final iv = IV.fromSecureRandom(16);

    // Cifrar texto con AES-CBC
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return {'iv': iv.base64, 'encryptedData': encrypted.base64};
  }

  @override
  Future<String> decryptTextWithAESCBC({
    required String ivBase64,
    required String encryptedDataBase64,
    required List<int> key,
  }) async {
    // Crear clave AES desde key (32 bytes para AES-256)
    final aesKey = Key(Uint8List.fromList(key.take(32).toList()));

    // Decodificar IV y datos cifrados
    final iv = IV.fromBase64(ivBase64);
    final encrypted = Encrypted.fromBase64(encryptedDataBase64);

    // Descifrar texto con AES-CBC
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }
}

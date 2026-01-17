import 'dart:convert';
import 'dart:typed_data';

import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/crypto_utils.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/repositories/import_export/import_export_repository.dart';
import 'package:encrypt/encrypt.dart';

class ImportExportRepositoryImpl implements ImportExportRepository {
  @override
  Future<Either<Failure, Map<String, dynamic>>> encryptData({
    required String jsonData,
    required String masterKey,
  }) async {
    try {
      // Generar salt único para este archivo de backup
      final backupSalt = generateSalt();

      // Derivar encryptionKey usando la master key y el salt
      final encryptionKey = await deriveEncryptionKeyAsync(masterKey, backupSalt);

      // Crear clave AES desde la encryptionKey (32 bytes para AES-256)
      final key = Key(Uint8List.fromList(encryptionKey.take(32).toList()));

      // Inicializar AES (modo CBC con padding PKCS7)
      final iv = IV.fromSecureRandom(16); // IV de 16 bytes para AES-CBC
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Encriptar el JSON
      final encrypted = encrypter.encrypt(jsonData, iv: iv);

      // Crear estructura del archivo encriptado
      final encryptedFileData = {
        'version': '1.0', // Versión del formato de archivo encriptado
        'salt': base64Encode(backupSalt),
        'iv': iv.base64,
        'encryptedData': encrypted.base64,
      };

      return right(encryptedFileData);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: 'Error al encriptar los datos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> decryptData({
    required Map<String, dynamic> encryptedFileData,
    required String masterKey,
  }) async {
    try {
      // Extraer salt, IV y datos encriptados
      final saltBase64 = encryptedFileData['salt'] as String?;
      final ivBase64 = encryptedFileData['iv'] as String?;
      final encryptedDataBase64 = encryptedFileData['encryptedData'] as String?;

      if (saltBase64 == null || ivBase64 == null || encryptedDataBase64 == null) {
        return left(AppFailure(AppError.unknown, message: 'Archivo corrupto: faltan datos de encriptación'));
      }

      // Decodificar salt e IV desde base64
      final backupSalt = base64Decode(saltBase64);
      final iv = IV.fromBase64(ivBase64);
      final encrypted = Encrypted.fromBase64(encryptedDataBase64);

      // Derivar encryptionKey usando la master key proporcionada y el salt del archivo
      final encryptionKey = await deriveEncryptionKeyAsync(masterKey, backupSalt);

      // Crear clave AES desde la encryptionKey (32 bytes para AES-256)
      final key = Key(Uint8List.fromList(encryptionKey.take(32).toList()));

      // Inicializar AES (modo CBC con padding PKCS7)
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // Desencriptar el JSON
      final decryptedJsonString = encrypter.decrypt(encrypted, iv: iv);

      // Parsear JSON desencriptado
      final decryptedData = jsonDecode(decryptedJsonString) as Map<String, dynamic>;

      return right(decryptedData);
    } catch (e) {
      // Si hay error al desencriptar, puede ser master key incorrecta
      final errorMessage =
          e.toString().contains('bad decrypt') || e.toString().contains('padding')
              ? 'La clave maestra es incorrecta o el archivo está corrupto'
              : 'Error al desencriptar los datos: ${e.toString()}';

      return left(AppFailure(AppError.unknown, message: errorMessage));
    }
  }

  @override
  Either<Failure, void> validateEncryptedFileStructure(Map<String, dynamic> encryptedFileData) {
    // Validar versión del formato
    final fileVersion = encryptedFileData['version'] as String?;
    if (fileVersion != '1.0') {
      return left(AppFailure(AppError.unknown, message: 'Versión de archivo no compatible: $fileVersion'));
    }

    // Validar que el archivo contenga los datos de encriptación necesarios
    final saltBase64 = encryptedFileData['salt'] as String?;
    final ivBase64 = encryptedFileData['iv'] as String?;
    final encryptedDataBase64 = encryptedFileData['encryptedData'] as String?;

    if (saltBase64 == null || ivBase64 == null || encryptedDataBase64 == null) {
      return left(AppFailure(AppError.unknown, message: 'Archivo corrupto: faltan datos de encriptación'));
    }

    return right(null);
  }
}

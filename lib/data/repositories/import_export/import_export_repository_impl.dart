import 'dart:convert';

import 'package:custos/core/services/encryption_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/repositories/import_export/import_export_repository.dart';
import 'package:custos/di_container.dart';

class ImportExportRepositoryImpl implements ImportExportRepository {
  final EncryptionService encryptionService = di();
  @override
  Future<Either<Failure, Map<String, dynamic>>> encryptData({
    required String jsonData,
    required String masterKey,
  }) async {
    try {
      // Generar salt único para este archivo de backup
      final backupSalt = encryptionService.generateSalt();

      // Derivar encryptionKey usando la master key y el salt
      final encryptionKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, backupSalt);

      // Cifrar el JSON con AES-CBC
      final encrypted = await encryptionService.encryptTextWithAESCBC(text: jsonData, key: encryptionKey);

      // Crear estructura del archivo encriptado
      final encryptedFileData = {
        'version': '1.0', // Versión del formato de archivo encriptado
        'salt': base64Encode(backupSalt),
        'iv': encrypted['iv'],
        'encryptedData': encrypted['encryptedData'],
      };

      return right(encryptedFileData);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: 'Error encrypting data: ${e.toString()}'));
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
        return left(AppFailure(AppError.unknown, message: 'Corrupt file: missing encryption data'));
      }

      // Decodificar salt desde base64
      final backupSalt = base64Decode(saltBase64);

      // Derivar encryptionKey usando la master key proporcionada y el salt del archivo
      final encryptionKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, backupSalt);

      // Descifrar el JSON con AES-CBC
      final decryptedJsonString = await encryptionService.decryptTextWithAESCBC(
        ivBase64: ivBase64,
        encryptedDataBase64: encryptedDataBase64,
        key: encryptionKey,
      );

      // Parsear JSON desencriptado
      final decryptedData = jsonDecode(decryptedJsonString) as Map<String, dynamic>;

      return right(decryptedData);
    } catch (e) {
      // Si hay error al desencriptar, puede ser master key incorrecta
      final errorMessage =
          e.toString().contains('bad decrypt') || e.toString().contains('padding')
              ? 'Master key is incorrect or file is corrupted'
              : 'Error decrypting data: ${e.toString()}';

      return left(AppFailure(AppError.unknown, message: errorMessage));
    }
  }

  @override
  Either<Failure, void> validateEncryptedFileStructure(Map<String, dynamic> encryptedFileData) {
    // Validar versión del formato
    final fileVersion = encryptedFileData['version'] as String?;
    if (fileVersion != '1.0') {
      return left(AppFailure(AppError.unknown, message: 'Unsupported file version: $fileVersion'));
    }

    // Validar que el archivo contenga los datos de encriptación necesarios
    final saltBase64 = encryptedFileData['salt'] as String?;
    final ivBase64 = encryptedFileData['iv'] as String?;
    final encryptedDataBase64 = encryptedFileData['encryptedData'] as String?;

    if (saltBase64 == null || ivBase64 == null || encryptedDataBase64 == null) {
      return left(AppFailure(AppError.unknown, message: 'Corrupt file: missing encryption data'));
    }

    return right(null);
  }
}

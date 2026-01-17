import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';

/// Repositorio para operaciones de importación y exportación de datos
abstract class ImportExportRepository {
  /// Encripta los datos JSON proporcionados usando la master key
  ///
  /// Retorna un Map con la estructura encriptada que incluye:
  /// - version: versión del formato de archivo
  /// - salt: salt usado para derivar la clave (base64)
  /// - iv: vector de inicialización (base64)
  /// - encryptedData: datos encriptados (base64)
  Future<Either<Failure, Map<String, dynamic>>> encryptData({
    required String jsonData,
    required String masterKey,
  });

  /// Desencripta los datos encriptados usando la master key
  ///
  /// Retorna un Map con los datos desencriptados en formato JSON
  Future<Either<Failure, Map<String, dynamic>>> decryptData({
    required Map<String, dynamic> encryptedFileData,
    required String masterKey,
  });

  /// Valida la estructura del archivo encriptado
  ///
  /// Verifica que el archivo tenga la versión correcta y todos los campos necesarios
  Either<Failure, void> validateEncryptedFileStructure(Map<String, dynamic> encryptedFileData);
}

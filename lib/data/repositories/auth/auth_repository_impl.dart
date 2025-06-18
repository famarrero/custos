import 'dart:convert';

import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/crypto_utils.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveDatabaseService hiveDatabase = di();
  final SecureStorageProvider secureStorage = di();

  final saltKey = '_salt_';

  @override
  Future<bool> hasMasterKeyBeenSet() async {
    return await secureStorage.containsKey(key: saltKey);
  }

  @override
  Future<Either<Failure, void>> registerMasterKey(String masterKey) async {
    try {
      // Generate a salt
      final generatedSalt = generateSalt();

      // Encode salt in base64
      final saltEncoded = base64Encode(generatedSalt);

      // Save the salt in the secure storage
      await secureStorage.writeValue(key: saltKey, value: saltEncoded);

      // Derive the encrypted key by masterKey and salt
      final encryptionKey = deriveEncryptionKey(masterKey, generatedSalt);

      // Set the encryptionKey in HiveDatabaseService
      hiveDatabase.setEncryptionKey(encryptionKey);

      await hiveDatabase.setVerificationAuthValue();

      return right(null);
    } catch (e) {
      return left(
        AppFailure(AppError.errorDerivingEncryptionKey, message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> verifyMasterKey(String masterKey) async {
    // Read the salt from secure storage
    final salt = await secureStorage.readValue(key: saltKey);

    // If salt is null means that the master encryptionKey is not set yet
    if (salt == null) {
      return left(AppFailure(AppError.encryptionKeyNotSet));
    }

    // Derive the encrypted key by masterKey and salt
    final encryptionKey = deriveEncryptionKey(masterKey, base64Decode(salt));

    // Set the encryptionKey in HiveDatabaseService
    hiveDatabase.setEncryptionKey(encryptionKey);

    try {
      final value = await hiveDatabase.verificationAuthIsCorrect;

      if (value) {
        await hiveDatabase.openEncryptedBoxes();
        return right(null);
      } else {
        return left(AppFailure(AppError.incorrectMasterKey));
      }
    } catch (_) {
      return left(AppFailure(AppError.incorrectMasterKey));
    }
  }

  @override
  Future<void> logout() async {
    hiveDatabase.getGroupBox.close();
    hiveDatabase.getPasswordEntryBox.close();
    hiveDatabase.setEncryptionKey(null);
  }
}

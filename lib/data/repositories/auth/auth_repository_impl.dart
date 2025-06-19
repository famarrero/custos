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

  // The key for salt when generate the masterKey encryption
  final masterKeySaltKey = '_master_key_salt_';
  // The key for the hashedMasterKey
  final hashedMasterKey = '_hashed_master_key_';

  // The key for the encryptionKeySalt
  final encryptionKeySalt = '_encryption_key_salt_';

  @override
  Future<bool> hasMasterKeyBeenSet() async {
    return await secureStorage.containsKey(key: masterKeySaltKey) &&
        await secureStorage.containsKey(key: hashedMasterKey) &&
        await secureStorage.containsKey(key: encryptionKeySalt);
  }

  @override
  Future<Either<Failure, void>> registerMasterKey(String masterKey) async {
    try {
      // Generate a salt
      final generatedSalt = generateSalt();

      // Encode salt in base64
      final saltEncoded = base64Encode(generatedSalt);

      // Save the salt in the secure storage
      await secureStorage.writeValue(
        key: encryptionKeySalt,
        value: saltEncoded,
      );

      // Derive the encrypted key by masterKey and salt
      final encryptionKey = deriveEncryptionKey(masterKey, generatedSalt);

      // Save the masterKey in secure storage as PBKDF2
      _saveMasterKeyPBKDF2(masterKey);

      // Set the encryptionKey in HiveDatabaseService
      // The encryptionKey only saved in temporal memory (RAM)
      hiveDatabase.setEncryptionKey(encryptionKey);

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
    final saltEncoded = await secureStorage.readValue(key: encryptionKeySalt);

    // If salt is null means that the master encryptionKey is not set yet
    if (saltEncoded == null) {
      return left(AppFailure(AppError.encryptionKeyNotSet));
    }

    // Decode salt from base64
    final saltDecode = base64Decode(saltEncoded);

    // Derive the encrypted key by masterKey and salt
    final encryptionKey = deriveEncryptionKey(masterKey, saltDecode);

    try {
      // Verify if the masterKey is correct
      final value = await _verifyMasterKeyPBKDF2(masterKey);

      if (value) {
        // Set the encryptionKey in HiveDatabaseService
        hiveDatabase.setEncryptionKey(encryptionKey);
        // If true open the encrypted boxes
        await hiveDatabase.openEncryptedBoxes();
        return right(null);
      } else {
        // Set the encryptionKey in HiveDatabaseService to null
        hiveDatabase.setEncryptionKey(null);
        // If false means that the master key is incorrect
        return left(AppFailure(AppError.incorrectMasterKey));
      }
    } catch (e) {
      // Set the encryptionKey in HiveDatabaseService to null
      hiveDatabase.setEncryptionKey(null);
      // If unknown error occurred return failure master key is incorrect
      return left(
        AppFailure(AppError.incorrectMasterKey, message: e.toString()),
      );
    }
  }

  @override
  Future<void> logout() async {
    // Close boxes
    hiveDatabase.getGroupBox.close();
    hiveDatabase.getPasswordEntryBox.close();

    // Set the encryptionKey in HiveDatabaseService to null
    hiveDatabase.setEncryptionKey(null);
  }

  Future<void> _saveMasterKeyPBKDF2(String masterKey) async {
    try {
      // Generate a salt for the masterKey
      final masterKeySalt = generateSalt();

      // Derive the encrypted masterKey by masterKey and salt
      final derivedEncryptionMasterKey = deriveEncryptionKey(
        masterKey,
        masterKeySalt,
      );
      // Save the salt in the secure storage
      await secureStorage.writeValue(
        key: masterKeySaltKey,
        value: base64Encode(masterKeySalt),
      );
      // Save the derived encryption masterKey in the secure storage
      await secureStorage.writeValue(
        key: hashedMasterKey,
        value: base64Encode(derivedEncryptionMasterKey),
      );
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> _verifyMasterKeyPBKDF2(String masterKey) async {
    try {
      // Read the masterKeySaltEncoded from secure storage
      final masterKeySaltEncoded = await secureStorage.readValue(
        key: masterKeySaltKey,
      );
      // Read the hashedMasterKeyEncode from secure storage
      final hashedMasterKeyEncode = await secureStorage.readValue(
        key: hashedMasterKey,
      );

      if (masterKeySaltEncoded == null || hashedMasterKeyEncode == null) {
        return false;
      }

      // Decode the masterKeySaltEncoded
      final masterKeySaltDecode = base64Decode(masterKeySaltEncoded);

      // Derive the encrypted masterKey by masterKey and masterKeySaltDecode
      final derivedEncryptionMasterKey = deriveEncryptionKey(
        masterKey,
        masterKeySaltDecode,
      );

      // If true the masterKey is correct
      return hashedMasterKeyEncode == base64Encode(derivedEncryptionMasterKey);
    } catch (e) {
      throw Exception();
    }
  }
}

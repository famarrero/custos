import 'dart:convert';

import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/crypto_utils.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/profile/profile_provider.dart';
import 'package:custos/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:custos/data/providers/version/version_provider.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:uuid/uuid.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveDatabaseService hiveDatabase = di();
  final SecureStorageProvider secureStorage = di();
  final ProfileProvider profilesProvider = di();
  final VersionProvider versionProvider = di();

  @override
  Future<Either<Failure, ProfileModel>> registerProfileWhitMasterKey({
    // Usend when user login with a new profile
    String? profileName,
    // Usend when user import data from another device
    ProfileModel? importProfile,
    required String masterKey,
  }) async {
    try {
      late ProfileModel profile;

      if (importProfile != null) {
        profile = importProfile;
      } else if (profileName != null) {
        final profileId = Uuid().v4();
        profile = ProfileModel(
          id: profileId,
          name: profileName.trim(),
          masterKeySaltSecureStorageAccessKey: '${profileId}_master_key_salt',
          masterKeyHashSecureStorageAccessKey: '${profileId}_master_key_hash',
          encryptionKeySaltSecureStorageAccessKey: '${profileId}_encryption_key_salt',
          createdAt: DateTime.now(),
        );
      } else {
        return left(AppFailure(AppError.unknown));
      }

      // Generate a salt
      final generatedSalt = generateSalt();

      // Encode salt in base64
      final saltEncoded = base64Encode(generatedSalt);

      // Save the salt in the secure storage
      await secureStorage.writeValue(key: profile.encryptionKeySaltSecureStorageAccessKey, value: saltEncoded);

      // Derive the encrypted key by masterKey and salt
      final encryptionKey = await deriveEncryptionKeyAsync(masterKey, generatedSalt);

      // Save the masterKey in secure storage as PBKDF2
      await _saveMasterKeyPBKDF2(
        masterKeySaltSecureStorageAccessKey: profile.masterKeySaltSecureStorageAccessKey,
        masterKeyHashSecureStorageAccessKey: profile.masterKeyHashSecureStorageAccessKey,
        masterKey: masterKey,
      );

      // Set the encryptionKey in HiveDatabaseService
      // The encryptionKey only saved in temporal memory (RAM)
      hiveDatabase.setEncryptionKey(encryptionKey, profile.id);

      await profilesProvider.upsertProfile(profileModel: profile);

      return right(profile);
    } catch (e) {
      return left(AppFailure(AppError.errorDerivingEncryptionKey, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyProfileByMasterKey({
    required ProfileModel profile,
    required String masterKey,
  }) async {
    // Read the salt from secure storage
    final saltEncoded = await secureStorage.readValue(key: profile.encryptionKeySaltSecureStorageAccessKey);

    // If salt is null means that the master encryptionKey is not set yet
    if (saltEncoded == null) {
      return left(AppFailure(AppError.encryptionKeyNotSet));
    }

    try {
      // Verify if the masterKey is correct
      final value = await _verifyMasterKeyPBKDF2(
        masterKeySaltSecureStorageAccessKey: profile.masterKeySaltSecureStorageAccessKey,
        masterKeyHashSecureStorageAccessKey: profile.masterKeyHashSecureStorageAccessKey,
        masterKey: masterKey,
      );

      if (value) {
        // Decode salt from base64
        final saltDecode = base64Decode(saltEncoded);

        // Derive the encrypted key by masterKey and salt
        final encryptionKey = await deriveEncryptionKeyAsync(masterKey, saltDecode);

        // Set the encryptionKey in HiveDatabaseService
        hiveDatabase.setEncryptionKey(encryptionKey, profile.id);
        // If true open the encrypted boxes
        await hiveDatabase.openEncryptedBoxes();
        // Set data version as 1
        await versionProvider.incrementVersion();
        return right(null);
      } else {
        // Set the encryptionKey in HiveDatabaseService to null
        hiveDatabase.setEncryptionKey(null, null);
        // If false means that the master key is incorrect
        return left(AppFailure(AppError.incorrectMasterKey));
      }
    } catch (e) {
      // Set the encryptionKey in HiveDatabaseService to null
      hiveDatabase.setEncryptionKey(null, null);
      // If unknown error occurred return failure master key is incorrect
      return left(AppFailure(AppError.incorrectMasterKey, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfileAndMasterKey({required ProfileModel profile}) async {
    try {
      await secureStorage.deleteValue(key: profile.masterKeySaltSecureStorageAccessKey);
      await secureStorage.deleteValue(key: profile.masterKeyHashSecureStorageAccessKey);
      await secureStorage.deleteValue(key: profile.encryptionKeySaltSecureStorageAccessKey);

      await profilesProvider.deleteProfile(id: profile.id);

      return right(null);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Close boxes
      hiveDatabase.getGroupBox.close();
      hiveDatabase.getPasswordEntryBox.close();

      // Set the encryptionKey in HiveDatabaseService to null
      hiveDatabase.setEncryptionKey(null, null);

      return right(null);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: e.toString()));
    }
  }

  Future<void> _saveMasterKeyPBKDF2({
    required String masterKeySaltSecureStorageAccessKey,
    required String masterKeyHashSecureStorageAccessKey,
    required String masterKey,
  }) async {
    try {
      // Generate a salt for the masterKey
      final masterKeySalt = generateSalt();

      // Derive the encrypted masterKey by masterKey and salt
      final derivedEncryptionMasterKey = await deriveEncryptionKeyAsync(masterKey, masterKeySalt);
      // Save the salt in the secure storage
      await secureStorage.writeValue(key: masterKeySaltSecureStorageAccessKey, value: base64Encode(masterKeySalt));
      // Save the derived encryption masterKey in the secure storage
      await secureStorage.writeValue(
        key: masterKeyHashSecureStorageAccessKey,
        value: base64Encode(derivedEncryptionMasterKey),
      );
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> _verifyMasterKeyPBKDF2({
    required String masterKeySaltSecureStorageAccessKey,
    required String masterKeyHashSecureStorageAccessKey,
    required String masterKey,
  }) async {
    try {
      // Read the masterKeySaltEncoded from secure storage
      final masterKeySaltEncoded = await secureStorage.readValue(key: masterKeySaltSecureStorageAccessKey);
      // Read the hashedMasterKeyEncode from secure storage
      final hashedMasterKeyEncode = await secureStorage.readValue(key: masterKeyHashSecureStorageAccessKey);

      if (masterKeySaltEncoded == null || hashedMasterKeyEncode == null) {
        return false;
      }

      // Decode the masterKeySaltEncoded
      final masterKeySaltDecode = base64Decode(masterKeySaltEncoded);

      // Derive the encrypted masterKey by masterKey and masterKeySaltDecode
      final derivedEncryptionMasterKey = await deriveEncryptionKeyAsync(masterKey, masterKeySaltDecode);

      // If true the masterKey is correct
      return hashedMasterKeyEncode == base64Encode(derivedEncryptionMasterKey);
    } catch (e) {
      throw Exception();
    }
  }
}

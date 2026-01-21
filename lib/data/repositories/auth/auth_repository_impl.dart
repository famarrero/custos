import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:custos/core/services/biometric_auth_service.dart';
import 'package:custos/core/services/encryption_service.dart';
import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
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
  final GroupProvider groupProvider = di();
  final PasswordEntryProvider passwordEntryProvider = di();
  final BiometricAuthService biometricAuthService = di();
  final EncryptionService encryptionService = di();

  /// Obtiene la clave de almacenamiento para K_hive cifrada (sin biométrica)
  String _getEncryptedHiveKeyStorageKey(String profileId) {
    return '${profileId}_hive_key_encrypted';
  }

  /// Obtiene la clave de almacenamiento para K_hive protegida por biométrica (deviceKey)
  String _getBiometricHiveKeyStorageKey(String profileId) {
    return '${profileId}_device_key_biometric';
  }

  /// Obtiene la clave de almacenamiento para K_hive cifrada con deviceKey
  String _getEncryptedHiveKeyWithDeviceKeyStorageKey(String profileId) {
    return '${profileId}_hive_key_encrypted_device';
  }

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
        final now = DateTime.now().toUtc();
        profile = ProfileModel(
          id: profileId,
          name: profileName.trim(),
          masterKeySaltSecureStorageAccessKey: '${profileId}_master_key_salt',
          masterKeyHashSecureStorageAccessKey: '${profileId}_master_key_hash',
          encryptionKeySaltSecureStorageAccessKey: '${profileId}_encryption_key_salt',
          createdAt: now,
          updatedAt: now,
          hasBiometricEnabled: false,
        );
      } else {
        return left(AppFailure(AppError.unknown));
      }

      // Check if the profile already exists (has salt in secure storage)
      // If it exists, use the existing salt to maintain encryption consistency
      final existingSaltEncoded = await secureStorage.readValue(key: profile.encryptionKeySaltSecureStorageAccessKey);
      final List<int> generatedSalt;
      final String saltEncoded;

      if (existingSaltEncoded != null) {
        // Profile already exists, use existing salt
        saltEncoded = existingSaltEncoded;
        generatedSalt = base64Decode(existingSaltEncoded);
      } else {
        // New profile, generate new salt
        generatedSalt = encryptionService.generateSalt();
        saltEncoded = base64Encode(generatedSalt);
        // Save the salt in the secure storage
        await secureStorage.writeValue(key: profile.encryptionKeySaltSecureStorageAccessKey, value: saltEncoded);
      }

      // Derive K_user from masterKey and salt (for encrypting K_hive)
      final userKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, generatedSalt);

      // Save the masterKey in secure storage as PBKDF2 only if it doesn't exist
      final existingMasterKeyHash = await secureStorage.readValue(key: profile.masterKeyHashSecureStorageAccessKey);
      if (existingMasterKeyHash == null) {
        await _saveMasterKeyPBKDF2(
          masterKeySaltSecureStorageAccessKey: profile.masterKeySaltSecureStorageAccessKey,
          masterKeyHashSecureStorageAccessKey: profile.masterKeyHashSecureStorageAccessKey,
          masterKey: masterKey,
        );
      }

      // Generate or retrieve K_hive (Hive encryption key)
      final encryptedHiveKeyStorageKey = _getEncryptedHiveKeyStorageKey(profile.id);
      final existingEncryptedHiveKey = await secureStorage.readValue(key: encryptedHiveKeyStorageKey);

      List<int> hiveKey;

      if (existingEncryptedHiveKey != null) {
        // Profile already exists, decrypt existing K_hive
        final encryptedData = jsonDecode(existingEncryptedHiveKey) as Map<String, dynamic>;
        hiveKey = await encryptionService.decryptWithAESGCM(
          ivBase64: encryptedData['iv'] as String,
          encryptedDataBase64: encryptedData['encryptedKey'] as String,
          key: userKey,
        );
      } else {
        // New profile, generate random K_hive (32 bytes for AES-256)
        hiveKey = encryptionService.generateRandomKey();

        // Encrypt K_hive with K_user
        final encryptedData = await encryptionService.encryptWithAESGCM(data: hiveKey, key: userKey);

        // Store encrypted K_hive in SecureStorage (without biometric protection)
        await secureStorage.writeValue(key: encryptedHiveKeyStorageKey, value: jsonEncode(encryptedData));
      }

      // Set K_hive in HiveDatabaseService
      // The hiveKey is only saved in temporal memory (RAM)
      hiveDatabase.setEncryptionKey(hiveKey, profile.id);

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

        // Derive K_user from masterKey and salt
        final userKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, saltDecode);

        // Retrieve and decrypt K_hive
        final encryptedHiveKeyStorageKey = _getEncryptedHiveKeyStorageKey(profile.id);
        final encryptedHiveKeyData = await secureStorage.readValue(key: encryptedHiveKeyStorageKey);

        if (encryptedHiveKeyData == null) {
          // If K_hive doesn't exist, this is an old profile or corrupted data
          hiveDatabase.setEncryptionKey(null, null);
          return left(AppFailure(AppError.encryptionKeyNotSet));
        }

        try {
          // Decrypt K_hive using K_user
          final encryptedData = jsonDecode(encryptedHiveKeyData) as Map<String, dynamic>;
          final hiveKey = await encryptionService.decryptWithAESGCM(
            ivBase64: encryptedData['iv'] as String,
            encryptedDataBase64: encryptedData['encryptedKey'] as String,
            key: userKey,
          );

          // Set K_hive in HiveDatabaseService
          hiveDatabase.setEncryptionKey(hiveKey, profile.id);
          // Open the encrypted boxes with K_hive
          await hiveDatabase.openEncryptedBoxes();
          return right(null);
        } catch (e) {
          // If decryption fails, the master key might be incorrect or data corrupted
          hiveDatabase.setEncryptionKey(null, null);
          return left(AppFailure(AppError.incorrectMasterKey, message: 'Error decrypting K_hive: ${e.toString()}'));
        }
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
      // Eliminar todas las entradas de contraseñas asociadas al perfil
      final passwordEntries = await passwordEntryProvider.getPasswordsEntries();
      for (var passwordEntry in passwordEntries) {
        await passwordEntryProvider.deletePasswordEntry(id: passwordEntry.id);
      }

      // Eliminar todos los grupos asociados al perfil
      final groups = await groupProvider.getGroups();
      for (var group in groups) {
        await groupProvider.deleteGroup(id: group.id);
      }

      // Eliminar las claves maestras del secure storage
      await secureStorage.deleteValue(key: profile.masterKeySaltSecureStorageAccessKey);
      await secureStorage.deleteValue(key: profile.masterKeyHashSecureStorageAccessKey);
      await secureStorage.deleteValue(key: profile.encryptionKeySaltSecureStorageAccessKey);

      // Eliminar K_hive cifrada (sin biométrica)
      final encryptedHiveKeyStorageKey = _getEncryptedHiveKeyStorageKey(profile.id);
      await secureStorage.deleteValue(key: encryptedHiveKeyStorageKey);

      // Eliminar deviceKey protegida por biométrica si existe
      final biometricHiveKeyStorageKey = _getBiometricHiveKeyStorageKey(profile.id);
      await secureStorage.deleteValue(key: biometricHiveKeyStorageKey);

      // Eliminar K_hive cifrada con deviceKey si existe
      final encryptedHiveKeyWithDeviceKeyStorageKey = _getEncryptedHiveKeyWithDeviceKeyStorageKey(profile.id);
      await secureStorage.deleteValue(key: encryptedHiveKeyWithDeviceKeyStorageKey);

      // Eliminar el perfil
      await profilesProvider.deleteProfile(id: profile.id);

      return right(null);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Flush and close boxes to ensure data is persisted
      final groupBox = hiveDatabase.getGroupBox;
      final passwordEntryBox = hiveDatabase.getPasswordEntryBox;
      final versionBox = hiveDatabase.getVersionBox;

      if (groupBox.isOpen) {
        await groupBox.flush();
        await groupBox.close();
      }

      if (passwordEntryBox.isOpen) {
        await passwordEntryBox.flush();
        await passwordEntryBox.close();
      }

      if (versionBox.isOpen) {
        await versionBox.flush();
        await versionBox.close();
      }

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
      final masterKeySalt = encryptionService.generateSalt();

      // Derive the encrypted masterKey by masterKey and salt
      final derivedEncryptionMasterKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, masterKeySalt);
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
      final derivedEncryptionMasterKey = await encryptionService.deriveEncryptionKeyAsync(
        masterKey,
        masterKeySaltDecode,
      );

      // Constant-time comparison to prevent timing attacks
      final storedHash = base64Decode(hashedMasterKeyEncode);
      const listEquality = ListEquality();
      return listEquality.equals(storedHash, derivedEncryptionMasterKey);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> enableBiometricAuth({
    required ProfileModel profile,
    required String masterKey,
  }) async {
    try {
      // Verify master key first
      final isMasterKeyValid = await _verifyMasterKeyPBKDF2(
        masterKeySaltSecureStorageAccessKey: profile.masterKeySaltSecureStorageAccessKey,
        masterKeyHashSecureStorageAccessKey: profile.masterKeyHashSecureStorageAccessKey,
        masterKey: masterKey,
      );

      if (!isMasterKeyValid) {
        return left(AppFailure(AppError.incorrectMasterKey));
      }

      // Get salt to derive K_user
      final saltEncoded = await secureStorage.readValue(key: profile.encryptionKeySaltSecureStorageAccessKey);
      if (saltEncoded == null) {
        return left(AppFailure(AppError.encryptionKeyNotSet));
      }

      final saltDecode = base64Decode(saltEncoded);

      // Derive K_user from masterKey
      final userKey = await encryptionService.deriveEncryptionKeyAsync(masterKey, saltDecode);

      // Retrieve encrypted K_hive
      final encryptedHiveKeyStorageKey = _getEncryptedHiveKeyStorageKey(profile.id);
      final encryptedHiveKeyData = await secureStorage.readValue(key: encryptedHiveKeyStorageKey);

      if (encryptedHiveKeyData == null) {
        return left(AppFailure(AppError.encryptionKeyNotSet));
      }

      // Decrypt K_hive using K_user
      final encryptedData = jsonDecode(encryptedHiveKeyData) as Map<String, dynamic>;
      final hiveKey = await encryptionService.decryptWithAESGCM(
        ivBase64: encryptedData['iv'] as String,
        encryptedDataBase64: encryptedData['encryptedKey'] as String,
        key: userKey,
      );

      // Generate deviceKey (random key to encrypt K_hive before storing with biometric)
      final deviceKey = encryptionService.generateRandomKey();

      // Encrypt K_hive with deviceKey using AES-GCM
      final encryptedWithDeviceKey = await encryptionService.encryptWithAESGCM(data: hiveKey, key: deviceKey);

      // Store encrypted K_hive (encrypted with deviceKey) in normal SecureStorage
      final encryptedHiveKeyWithDeviceKeyStorageKey = '${profile.id}_hive_key_encrypted_device';
      await secureStorage.writeValue(
        key: encryptedHiveKeyWithDeviceKeyStorageKey,
        value: jsonEncode(encryptedWithDeviceKey),
      );

      // Store deviceKey with biometric protection
      // The OS will encrypt this with an internal key and require biometric authentication to read it
      final biometricHiveKeyStorageKey = _getBiometricHiveKeyStorageKey(profile.id);
      await secureStorage.writeValue(key: biometricHiveKeyStorageKey, value: base64Encode(deviceKey));

      // Update profile to enable biometric
      final updatedProfile = profile.copyWith(hasBiometricEnabled: true);
      await profilesProvider.upsertProfile(profileModel: updatedProfile);
      return right(updatedProfile);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> disableBiometricAuth({required ProfileModel profile}) async {
    try {
      // Eliminar K_hive protegida por biométrica
      final biometricHiveKeyStorageKey = _getBiometricHiveKeyStorageKey(profile.id);
      await secureStorage.deleteValue(key: biometricHiveKeyStorageKey);

      // Actualizar el perfil para deshabilitar biométrica
      final updatedProfile = profile.copyWith(hasBiometricEnabled: false);
      await profilesProvider.upsertProfile(profileModel: updatedProfile);
      return right(updatedProfile);
    } catch (e) {
      return left(AppFailure(AppError.unknown, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlockHiveKeyWithBiometrics({required ProfileModel profile}) async {
    try {
      // Verificar explícitamente la biométrica antes de leer SecureStorage
      final didAuthenticate = await biometricAuthService.authenticateWithFingerprint(
        localizedReason: 'Authentication required to access ${profile.name}',
      );

      if (!didAuthenticate) {
        return left(AppFailure(AppError.biometricAuthFailed, message: 'Biometric authentication cancelled or failed'));
      }

      // Intentar leer deviceKey protegida por biométrica
      final biometricHiveKeyStorageKey = _getBiometricHiveKeyStorageKey(profile.id);
      final deviceKeyBase64 = await secureStorage.readValue(key: biometricHiveKeyStorageKey);

      if (deviceKeyBase64 == null) {
        // Si deviceKey es null, significa que no está disponible
        return left(AppFailure(AppError.encryptionKeyNotSet, message: 'deviceKey not available'));
      }

      // Decode deviceKey from base64
      final deviceKey = base64Decode(deviceKeyBase64);

      // Obtener K_hive cifrada con deviceKey
      final encryptedHiveKeyWithDeviceKeyStorageKey = _getEncryptedHiveKeyWithDeviceKeyStorageKey(profile.id);
      final encryptedHiveKeyWithDeviceKeyData = await secureStorage.readValue(
        key: encryptedHiveKeyWithDeviceKeyStorageKey,
      );

      if (encryptedHiveKeyWithDeviceKeyData == null) {
        return left(AppFailure(AppError.encryptionKeyNotSet, message: 'K_hive encrypted with deviceKey not available'));
      }

      // Descifrar K_hive usando deviceKey
      final encryptedData = jsonDecode(encryptedHiveKeyWithDeviceKeyData) as Map<String, dynamic>;
      final hiveKey = await encryptionService.decryptWithAESGCM(
        ivBase64: encryptedData['iv'] as String,
        encryptedDataBase64: encryptedData['encryptedKey'] as String,
        key: deviceKey,
      );

      // Set K_hive in HiveDatabaseService
      hiveDatabase.setEncryptionKey(hiveKey, profile.id);

      // Open the encrypted boxes with K_hive
      await hiveDatabase.openEncryptedBoxes();

      // Return success (Hive is now open and ready)
      return right(null);
    } catch (e) {
      // Si hay un error (por ejemplo, biométrica cancelada o fallida), retornar error
      return left(AppFailure(AppError.unknown, message: 'Error obtaining K_hive: ${e.toString()}'));
    }
  }
}

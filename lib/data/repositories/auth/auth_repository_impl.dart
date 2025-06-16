import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:custos/core/services/hive_database.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveDatabase hiveDatabase = di();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Future<bool> hasMasterKeyBeenSet() async {
    return await secureStorage.containsKey(key: saltKey);
  }

  @override
  Future<Either<Failure, void>> registerMasterKey(String password) async {
    final generatedSalt = _generateSalt();
    final saltEncoded = base64UrlEncode(generatedSalt);
    await secureStorage.write(key: saltKey, value: saltEncoded);

    final key = _deriveKey(password, generatedSalt);
    hiveDatabase.setEncryptionKey(key);

    final checkBox = await hiveDatabase.hive.openBox(
      checkBoxKey,
      encryptionCipher: HiveAesCipher(key),
    );

    await checkBox.put(checkKey, checkValue);
    await checkBox.close();

    return right(null);
  }

  @override
  Future<Either<Failure, void>> verifyMasterKey(String password) async {
    final salt = await secureStorage.read(key: saltKey);
    if (salt == null) {
      return left(AppFailure(AppError.masterKeyNotSet));
    }

    final key = _deriveKey(password, base64Url.decode(salt));
    hiveDatabase.setEncryptionKey(key);

    try {
      final checkBox = await hiveDatabase.hive.openBox(
        checkBoxKey,
        encryptionCipher: HiveAesCipher(key),
      );

      final check = checkBox.get(checkKey);
      await checkBox.close();

      if (check == checkValue) {
        await hiveDatabase.openEncryptedBoxes();
        return right(null);
      } else {
        return left(AppFailure(AppError.incorrectMasterKey));
      }
    } catch (_) {
      return left(AppFailure(AppError.incorrectMasterKey));
    }
  }

  List<int> _generateSalt([int length = 16]) {
    final rand = Random.secure();
    return List<int>.generate(length, (_) => rand.nextInt(256));
  }

  List<int> _deriveKey(String password, List<int> salt) {
    final hmac = Hmac(sha256, utf8.encode(password));
    final iterations = 100000;

    var block = hmac.convert(salt + _int32(1)).bytes;
    var result = List<int>.from(block);

    for (var i = 1; i < iterations; i++) {
      block = hmac.convert(block).bytes;
      for (var j = 0; j < result.length; j++) {
        result[j] ^= block[j];
      }
    }

    return result;
  }

  List<int> _int32(int i) {
    return [(i >> 24) & 0xff, (i >> 16) & 0xff, (i >> 8) & 0xff, i & 0xff];
  }

  @override
  Future<void> logout() async {
    hiveDatabase.getGroupBox.close();
    hiveDatabase.getPasswordEntryBox.close();
    hiveDatabase.setEncryptionKey(null);
  }
}

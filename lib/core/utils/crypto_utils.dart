import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// An auto generate list of byte to derive a key whit the masterKey
List<int> generateSalt([int length = 16]) {
  final rand = Random.secure();
  return List<int>.generate(length, (_) => rand.nextInt(256));
}

/// Derive a encryptionKey based on masterKey (introduce by user) and a salt
List<int> deriveEncryptionKey(String masterKey, List<int> salt) {
  final hmac = Hmac(sha256, utf8.encode(masterKey));
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

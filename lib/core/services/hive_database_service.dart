import 'dart:io';

import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/di_container.dart';
import 'package:hive_ce/hive.dart';

abstract class HiveDatabaseService {
  HiveInterface get hive;

  Future<void> init();

  void setEncryptionKey(List<int>? key);

  Future<void> setVerificationAuthValue();

  Future<bool> get verificationAuthIsCorrect;

  Future<void> openEncryptedBoxes();

  Box get getGroupBox;

  Box get getPasswordEntryBox;
}

// Box keys
const String authBoxKey = 'check';
const String groupBoxKey = 'group';
const String passwordEntryBoxKey = 'password_entry';

const String checkAuthKey = '__check__';
const String checkAuthValue = 'ok';

class HiveDatabaseServiceImpl extends HiveDatabaseService {
  HiveDatabaseServiceImpl(this._hive);

  final HiveInterface _hive;
  List<int>? _encryptionKey;

  @override
  HiveInterface get hive => _hive;

  @override
  Future<void> init() async {
    _hive.init(di<Directory>().path);

    _hive.registerAdapter(GroupModelAdapter());
    _hive.registerAdapter(PasswordEntryModelAdapter());
  }

  @override
  void setEncryptionKey(List<int>? key) {
    _encryptionKey = key;
  }

  // Open a Box whit the encryptionKey and save the value "ok" whit the id "__check__"
  @override
  Future<void> setVerificationAuthValue() async {
    final checkBox = await _hive.openBox(
      authBoxKey,
      encryptionCipher: HiveAesCipher(_encryptionKey!),
    );

    await checkBox.put(checkAuthKey, checkAuthValue);
    await checkBox.close();
  }

  @override
  Future<bool> get verificationAuthIsCorrect async {
    await _hive.openBox<dynamic>(
      authBoxKey,
      encryptionCipher: HiveAesCipher(_encryptionKey!),
    );

    Box authBox = _hive.box(authBoxKey);

    bool value = authBox.get(checkAuthKey) == checkAuthValue;
    authBox.close();

    return value;
  }

  @override
  Future<void> openEncryptedBoxes() async {
    _checkKey();

    await _hive.openBox<dynamic>(
      groupBoxKey,
      encryptionCipher: HiveAesCipher(_encryptionKey!),
    );

    await _hive.openBox<dynamic>(
      passwordEntryBoxKey,
      encryptionCipher: HiveAesCipher(_encryptionKey!),
    );
  }

  @override
  Box get getGroupBox {
    _checkKey();
    return _hive.box(groupBoxKey);
  }

  @override
  Box get getPasswordEntryBox {
    _checkKey();
    return _hive.box(passwordEntryBoxKey);
  }

  void _checkKey() {
    if (_encryptionKey == null) {
      throw Exception(
        'Master key has not been set. '
        'Please call setEncryptionKey() before accessing the boxes.',
      );
    }
  }
}

// import 'dart:io';

// import 'package:custos/data/models/group/group_model.dart';
// import 'package:custos/data/models/password_entry/password_entry_model.dart';
// import 'package:custos/di_container.dart';
// import 'package:hive_ce/hive.dart';

// abstract class HiveDatabase {
//   HiveInterface get hive;

//   Future<void> init();

//   Box get getGroupBox;
//   Box get getPasswordEntryBox;
// }

// const String groupBoxKey = 'group';
// const String passwordEntryBoxKey = 'password_entry';

// class HiveDatabaseImpl extends HiveDatabase {
//   HiveDatabaseImpl(this._hive);

//   final HiveInterface _hive;

//   bool _initialized = false;

//   @override
//   Future<void> init() async {
//     if (_initialized) return;

//     hive.init(di<Directory>().path);
//     hive.registerAdapter(GroupModelAdapter());
//     await hive.openBox<dynamic>(groupBoxKey);

//     hive.registerAdapter(PasswordEntryModelAdapter());
//     await hive.openBox<dynamic>(passwordEntryBoxKey);

//     _initialized = true;
//   }

//   @override
//   HiveInterface get hive => _hive;

//   @override
//   Box get getGroupBox => _hive.box(groupBoxKey);

//   @override
//   Box get getPasswordEntryBox => _hive.box(passwordEntryBoxKey);
// }

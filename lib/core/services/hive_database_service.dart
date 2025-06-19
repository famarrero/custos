import 'dart:io';

import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/di_container.dart';
import 'package:hive_ce/hive.dart';

abstract class HiveDatabaseService {
  HiveInterface get hive;

  Future<void> init();

  void setEncryptionKey(List<int>? key);

  Future<void> openEncryptedBoxes();

  Box get getGroupBox;

  Box get getPasswordEntryBox;
}

// Box keys
const String groupBoxKey = 'group';
const String passwordEntryBoxKey = 'password_entry';

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

  @override
  Future<void> openEncryptedBoxes() async {
    _checkKey();

    if (!_hive.isBoxOpen(groupBoxKey)) {
      await _hive.openBox<dynamic>(
        groupBoxKey,
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    }

    if (!_hive.isBoxOpen(passwordEntryBoxKey)) {
      await _hive.openBox<dynamic>(
        passwordEntryBoxKey,
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    }
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

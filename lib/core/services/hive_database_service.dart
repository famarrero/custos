import 'dart:io';

import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/di_container.dart';
import 'package:hive_ce/hive.dart';

abstract class HiveDatabaseService {
  HiveInterface get hive;

  Future<void> init();

  void setEncryptionKey(List<int>? key, String? profileId);

  Future<void> openEncryptedBoxes();

  Box get getProfileBox;

  Box get getGroupBox;

  Box get getPasswordEntryBox;
}

// Box keys
final String profileBoxKey = 'profile';

String groupBoxKey(String profileId) => '${profileId}_group';
String passwordEntryBoxKey(String profileId) => '${profileId}_password_entry';

class HiveDatabaseServiceImpl extends HiveDatabaseService {
  HiveDatabaseServiceImpl(this._hive);

  final HiveInterface _hive;
  List<int>? _encryptionKey;
  String? _profileId;

  @override
  HiveInterface get hive => _hive;

  @override
  Future<void> init() async {
    _hive.init(di<Directory>().path);

    _hive.registerAdapter(ProfileModelAdapter());
    _hive.registerAdapter(GroupModelAdapter());
    _hive.registerAdapter(PasswordEntryModelAdapter());

    if (!_hive.isBoxOpen(profileBoxKey)) {
      await _hive.openBox<dynamic>(profileBoxKey);
    }
  }

  @override
  void setEncryptionKey(List<int>? key, String? profileId) {
    _encryptionKey = key;
    _profileId = profileId;
  }

  @override
  Future<void> openEncryptedBoxes() async {
    _checkKey();

    if (!_hive.isBoxOpen(groupBoxKey(_profileId!))) {
      await _hive.openBox<dynamic>(
        groupBoxKey(_profileId!),
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    }

    if (!_hive.isBoxOpen(passwordEntryBoxKey(_profileId!))) {
      await _hive.openBox<dynamic>(
        passwordEntryBoxKey(_profileId!),
        encryptionCipher: HiveAesCipher(_encryptionKey!),
      );
    }
  }

  @override
  Box get getProfileBox {
    return _hive.box(profileBoxKey);
  }

  @override
  Box get getGroupBox {
    _checkKey();
    return _hive.box(groupBoxKey(_profileId!));
  }

  @override
  Box get getPasswordEntryBox {
    _checkKey();
    return _hive.box(passwordEntryBoxKey(_profileId!));
  }

  void _checkKey() {
    if (_encryptionKey == null || _profileId == null) {
      throw Exception(
        'Master key has not been set. '
        'Please call setEncryptionKey() before accessing the boxes.',
      );
    }
  }
}

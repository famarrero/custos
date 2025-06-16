import 'dart:io';

import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/di_container.dart';
import 'package:hive_ce/hive.dart';

abstract class HiveDatabase {
  HiveInterface get hive;

  Future<void> init();

  Box get getGroupBox;
  Box get getPasswordEntryBox;
}

const String groupBoxKey = 'group';
const String passwordEntryBoxKey = 'password_entry';

class HiveDatabaseImpl extends HiveDatabase {
  HiveDatabaseImpl(this._hive);

  final HiveInterface _hive;

  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    hive.init(di<Directory>().path);
    hive.registerAdapter(GroupModelAdapter());
    await hive.openBox<dynamic>(groupBoxKey);

    hive.registerAdapter(PasswordEntryModelAdapter());
    await hive.openBox<dynamic>(passwordEntryBoxKey);

    _initialized = true;
  }

  @override
  HiveInterface get hive => _hive;

  @override
  Box get getGroupBox => _hive.box(groupBoxKey);

  @override
  Box get getPasswordEntryBox => _hive.box(passwordEntryBoxKey);
}

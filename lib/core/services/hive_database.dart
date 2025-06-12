// import 'package:hive_flutter/hive_flutter.dart';

// abstract class HiveDatabase {
//   HiveInterface get hive;

//   Future<void> init();

//   Box get getFavoritesBox;
// }

// const String favoritesBoxKey = 'favoritesBox';

// class HiveDatabaseImpl extends HiveDatabase {
//   HiveDatabaseImpl(this._hive);

//   final HiveInterface _hive;

//   bool _initialized = false;

//   @override
//   Future<void> init() async {
//     if (_initialized) return;

//     await hive.initFlutter();
//     await hive.openBox<dynamic>(favoritesBoxKey);

//     _initialized = true;
//   }

//   @override
//   HiveInterface get hive => _hive;

//   @override
//   Box get getFavoritesBox => _hive.box(favoritesBoxKey);
// }

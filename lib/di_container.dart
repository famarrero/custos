import 'dart:io';

import 'package:custos/core/services/hive_database.dart';
import 'package:custos/core/services/logger_service.dart';
import 'package:custos/core/services/package_info_service.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/providers/group/group_provider_impl.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider_impl.dart';
import 'package:custos/data/providers/preferences/preferences_provider.dart';
import 'package:custos/data/providers/preferences/preferences_provider_impl.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/data/repositories/auth/auth_repository_impl.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/data/repositories/group/group_repository_impl.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository_impl.dart';
import 'package:custos/data/repositories/preferences/preferences_repository.dart';
import 'package:custos/data/repositories/preferences/preferences_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.instance;

Future initInjection() async {
  // Directory
  await registerStorageDirectory();

  // PackageInfo
  final packageInfo = await PackageInfo.fromPlatform();
  di.registerLazySingleton(() => packageInfo);

  /// SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);

  // Hive client
  final hiveDatabase = HiveDatabaseImpl(Hive);
  await hiveDatabase.init();
  di.registerSingleton<HiveDatabase>(hiveDatabase);

  ///-------------------Services--------------------------------///

  /// LoggerService
  di.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());

  /// PackageInfoService
  di.registerLazySingleton<PackageInfoService>(() => PackageInfoServiceImpl());

  ///-------------------Providers--------------------------------///

  /// PreferencesProvider
  di.registerLazySingleton<PreferencesProvider>(
    () => PreferencesProviderImpl(),
  );

  /// GroupProvider
  di.registerLazySingleton<GroupProvider>(() => GroupProviderImpl());

  /// PasswordEntryProvider
  di.registerLazySingleton<PasswordEntryProvider>(
    () => PasswordEntryProviderImpl(),
  );

  ///-------------------Repositories--------------------------------///

  /// PreferencesRepository
  GetIt.I.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(),
  );

  /// PreferencesRepository
  GetIt.I.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  /// GroupRepository
  GetIt.I.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl());

  /// PasswordEntryRepository
  GetIt.I.registerLazySingleton<PasswordEntryRepository>(
    () => PasswordEntryRepositoryImpl(),
  );
}

Future<void> registerStorageDirectory() async {
  if (Platform.isAndroid) {
    final Directory? dir = await getExternalStorageDirectory();
    if (dir != null) {
      di.registerLazySingleton(() => dir);
    }
  } else if (Platform.isIOS) {
    final Directory dir = await getApplicationDocumentsDirectory();
    di.registerLazySingleton(() => dir);
  }
}

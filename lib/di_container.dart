import 'dart:io';

import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/services/logger_service.dart';
import 'package:custos/core/services/package_info_service.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/providers/group/group_provider_impl.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider_impl.dart';
import 'package:custos/data/providers/preferences/preferences_provider.dart';
import 'package:custos/data/providers/preferences/preferences_provider_impl.dart';
import 'package:custos/data/providers/profiles/profiles_provider.dart';
import 'package:custos/data/providers/profiles/profiles_provider_impl.dart';
import 'package:custos/data/providers/secure_storage/secure_storage_provider.dart';
import 'package:custos/data/providers/secure_storage/secure_storage_provider_impl.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/data/repositories/auth/auth_repository_impl.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/data/repositories/group/group_repository_impl.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository_impl.dart';
import 'package:custos/data/repositories/preferences/preferences_repository.dart';
import 'package:custos/data/repositories/preferences/preferences_repository_impl.dart';
import 'package:custos/data/repositories/profiles/profiles_repository.dart';
import 'package:custos/data/repositories/profiles/profiles_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  /// SecureStorage
  final secureStorage = const FlutterSecureStorage();
  di.registerLazySingleton(() => secureStorage);

  // Hive client
  final hiveDatabase = HiveDatabaseServiceImpl(Hive);
  await hiveDatabase.init();
  di.registerSingleton<HiveDatabaseService>(hiveDatabase);

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

  /// SecureStorageProvider
  di.registerLazySingleton<SecureStorageProvider>(
    () => SecureStorageProviderImpl(),
  );

  /// ProfilesProvider
  di.registerLazySingleton<ProfilesProvider>(() => ProfilesProviderImpl());

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

  /// ProfilesRepository
  GetIt.I.registerLazySingleton<ProfilesRepository>(
    () => ProfilesRepositoryImpl(),
  );

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

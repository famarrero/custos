import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:custos/core/services/file_picker_service.dart';
import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/otp/otp_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/providers/otp/otp_provider.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/providers/profile/profile_provider.dart';
import 'package:custos/data/providers/version/version_provider.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/data/repositories/import_export/import_export_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'import_export_data_cubit.freezed.dart';
part 'import_export_data_state.dart';

class ImportExportDataCubit extends Cubit<ImportExportDataState> {
  ImportExportDataCubit()
    : super(
        ImportExportDataState(
          exportState: BaseState.initial(),
          importData: BaseState.initial(),
          importState: BaseState.initial(),
        ),
      );

  final HiveDatabaseService hiveDatabase = di();
  final ProfileProvider profilesProvider = di();
  final GroupProvider groupProvider = di();
  final VersionProvider versionProvider = di();
  final PasswordEntryProvider passwordEntryProvider = di();
  final OtpProvider otpProvider = di();
  final AuthRepository authRepository = di();
  final FilePickerService filePickerService = di();
  final ImportExportRepository importExportRepository = di();

  /// Exporta todos los datos del perfil actual a un archivo .custos encriptado
  ///
  /// El archivo se encripta con la master key proporcionada para garantizar seguridad.
  Future<void> exportProfileData({required ProfileModel profile, required String masterKey}) async {
    try {
      emit(state.copyWith(exportState: BaseState.loading()));

      // Obtener todos los grupos y entradas de contraseñas del perfil
      final groups = await groupProvider.getGroups();
      final passwordEntries = await passwordEntryProvider.getPasswordsEntries();
      final version = await versionProvider.getVersion();
      final otps = await otpProvider.getOtps();

      // Crear estructura de datos para exportar
      final exportData = {
        'version': version,
        'profile': profile.toJson(),
        'groups': groups.map((g) => g.toJson()).toList(),
        'passwordEntries': passwordEntries.map((pe) => pe.toJson()).toList(),
        'otps': otps.map((o) => o.toJson()).toList(),
      };

      // Convertir a JSON
      final jsonString = jsonEncode(exportData);

      // Encriptar los datos usando el repositorio
      final encryptionResult = await importExportRepository.encryptData(jsonData: jsonString, masterKey: masterKey);

      // Manejar resultado de encriptación
      await encryptionResult.fold(
        (failure) async {
          emit(state.copyWith(exportState: BaseState.error(failure)));
        },
        (encryptedFileData) async {
          // Convertir a JSON y escribir archivo
          final encryptedJsonString = jsonEncode(encryptedFileData);

          // Obtener directorio temporal
          final directory = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final fileName = 'custos_backup_dbv${version}_${profile.name.replaceAll(' ', '_')}_$timestamp.custos';
          final file = File('${directory.path}/$fileName');

          // Escribir archivo encriptado
          await file.writeAsString(encryptedJsonString);

          // Compartir archivo
          await Share.shareXFiles([XFile(file.path)], text: 'Exported data from Custos - ${profile.name}');

          // Consideramos éxito si el archivo se creó correctamente
          emit(state.copyWith(exportState: BaseState.data(true)));
        },
      );
    } catch (e) {
      emit(state.copyWith(exportState: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
    }
  }

  /// Carga un archivo .custos encriptado sin desencriptarlo
  ///
  /// Solo lee el archivo y almacena los datos encriptados en el estado.
  /// La desencriptación se hace en [importData] cuando se proporciona la master key.
  Future<void> loadImportDataFile() async {
    try {
      emit(state.copyWith(importData: BaseState.loading()));

      // Seleccionar archivo con validación de extensión
      final filePath = await filePickerService.pickFileWithExtensionValidation(expectedExtension: 'custos');

      // Leer archivo encriptado
      final file = File(filePath);
      final encryptedJsonString = await file.readAsString();

      // Parsear estructura del archivo encriptado
      final encryptedFileData = jsonDecode(encryptedJsonString) as Map<String, dynamic>;

      // Validar estructura del archivo encriptado usando el repositorio
      final validationResult = importExportRepository.validateEncryptedFileStructure(encryptedFileData);

      validationResult.fold(
        (failure) {
          emit(state.copyWith(importData: BaseState.error(failure)));
        },
        (_) {
          // Almacenar los datos encriptados en el estado (sin desencriptar todavía)
          // La desencriptación se hará en importData cuando se proporcione la master key
          emit(state.copyWith(importData: BaseState.data(encryptedFileData)));
        },
      );
    } on FilePickerCancelledException {
      // Si el usuario canceló la selección, no es un error
      emit(state.copyWith(importData: BaseState.initial()));
    } on FileExtensionException catch (e) {
      emit(state.copyWith(importData: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
    } catch (e) {
      emit(state.copyWith(importData: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
    }
  }

  /// Desencripta e importa los datos del archivo .custos
  ///
  /// Este método desencripta los datos encriptados almacenados en el estado
  /// usando la master key proporcionada y luego importa los datos a Hive.
  Future<void> importData({required String masterKey}) async {
    try {
      emit(state.copyWith(importState: BaseState.loading()));

      // Obtener datos encriptados del estado
      final encryptedFileData = state.importData.data;

      // Desencriptar los datos usando el repositorio
      final decryptionResult = await importExportRepository.decryptData(
        encryptedFileData: encryptedFileData,
        masterKey: masterKey,
      );

      // Manejar resultado de desencriptación
      await decryptionResult.fold(
        (failure) async {
          emit(state.copyWith(importState: BaseState.error(failure)));
        },
        (importData) async {
          // Obtener perfil del JSON desencriptado
          final profile = ProfileModel.fromJson(importData['profile'] as Map<String, dynamic>);

          // Registrar y verificar perfil con la master key
          await authRepository.registerProfileWhitMasterKey(importProfile: profile, masterKey: masterKey);
          await authRepository.verifyProfileByMasterKey(profile: profile, masterKey: masterKey);
          
          // Import database version
          final importedVersion = importData['version'] as int;
          final currentVersion = await versionProvider.getVersion();
          if (importedVersion > currentVersion) {
            await versionProvider.upsertVersion(version: importedVersion);
          }

          // Importar grupos y entradas de contraseñas y códigos de seguridad
          final groupsJson = importData['groups'] as List<dynamic>;
          final passwordEntriesJson = importData['passwordEntries'] as List<dynamic>;
          final otpsJson = importData['otps'] as List<dynamic>;

          final groups = groupsJson.map((g) => GroupModel.fromJson(g as Map<String, dynamic>)).toList();
          final passwordEntries =
              passwordEntriesJson.map((pe) => PasswordEntryModel.fromJson(pe as Map<String, dynamic>)).toList();
          final otps = otpsJson.map((o) => OtpModel.fromJson(o as Map<String, dynamic>)).toList();

          for (var group in groups) {
            await groupProvider.upsertGroupWithUpdatedAt(group: group);
          }
          for (var passwordEntry in passwordEntries) {
            await passwordEntryProvider.upsertPasswordEntryWithUpdatedAt(passwordEntry: passwordEntry);
          }
          for (var otp in otps) {
            await otpProvider.upsertOtpWithUpdatedAt(otp: otp);
          }

          // Flush boxes to ensure all imported data is persisted
          await hiveDatabase.getGroupBox.flush();
          await hiveDatabase.getPasswordEntryBox.flush();
          await hiveDatabase.getOtpBox.flush();
          await hiveDatabase.getVersionBox.flush();

          emit(state.copyWith(importState: BaseState.data(true)));
        },
      );
    } catch (e) {
      emit(state.copyWith(importState: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
    }
  }
}

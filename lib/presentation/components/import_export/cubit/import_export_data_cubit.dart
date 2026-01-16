import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/providers/password_entry/password_entry_provider.dart';
import 'package:custos/data/providers/profile/profile_provider.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:file_picker/file_picker.dart';
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
          importState: BaseState.initial(),
        ),
      );

  final HiveDatabaseService hiveDatabase = di();
  final ProfileProvider profilesProvider = di();
  final GroupProvider groupProvider = di();
  final PasswordEntryProvider passwordEntryProvider = di();
  final AuthRepository authRepository = di();

  /// Exporta todos los datos del perfil actual a un archivo .custos
  Future<void> exportProfileData({required ProfileModel profile}) async {
    try {
      emit(state.copyWith(exportState: BaseState.loading()));

      // Obtener todos los grupos y entradas de contraseñas del perfil
      final groups = await groupProvider.getGroups();
      final passwordEntries = await passwordEntryProvider.getPasswordsEntries();

      // Crear estructura de datos para exportar
      final exportData = {
        'version': '1.0',
        'profile': profile.toJson(),
        'groups': groups.map((g) => g.toJson()).toList(),
        'passwordEntries': passwordEntries.map((pe) => pe.toJson()).toList(),
      };

      // Convertir a JSON
      final jsonString = jsonEncode(exportData);

      // Obtener directorio temporal
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          'custos_backup_${profile.name.replaceAll(' ', '_')}_$timestamp.custos';
      final file = File('${directory.path}/$fileName');

      // Escribir archivo
      await file.writeAsString(jsonString);

      // Compartir archivo
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Exportación de datos Custos - ${profile.name}');

      // Consideramos éxito si el archivo se creó correctamente
      emit(state.copyWith(exportState: BaseState.data(true)));
    } catch (e) {
      emit(
        state.copyWith(
          exportState: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }

  /// Importa datos de un archivo .custos y los carga en la base de datos
  /// Requiere validar la master key del perfil importado
  Future<void> importProfileData({required String masterKey}) async {
    try {
      emit(state.copyWith(importState: BaseState.loading()));

      // Seleccionar archivo
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null || result.files.isEmpty) {
        emit(state.copyWith(importState: BaseState.initial()));
        return;
      }

      final platformFile = result.files.single;
      final filePath = platformFile.path;

      if (filePath == null) {
        emit(
          state.copyWith(
            importState: BaseState.error(
              AppFailure(
                AppError.unknown,
                message: 'No se pudo leer el archivo',
              ),
            ),
          ),
        );
        return;
      }

      // Validar extensión del archivo
      final extension = platformFile.extension?.toLowerCase();
      if (extension != 'custos') {
        emit(
          state.copyWith(
            importState: BaseState.error(
              AppFailure(
                AppError.unknown,
                message:
                    extension != null
                        ? 'El archivo debe tener extensión .custos. Extensión encontrada: .$extension'
                        : 'El archivo debe tener extensión .custos',
              ),
            ),
          ),
        );
        return;
      }

      // Leer archivo
      final file = File(filePath);
      final jsonString = await file.readAsString();

      // Parsear JSON
      final importData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validar versión (para futuras compatibilidades)
      final version = importData['version'] as String?;
      if (version != '1.0') {
        emit(
          state.copyWith(
            importState: BaseState.error(
              AppFailure(
                AppError.unknown,
                message: 'Versión de archivo no compatible: $version',
              ),
            ),
          ),
        );
        return;
      }

      // Obtener datos del perfil
      final profileJson = importData['profile'] as Map<String, dynamic>;
      final importedProfile = ProfileModel.fromJson(profileJson);

      // Verificar si el perfil ya existe en el sistema
      ProfileModel? existingProfile;
      try {
        existingProfile = await profilesProvider.getProfile(
          id: importedProfile.id,
        );
      } catch (e) {
        // El perfil no existe, continuamos
      }

      // Si el perfil existe, validar la master key antes de importar
      if (existingProfile != null) {
        final verifyResult = await authRepository.verifyProfileByMasterKey(
          profile: existingProfile,
          masterKey: masterKey,
        );

        await verifyResult.fold(
          (failure) async {
            emit(state.copyWith(importState: BaseState.error(failure)));
          },
          (_) async {
            // Si la validación es exitosa, proceder con la importación
            await _importData(importData, importedProfile, masterKey);
            emit(state.copyWith(importState: BaseState.data(true)));
          },
        );
      } else {
        // Si el perfil no existe, crear uno nuevo con la master key proporcionada
        // No validamos la master key del perfil importado porque no existe en el sistema
        await _importData(importData, importedProfile, masterKey);
        emit(state.copyWith(importState: BaseState.data(true)));
      }
    } catch (e) {
      emit(
        state.copyWith(
          importState: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }

  /// Importa los datos después de validar la master key
  /// Si el perfil ya existe, lo usa; si no, crea uno nuevo
  Future<void> _importData(
    Map<String, dynamic> importData,
    ProfileModel importedProfile,
    String masterKey,
  ) async {
    // Verificar si el perfil ya existe
    ProfileModel? existingProfile;
    try {
      existingProfile = await profilesProvider.getProfile(
        id: importedProfile.id,
      );
    } catch (e) {
      // El perfil no existe, continuamos
    }

    if (existingProfile == null) {
      // Crear nuevo perfil con la master key proporcionada
      // Usaremos el nombre del perfil importado, pero se generará un nuevo ID
      final result = await authRepository.registerProfileWhitMasterKey(
        profileName: importedProfile.name,
        masterKey: masterKey,
      );

      await result.fold((failure) => throw Exception(failure.message), (
        newProfile,
      ) async {
        // El perfil se ha creado y los boxes están abiertos
      });
    }
    // Si el perfil ya existe, la validación de master key ya se hizo antes
    // y los boxes ya están abiertos

    // Importar grupos (los IDs se mantienen del archivo exportado)
    final groupsJson = importData['groups'] as List<dynamic>? ?? [];
    for (final groupJson in groupsJson) {
      final group = GroupModel.fromJson(groupJson as Map<String, dynamic>);
      await groupProvider.upsertGroup(group: group);
    }

    // Importar entradas de contraseñas (los IDs se mantienen del archivo exportado)
    final passwordEntriesJson =
        importData['passwordEntries'] as List<dynamic>? ?? [];
    for (final passwordEntryJson in passwordEntriesJson) {
      final passwordEntry = PasswordEntryModel.fromJson(
        passwordEntryJson as Map<String, dynamic>,
      );
      await passwordEntryProvider.upsertPasswordEntry(
        passwordEntry: passwordEntry,
      );
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
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
          importData: BaseState.initial(),
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
  Future<void> importProfileData() async {
    try {
      emit(state.copyWith(importData: BaseState.loading()));

      // Seleccionar archivo
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null || result.files.isEmpty) {
        emit(state.copyWith(importData: BaseState.initial()));
        return;
      }

      final platformFile = result.files.single;
      final filePath = platformFile.path;

      if (filePath == null) {
        emit(
          state.copyWith(
            importData: BaseState.error(
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
            importData: BaseState.error(
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

      emit(state.copyWith(importData: BaseState.data(importData)));
    } catch (e) {
      emit(
        state.copyWith(
          importData: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }
}

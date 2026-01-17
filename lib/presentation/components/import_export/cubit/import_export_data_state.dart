part of 'import_export_data_cubit.dart';

@freezed
abstract class ImportExportDataState with _$ImportExportDataState {
  const ImportExportDataState._();

  const factory ImportExportDataState({
    required BaseState<bool> exportState,
    required BaseState<Map<String, dynamic>> importData,
    required BaseState<bool> importState,
  }) = _ImportExportDataState;
}

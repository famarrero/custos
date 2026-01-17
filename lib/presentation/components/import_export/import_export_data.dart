import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_circular_progress_indicator.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/components/import_export/components/import_master_key_dialg.dart';
import 'package:custos/presentation/components/import_export/cubit/import_export_data_cubit.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum ImportExportDataMode { import, export, both }

class ImportExportDataWidget extends StatelessWidget {
  const ImportExportDataWidget({super.key, this.importMode = ImportExportDataMode.both});

  final ImportExportDataMode importMode;

  @override
  Widget build(BuildContext context) {
    // Obtener el perfil del AuthCubit
    final authCubit = context.read<AuthCubit>();
    final currentProfile = authCubit.state.loginState.dataOrNull;

    return BlocListener<ImportExportDataCubit, ImportExportDataState>(
      listener: (context, state) {
        if (state.importData.isData) {
          context.pop();
          context.showCustomModalBottomSheet(
            title: 'Importar datos',
            child: BlocProvider.value(
              value: context.read<ImportExportDataCubit>(),
              child: ImportMasterKeyDialog(importData: state.importData.data),
            ),
          );
        }
        if (state.importState.isData) {
          context.pop();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: context.lg,
            children: [
              if (importMode == ImportExportDataMode.export || importMode == ImportExportDataMode.both) ...[
                // Botón Exportar
                Expanded(
                  child: CustomContainer(
                    child: BlocBuilder<ImportExportDataCubit, ImportExportDataState>(
                      builder: (context, state) {
                        return CustomInkWell(
                          onTap:
                              currentProfile != null
                                  ? () {
                                    context.read<ImportExportDataCubit>().exportProfileData(profile: currentProfile);
                                  }
                                  : null,
                          child: Padding(
                            padding: EdgeInsets.all(context.xl),
                            child: Column(
                              spacing: context.lg,
                              children: [
                                state.exportState.isLoading
                                    ? CustomCircularProgressIndicator(dimension: 32)
                                    : Icon(AppIcons.export, size: 32),
                                Text('Exportar datos'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],

              if (importMode == ImportExportDataMode.import || importMode == ImportExportDataMode.both) ...[
                // Botón Importar
                Expanded(
                  child: CustomContainer(
                    child: BlocBuilder<ImportExportDataCubit, ImportExportDataState>(
                      builder: (context, state) {
                        return CustomInkWell(
                          onTap: () {
                            context.read<ImportExportDataCubit>().loadImportDataFile();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(context.xl),
                            child: Column(
                              spacing: context.lg,
                              children: [
                                state.importState.isLoading
                                    ? CustomCircularProgressIndicator(dimension: 32)
                                    : Icon(AppIcons.import, size: 32),
                                Text('Importar datos'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: context.xxxl),
        ],
      ),
    );
  }
}

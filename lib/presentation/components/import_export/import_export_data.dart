import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/import_export/cubit/import_export_data_cubit.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum ImportExportDataMode { import, export, both }

class ImportExportDataWidget extends StatelessWidget {
  const ImportExportDataWidget({
    super.key,
    this.importMode = ImportExportDataMode.both,
  });

  final ImportExportDataMode importMode;

  Future<void> _showImportMasterKeyDialog(
    BuildContext context,
    ImportExportDataCubit cubit,
  ) async {
    final masterKeyController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool shouldClose = false;

    await context.showCustomModalBottomSheet(
      title: 'Importar datos',
      child: BlocListener<ImportExportDataCubit, ImportExportDataState>(
        bloc: cubit,
        listener: (context, state) {
          if (state.importState.isData && !shouldClose) {
            shouldClose = true;
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                context.pop();
                context.showSnackBar(message: 'Datos importados correctamente');
              }
            });
          }
        },
        child: BlocBuilder<ImportExportDataCubit, ImportExportDataState>(
          bloc: cubit,
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: context.lg,
                children: [
                  Text(
                    'Introduce la clave maestra del archivo de respaldo',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  CustomTextFormField(
                    controller: masterKeyController,
                    label: 'Clave maestra',
                    hint: 'Introduce tu clave maestra',
                    isRequired: true,
                    obscureText: true,
                    validator: context.validatePassword,
                  ),
                  CustomButton(
                    label: 'Importar',
                    isLoading: state.importState.isLoading,
                    infiniteWidth: true,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        cubit.importProfileData(
                          masterKey: masterKeyController.text.trim(),
                        );
                      }
                    },
                  ),
                  if (state.importState.isError)
                    Text(
                      state.importState.error.message ?? 'Error al importar',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (state.importState.isData)
                    Text(
                      'Datos importados correctamente',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImportExportDataCubit>();

    // Obtener el perfil del AuthCubit
    final authCubit = context.read<AuthCubit>();
    final currentProfile = authCubit.state.loginState.dataOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.lg,
          children: [
            if (importMode == ImportExportDataMode.import ||
                importMode == ImportExportDataMode.both) ...[
              // Botón Importar
              Expanded(
                child: CustomContainer(
                  child:
                      BlocBuilder<ImportExportDataCubit, ImportExportDataState>(
                        bloc: cubit,
                        builder: (context, state) {
                          return CustomInkWell(
                            onTap: () {
                              _showImportMasterKeyDialog(context, cubit);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(context.xl),
                              child: Column(
                                spacing: context.lg,
                                children: [
                                  Icon(AppIcons.import),
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

            if (importMode == ImportExportDataMode.export ||
                importMode == ImportExportDataMode.both) ...[
              // Botón Exportar
              Expanded(
                child: CustomContainer(
                  child:
                      BlocBuilder<ImportExportDataCubit, ImportExportDataState>(
                        bloc: cubit,
                        builder: (context, state) {
                          return CustomInkWell(
                            onTap:
                                currentProfile != null
                                    ? () {
                                      cubit.exportProfileData(
                                        profile: currentProfile,
                                      );
                                    }
                                    : null,
                            child: Padding(
                              padding: EdgeInsets.all(context.xl),
                              child: Column(
                                spacing: context.lg,
                                children: [
                                  Icon(AppIcons.export),
                                  Text('Exportar datos'),
                                  if (state.exportState.isLoading)
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: context.colorScheme.primary,
                                      ),
                                    ),
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
    );
  }
}

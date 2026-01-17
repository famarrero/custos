import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/import_export/cubit/import_export_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ImportMasterKeyDialog extends StatelessWidget {
  const ImportMasterKeyDialog({super.key, required this.importData});

  final Map<String, dynamic> importData;

  @override
  Widget build(BuildContext context) {
    final masterKeyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocConsumer<ImportExportDataCubit, ImportExportDataState>(
      listener: (context, state) {
        if (state.importState.isData) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: context.xxxl,
            children: [
              Text(
                'El archivo de respaldo está listo para ser importado. Introduce la clave maestra del perfil para continuar.',
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
                    context.read<ImportExportDataCubit>().importData(masterKey: masterKeyController.text.trim());
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
              ),
              if (state.importState.isError)
                Text(
                  state.importState.error.message ?? 'Error al importar',
                  style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              if (state.importState.isData)
                Text(
                  'Datos importados correctamente',
                  style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }
}

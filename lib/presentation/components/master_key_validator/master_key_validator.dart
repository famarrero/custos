import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/master_key_validator/cubit/master_key_validator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget que valida la master key del perfil actual
///
/// Muestra un diálogo para pedir la master key, la valida y
/// llama a [onMasterKeyValidated] con la master key si es correcta.
class MasterKeyValidator extends StatelessWidget {
  const MasterKeyValidator({super.key, required this.profile, required this.onMasterKeyValidated});

  final ProfileModel profile;
  final Function(String masterKey) onMasterKeyValidated;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final masterKeyController = TextEditingController();

    return BlocProvider(
      create: (_) => MasterKeyValidatorCubit(profile: profile),
      child: BlocListener<MasterKeyValidatorCubit, MasterKeyValidatorState>(
        listener: (context, state) {
          // Si la validación es exitosa, llamar al callback con la master key
          if (state.validationState.isData) {
            onMasterKeyValidated(state.validationState.data);
          }
        },
        child: BlocBuilder<MasterKeyValidatorCubit, MasterKeyValidatorState>(
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: context.xxxl,
                children: [
                  Text(
                    'Introduce tu clave maestra para continuar con la exportación',
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
                    errorText: state.validationState.isError ? state.validationState.error.message : null,
                  ),
                  CustomButton(
                    label: 'Continuar',
                    isLoading: state.validationState.isLoading,
                    infiniteWidth: true,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        context.read<MasterKeyValidatorCubit>().validateMasterKey(masterKeyController.text);
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

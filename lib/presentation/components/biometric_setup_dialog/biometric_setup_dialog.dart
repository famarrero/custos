import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/components/biometric_setup_dialog/cubit/biometric_setup_dialog_cubit.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Diálogo para configurar autenticación biométrica después del primer login
class BiometricSetupDialog extends StatefulWidget {
  const BiometricSetupDialog({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<BiometricSetupDialog> createState() => _BiometricSetupDialogState();
}

class _BiometricSetupDialogState extends State<BiometricSetupDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _masterKeyController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _masterKeyController = TextEditingController();
  }

  @override
  void dispose() {
    _masterKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BiometricSetupDialogCubit(profile: widget.profile),
      child: BlocListener<BiometricSetupDialogCubit, BiometricSetupDialogState>(
        listener: (context, state) {
          // Si hay un error, mostrarlo
          if (state.errorMessage != null) {
            context.showSnackBar(message: state.errorMessage!, isErrorMessage: true);
          }

          // Si se actualizó el perfil (habilitado o deshabilitado biométrica), actualizar AuthCubit y cerrar diálogo
          if (state.updatedProfile != null) {
            context.read<AuthCubit>().updateProfile(state.updatedProfile!);
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<BiometricSetupDialogCubit, BiometricSetupDialogState>(
          builder: (context, state) {
            final isBiometricEnabled = widget.profile.hasBiometricEnabled;

            return AlertDialog(
              title: Text(
                isBiometricEnabled ? 'Deshabilitar autenticación biométrica' : 'Configurar autenticación biométrica',
              ),
              content:
                  state.isChecking
                      ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Verificando disponibilidad...'),
                        ],
                      )
                      : isBiometricEnabled
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: context.md,
                        children: [
                          Text(
                            '¿Deseas deshabilitar la autenticación por huella digital para ${widget.profile.name}?',
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            'Deberás usar tu clave maestra para iniciar sesión cada vez.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      )
                      : state.isAvailable
                      ? state.showMasterKeyForm
                          ? Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: context.md,
                              children: [
                                Text(
                                  'Introduce tu clave maestra para configurar la autenticación biométrica',
                                  style: context.textTheme.bodyMedium,
                                ),
                                CustomTextFormField(
                                  controller: _masterKeyController,
                                  label: 'Clave maestra',
                                  hint: 'Introduce tu clave maestra',
                                  isRequired: true,
                                  obscureText: true,
                                  validator: context.validatePassword,
                                ),
                              ],
                            ),
                          )
                          : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: context.md,
                            children: [
                              Text(
                                '¿Deseas configurar autenticación por huella digital para acceder más rápido a ${widget.profile.name}?',
                                style: context.textTheme.bodyMedium,
                              ),
                              Text(
                                'Podrás usar tu huella digital para iniciar sesión en lugar de escribir tu clave maestra cada vez.',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          )
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: context.md,
                        children: [
                          Text(
                            'Tu dispositivo no tiene huella digital configurada o no es compatible.',
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            'Puedes configurar la biométrica en la configuración de tu dispositivo y volver a intentarlo.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
              actions: [
                if (!state.isChecking)
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
                if (isBiometricEnabled && !state.isChecking)
                  CustomButton(
                    label: 'Deshabilitar',
                    isLoading: state.isValidatingMasterKey,
                    onPressed: () => context.read<BiometricSetupDialogCubit>().disableBiometric(),
                  )
                else if (state.isAvailable && !state.isChecking)
                  CustomButton(
                    label: state.showMasterKeyForm ? 'Continuar' : 'Configurar huella digital',
                    isLoading: state.isValidatingMasterKey,
                    onPressed: () {
                      if (state.showMasterKeyForm) {
                        // Validar formulario antes de continuar
                        if (_formKey.currentState?.validate() == true) {
                          context.read<BiometricSetupDialogCubit>().enableBiometric(_masterKeyController.text);
                        }
                      } else {
                        // Mostrar formulario de master key
                        context.read<BiometricSetupDialogCubit>().showMasterKeyInput();
                      }
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

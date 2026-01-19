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
                isBiometricEnabled ? context.l10n.biometricSetupDisableTitle : context.l10n.biometricSetupEnableTitle,
              ),
              content:
                  state.isChecking
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(context.l10n.biometricSetupCheckingAvailability),
                        ],
                      )
                      : isBiometricEnabled
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: context.md,
                        children: [
                          Text(
                            context.l10n.biometricSetupDisableQuestion(widget.profile.name),
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            context.l10n.biometricSetupDisableSubtitle,
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
                                  context.l10n.biometricSetupEnableMasterKeyPrompt,
                                  style: context.textTheme.bodyMedium,
                                ),
                                CustomTextFormField(
                                  controller: _masterKeyController,
                                  label: context.l10n.fieldMasterKey,
                                  hint: context.l10n.loginProfileMasterKeyHint,
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
                                context.l10n.biometricSetupEnableQuestion(widget.profile.name),
                                style: context.textTheme.bodyMedium,
                              ),
                              Text(
                                context.l10n.biometricSetupEnableSubtitle,
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
                            context.l10n.biometricSetupNotAvailableTitle,
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            context.l10n.biometricSetupNotAvailableSubtitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
              actions: [
                if (!state.isChecking)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                if (isBiometricEnabled && !state.isChecking)
                  CustomButton(
                    label: context.l10n.biometricSetupDisableButton,
                    isLoading: state.isValidatingMasterKey,
                    onPressed: () => context.read<BiometricSetupDialogCubit>().disableBiometric(l10n: context.l10n),
                  )
                else if (state.isAvailable && !state.isChecking)
                  CustomButton(
                    label: state.showMasterKeyForm ? context.l10n.biometricSetupContinueButton : context.l10n.biometricSetupConfigureButton,
                    isLoading: state.isValidatingMasterKey,
                    onPressed: () {
                      if (state.showMasterKeyForm) {
                        // Validar formulario antes de continuar
                        if (_formKey.currentState?.validate() == true) {
                          context.read<BiometricSetupDialogCubit>().enableBiometric(_masterKeyController.text, l10n: context.l10n);
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

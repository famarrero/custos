import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginProfileWidget extends StatefulWidget {
  const LoginProfileWidget({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<LoginProfileWidget> createState() => _LoginProfileWidgetState();
}

class _LoginProfileWidgetState extends State<LoginProfileWidget> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _masterKeyController = TextEditingController();

  bool _showForgotMasterKeyInfo = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 24.0,
        children: [
          Column(
            children: [
              Text(
                'Hola ${widget.profile.name}',
                style: context.textTheme.titleMedium,
              ),
            ],
          ),

          CustomTextFormField(
            controller: _masterKeyController,
            label: context.l10n.fieldMasterKey,
            hint: 'Introduce tu clave maestra',
            isRequired: true,
            obscureText: true,
            validator: context.validatePassword,
          ),

          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomButton(
                label: context.l10n.loginButton,
                isLoading: state.loginState.isLoading,
                infiniteWidth: true,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    context.read<AuthCubit>().login(
                      GoRouter.of(context),
                      profile: widget.profile,
                      masterKey: _masterKeyController.text.trim(),
                    );

                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
              );
            },
          ),
          Column(
            spacing: context.lg,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(context.corner()),
                onTap:
                    _showForgotMasterKeyInfo
                        ? null
                        : () {
                          setState(
                            () =>
                                _showForgotMasterKeyInfo =
                                    !_showForgotMasterKeyInfo,
                          );
                        },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.xs),
                  child: Text(
                    '¿Olvidaste tu clave maestra?',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    _showForgotMasterKeyInfo
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.lg,
                            vertical: context.lg,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(
                              context.corner(),
                            ),
                          ),
                          child: Text(
                            'Lo sentimos ${widget.profile.name}, no hay nada que podamos hacer para ayudarte con tu clave maestra. Haz perdido todos tus datos y no podremos recuperarlos.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

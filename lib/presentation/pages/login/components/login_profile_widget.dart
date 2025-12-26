import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
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
                context.l10n.loginInProfileTitle,
                style: context.textTheme.titleMedium,
              ),
              Text(
                '(${widget.profile.name})',
                style: context.textTheme.bodyMedium,
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
        ],
      ),
    );
  }
}

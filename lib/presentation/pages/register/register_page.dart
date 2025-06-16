import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _masterKeyController = TextEditingController();

  final TextEditingController _repeatMasterKeyController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current.loginState.isError,
      listener: (context, state) {
        context.showSnackBar(
          isErrorMessage: true,
          message: context.localizeError(failure: state.loginState.error),
        );
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return ScaffoldWidget(
            padding: EdgeInsets.symmetric(
              vertical: kMobileVerticalPadding,
              horizontal: kMobileHorizontalPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24.0,
                children: [
                  CustomTextFormField(
                    controller: _masterKeyController,
                    label: 'Master key',
                    isRequired: true,
                    validator: context.validatePassword,
                  ),
                  CustomTextFormField(
                    controller: _repeatMasterKeyController,
                    label: 'Repeat master key',
                    isRequired: true,
                    validator:
                        (value) => context.validatePasswordMatch(
                          _masterKeyController.text.trim(),
                          value,
                        ),
                  ),
                  CustomButton(
                    label: 'Register',
                    infiniteWidth: true,
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        context.read<AuthCubit>().register(
                          masterKey: _masterKeyController.text.trim(),
                        );

                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

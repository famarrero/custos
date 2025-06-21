import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/register/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _profileNameController = TextEditingController();

  final TextEditingController _masterKeyController = TextEditingController();

  final TextEditingController _repeatMasterKeyController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegisterCubit, RegisterState>(
            listenWhen: (previous, current) => current.addProfile.isError,
            listener: (context, state) {
              context.showSnackBar(
                isErrorMessage: true,
                message: context.localizeError(failure: state.addProfile.error),
              );
            },
          ),
          BlocListener<RegisterCubit, RegisterState>(
            listenWhen: (previous, current) => current.addProfile.isData,
            listener: (context, state) {
              context.pop();
            },
          ),
        ],
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return ScaffoldWidget(
              appBar: AppBar(),
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
                      controller: _profileNameController,
                      label: 'Profile name',
                      isRequired: true,
                      validator: context.validateRequired,
                    ),
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
                      label: 'Create profile',
                      isLoading: state.addProfile.isLoading,
                      infiniteWidth: true,
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          context.read<RegisterCubit>().addProfile(
                            profileName: _profileNameController.text.trim(),
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
      ),
    );
  }
}

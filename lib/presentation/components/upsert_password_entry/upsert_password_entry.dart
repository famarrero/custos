import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/form/custom_dropdown.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/upsert_password_entry/cubit/upsert_password_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpsertPasswordEntry extends StatefulWidget {
  const UpsertPasswordEntry({super.key});

  @override
  State<UpsertPasswordEntry> createState() => _UpsertPasswordEntryState();
}

class _UpsertPasswordEntryState extends State<UpsertPasswordEntry> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpsertPasswordEntryCubit(),
      child: BlocConsumer<UpsertPasswordEntryCubit, UpsertPasswordEntryState>(
        listener: (context, state) {
          if (state.upsertPasswordEntryState.isData &&
              state.upsertPasswordEntryState.data) {
            context.pop();
          }
          if (state.upsertPasswordEntryState.isError) {
            context.pop();
            context.showSnackBar(
              isErrorMessage: true,
              message: context.localizeError(
                failure: state.upsertPasswordEntryState.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              spacing: 24.0,
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  label: 'Web or app name',
                  isRequired: true,
                  validator: context.validateRequired,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                ),
                CustomTextFormField(
                  controller: _urlController,
                  label: 'URL',
                  validator: context.validateURL,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.url,
                ),
                CustomTextFormField(
                  controller: _usernameController,
                  label: 'Username',
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                ),
                CustomTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  validator: context.validateEmail,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _passwordController,
                        label: 'Password',
                        isRequired: true,
                        validator: context.validateRequired,
                        textCapitalization: TextCapitalization.none,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.visiblePassword,
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.key,
                      iconColor: context.colorScheme.onPrimary,
                      backgroundColor: context.colorScheme.primary,
                      onTap: () {},
                    ),
                  ],
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: CustomDropdown<String>(
                        label: 'Group',
                        options: () => ['Social Networks', 'Work'],
                        itemBuilder: (item) => Text(item),
                        onValueUpdate: (value) {},
                      ),
                    ),
                    CustomIconButton(
                      icon: Icons.add,
                      iconColor: context.colorScheme.onPrimary,
                      backgroundColor: context.colorScheme.primary,
                      onTap: () {},
                    ),
                  ],
                ),
                CustomTextFormField(
                  controller: _noteController,
                  label: 'Note',
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.multiline,
                  onFieldSubmitted: (p0) => _upsertPasswordEntry(context),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 24.0,
                  children: [
                    // Cancel
                    CustomButton(
                      type: CustomTextButtonEnum.outlined,
                      label: 'Cancel',
                      onPressed: () => context.pop(),
                    ),

                    // Add/Edit password entry
                    CustomButton(
                      label: 'Add',
                      isLoading: state.upsertPasswordEntryState.isLoading,
                      onPressed: () => _upsertPasswordEntry(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _upsertPasswordEntry(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<UpsertPasswordEntryCubit>().upsertPasswordEntry(
        passwordEntry: PasswordEntryEntity(
          name: _nameController.text,
          url: _urlController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          note: _noteController.text,
          group: null,
        ),
      );

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

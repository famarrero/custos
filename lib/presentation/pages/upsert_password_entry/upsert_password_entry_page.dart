import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/form/custom_dropdown.dart';
import 'package:custos/presentation/components/form/custom_select_date_picker.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/password_generator/password_generator_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/components/upsert_group/upsert_group.dart';
import 'package:custos/presentation/pages/upsert_password_entry/cubit/upsert_password_entry_cubit.dart';
import 'package:custos/presentation/pages/groups/components/group_tile.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class UpsertPasswordEntryPage extends StatefulWidget {
  const UpsertPasswordEntryPage({super.key, required this.id});

  final String id;

  @override
  State<UpsertPasswordEntryPage> createState() => _UpsertPasswordEntryPageState();
}

class _UpsertPasswordEntryPageState extends State<UpsertPasswordEntryPage> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  GroupEntity? _selectedGroup;
  DateTime? _expirationDate;

  bool _isInitialized = false;
  bool _isAdd = false;

  @override
  void initState() {
    super.initState();
    _isAdd = widget.id == UpsertPasswordEntryCubit.addUserId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpsertPasswordEntryCubit(id: widget.id),
      child: ScaffoldWidget(
        safeAreaTop: true,
        appBar: CustomAppBar(
          titleString:
              _isAdd ? context.l10n.upsertPasswordAddAccountTitle : context.l10n.upsertPasswordEditAccountTitle,
        ),
        padding: EdgeInsets.symmetric(horizontal: context.xxxl),
        child: BlocConsumer<UpsertPasswordEntryCubit, UpsertPasswordEntryState>(
          listener: (context, state) {
            if (state.upsertPasswordEntryState.isError) {
              context.pop();
              context.showSnackBar(
                isErrorMessage: true,
                message: context.localizeError(failure: state.upsertPasswordEntryState.error),
              );
            }
            if (state.upsertPasswordEntryState.isData && state.upsertPasswordEntryState.data) {
              context.pop();
            }
          },
          builder: (context, state) {
            return BaseStateUi(
              state: state.getPasswordEntryState,
              onRetryPressed: () => context.read<UpsertPasswordEntryCubit>().getPasswordEntry(id: widget.id),
              onDataChild: (passwordEntry) {
                // Set controllers with existing password entry data
                if (!_isInitialized) {
                  _nameController.text = passwordEntry.name;
                  _urlController.text = passwordEntry.url ?? '';
                  _usernameController.text = passwordEntry.username ?? '';
                  _emailController.text = passwordEntry.email ?? '';
                  _phoneController.text = passwordEntry.phone ?? '';
                  _passwordController.text = passwordEntry.password;
                  _noteController.text = passwordEntry.note ?? '';
                  _selectedGroup = passwordEntry.group;
                  _expirationDate = passwordEntry.expirationDate;
                  _isInitialized = true;
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: context.xxl,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: context.xl),
                                child: CustomTextFormField(
                                  controller: _nameController,
                                  label: context.l10n.upsertPasswordWebOrAppNameLabel,
                                  hint: context.l10n.upsertPasswordWebOrAppNameHint,
                                  isRequired: true,
                                  validator: context.validateRequired,
                                  textCapitalization: TextCapitalization.sentences,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                ),
                              ),
                              CustomTextFormField(
                                controller: _urlController,
                                label: context.l10n.fieldUrl,
                                hint: context.l10n.fieldUrlHint,
                                validator: context.validateURL,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.url,
                              ),
                              CustomTextFormField(
                                controller: _usernameController,
                                label: context.l10n.fieldUsername,
                                hint: context.l10n.fieldUsernameHint,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.text,
                              ),
                              CustomTextFormField(
                                controller: _emailController,
                                label: context.l10n.fieldEmail,
                                hint: context.l10n.fieldEmailHint,
                                validator: context.validateEmail,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                              ),
                              CustomTextFormField(
                                controller: _phoneController,
                                label: context.l10n.fieldPhone,
                                hint: context.l10n.fieldPhoneHint,
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.phone,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: _passwordController,
                                      label: context.l10n.fieldPassword,
                                      hint: context.l10n.fieldPasswordHint,
                                      isRequired: true,
                                      validator: context.validateRequired,
                                      textCapitalization: TextCapitalization.none,
                                      obscureText: true,
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.visiblePassword,
                                      onChanged: (_) {
                                        setState(() {
                                          _expirationDate = null;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: context.m),
                                    child: CustomIconButton(
                                      icon: AppIcons.key,
                                      iconColor: Colors.white,
                                      backgroundColor: context.colorScheme.primary,
                                      onTap: () async {
                                        final generatedPassword = await context.showCustomModalBottomSheet<String>(
                                          title: context.l10n.upsertPasswordGeneratePasswordTitle,
                                          child: const PasswordGeneratorWidget(),
                                        );

                                        setState(() {
                                          _expirationDate = null;
                                        });
                                        if (generatedPassword == null) return;
                                        _passwordController.text = generatedPassword;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                spacing: 8.0,
                                children: [
                                  if (state.groups.isLoading)
                                    const CircularProgressIndicator()
                                  else if (state.groups.isError)
                                    CustomButton(
                                      type: CustomTextButtonEnum.outlined,
                                      label: context.l10n.retry,
                                      onPressed: () => context.read<UpsertPasswordEntryCubit>().watchGroups(),
                                    )
                                  else if (state.groups.isData)
                                    Expanded(
                                      child: CustomDropdown<GroupEntity>(
                                        label: context.l10n.fieldGroup,
                                        hint: context.l10n.fieldGroupHint,
                                        value: _selectedGroup,
                                        options: () => state.groups.data,
                                        itemBuilder: (item) => GroupTile(group: item, compact: true),
                                        onValueUpdate: (value) {
                                          setState(() {
                                            _selectedGroup = value;
                                          });
                                        },
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: context.m),
                                    child: CustomIconButton(
                                      icon: AppIcons.add,
                                      iconColor: Colors.white,
                                      backgroundColor: context.colorScheme.primary,
                                      onTap: () {
                                        context.showCustomGeneralDialog(
                                          title: context.l10n.groupsAddGroupTitle,
                                          child: const UpsertGroup(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              CustomSelectDatePicker(
                                label: context.l10n.fieldExpirationDateLabel,
                                hint: context.l10n.fieldExpirationDateHint,
                                // firstDate: DateTime(2024, 1, 1),
                                firstDate: DateTime.now(),
                                value: _expirationDate,
                                allowClear: true,
                                onValueUpdate: (value) {
                                  setState(() {
                                    _expirationDate = value;
                                  });
                                },
                              ),

                              Padding(
                                padding: EdgeInsets.only(bottom: context.xxl),
                                child: CustomTextFormField(
                                  controller: _noteController,
                                  label: context.l10n.fieldNote,
                                  hint: context.l10n.fieldNoteHint,
                                  textCapitalization: TextCapitalization.sentences,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.done,
                                  textInputType: TextInputType.multiline,
                                  onFieldSubmitted: (p0) => _upsertPasswordEntry(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: context.s),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24.0,
                        children: [
                          // Cancel
                          CustomButton(
                            type: CustomTextButtonEnum.outlined,
                            label: context.l10n.cancel,
                            onPressed: () => context.pop(),
                          ),

                          // Add/Edit password entry
                          CustomButton(
                            label: _isAdd ? context.l10n.add : context.l10n.edit,
                            isLoading: state.upsertPasswordEntryState.isLoading,
                            onPressed: () => _upsertPasswordEntry(context),
                          ),
                        ],
                      ),

                      SizedBox(height: context.xl),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _upsertPasswordEntry(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<UpsertPasswordEntryCubit>().upsertPasswordEntry(
        passwordEntry: PasswordEntryEntity(
          id: _isAdd ? Uuid().v4() : widget.id,
          name: _nameController.text,
          url: _urlController.text,
          username: _usernameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          note: _noteController.text,
          group: _selectedGroup,
          expirationDate: _expirationDate?.toUtc(),
        ),
      );

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}

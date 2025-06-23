import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_color_picker.dart';
import 'package:custos/presentation/components/form/custom_icon_picker.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/upsert_group/cubit/upsert_group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class UpsertGroup extends StatefulWidget {
  const UpsertGroup({super.key});

  @override
  State<UpsertGroup> createState() => _UpsertGroupState();
}

class _UpsertGroupState extends State<UpsertGroup> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  Color? _color;
  IconData? _icon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpsertGroupCubit(),
      child: BlocConsumer<UpsertGroupCubit, UpsertGroupState>(
        listener: (context, state) {
          if (state.upsertGroupState.isData && state.upsertGroupState.data) {
            context.pop();
          }
          if (state.upsertGroupState.isError) {
            context.pop();
            context.showSnackBar(
              isErrorMessage: true,
              message: context.localizeError(
                failure: state.upsertGroupState.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24.0,
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  label: 'Group name',
                  isRequired: true,
                  validator: context.validateRequired,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                ),

                CustomIconPicker(
                  label: 'Select icon for group',
                  selectedIcon: _icon,
                  onIconSelected: (icon) {
                    setState(() {
                      _icon = icon;
                    });
                  },
                ),

                CustomColorPicker(
                  label: 'Select color for group',
                  selectedColor: _color,
                  onColorSelected: (color) {
                    setState(() {
                      _color = color;
                    });
                  },
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

                    // Add/Edit group
                    CustomButton(
                      label: 'Add',
                      isLoading: state.upsertGroupState.isLoading,
                      onPressed: () => _upsertGroup(context),
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

  void _upsertGroup(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<UpsertGroupCubit>().upsertPasswordEntry(
        group: GroupEntity(
          id: Uuid().v4(),
          name: _nameController.text,
          icon: _icon,
          color: _color,
        ),
      );

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

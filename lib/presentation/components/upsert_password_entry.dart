import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/form/custom_dropdown.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class UpsertPasswordEntry extends StatelessWidget {
  const UpsertPasswordEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24.0,
      children: [
        CustomTextFormField(
          label: 'Web or app name',
          isRequired: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        CustomTextFormField(
          label: 'Username',
          textCapitalization: TextCapitalization.none,
        ),
        CustomTextFormField(label: 'Email'),
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: CustomTextFormField(
                label: 'Password',
                isRequired: true,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
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
          label: 'Note',
          textCapitalization: TextCapitalization.sentences,
          maxLines: 4,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24.0,
          children: [
            CustomButton(
              type: CustomTextButtonEnum.outlined,
              label: 'Cancel',
              onPressed: () {},
            ),
            CustomButton(label: 'Add', onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

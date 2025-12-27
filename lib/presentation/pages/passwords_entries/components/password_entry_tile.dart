import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/datetime_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_badge.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordEntryTile extends StatelessWidget {
  const PasswordEntryTile({super.key, required this.passwordEntry});

  final PasswordEntryEntity passwordEntry;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      padding: EdgeInsets.zero,
      onTap:
          () => context.showCustomModalBottomSheet(
            child: PasswordEntryDetail(passwordEntry: passwordEntry),
          ),
      child: CustomContainer(
        // padding: EdgeInsets.symmetric(
        //   vertical: context.xxl,
        //   horizontal: context.xxl,
        // ),
        child: Column(
          spacing: context.sm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.xxl,
                horizontal: context.xxl,
              ),
              child: Row(
                spacing: 16.0,
                children: [
                  AvatarWidget(
                    size: 42.0,
                    color: passwordEntry.group?.color,
                    name: passwordEntry.name,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (passwordEntry.group != null)
                          CustomBadge(
                            icon: passwordEntry.group!.icon,
                            text: passwordEntry.group!.name,
                            color: passwordEntry.group!.color,
                            height: 18,
                            corner: context.corner() * 0.4,
                          ),
                        Text(
                          passwordEntry.name,
                          style: context.textTheme.bodyLarge,
                        ),
                        if (passwordEntry.username.isNotNullAndNotEmpty)
                          Text(
                            passwordEntry.username!,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: passwordEntry.password),
                      );
                      context.showSnackBar(
                        message: context.l10n.passwordCopiedToClipboard,
                      );
                    },
                    child: Icon(
                      AppIcons.copy,
                      color: context.colorScheme.secondary,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            if (passwordEntry.expirationDate != null &&
                passwordEntry.expirationDate!.isBefore(DateTime.now()))
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: context.sm,
                  horizontal: context.sm,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.errorContainer,
                ),
                child: Center(
                  child: Text(
                    'Contraseña expirada el: ${passwordEntry.expirationDate?.formatDate}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

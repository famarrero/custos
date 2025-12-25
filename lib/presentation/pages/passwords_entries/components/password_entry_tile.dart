import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/avatar_widget.dart';
import 'package:custos/presentation/components/custom_badge.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordEntryTile extends StatelessWidget {
  const PasswordEntryTile({super.key, required this.passwordEntry});

  final PasswordEntryEntity passwordEntry;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap:
          () => context.showCustomModalBottomSheet(
            child: PasswordEntryDetail(passwordEntry: passwordEntry),
          ),
      child: Row(
        spacing: 16.0,
        children: [
          AvatarWidget(
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
                    hideBackground: true,
                    height: 18,
                    corner: kMobileCorner * 0.4,
                  ),
                Text(passwordEntry.name, style: context.textTheme.bodyLarge),
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
              Clipboard.setData(ClipboardData(text: passwordEntry.password));
              context.showSnackBar(
                message: context.l10n.passwordCopiedToClipboard,
              );
            },
            child: Icon(HugeIcons.strokeRoundedCopy01, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

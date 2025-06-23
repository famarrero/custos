import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/custom_badge.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordEntryTile extends StatelessWidget {
  const PasswordEntryTile({super.key, required this.passwordEntry});

  final PasswordEntryEntity passwordEntry;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 22.0,
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                passwordEntry.group?.color?.withValues(alpha: 0.6) ??
                context.colorScheme.primary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(kMobileCorner),
          ),
          child: SizedBox.square(
            dimension: 44.0,
            child: Center(
              child: Text(
                passwordEntry.name.firstLetterToUpperCase,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.blackAndWith,
                ),
              ),
            ),
          ),
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
        Icon(HugeIcons.strokeRoundedCopy01, color: Colors.grey),
      ],
    );
  }
}

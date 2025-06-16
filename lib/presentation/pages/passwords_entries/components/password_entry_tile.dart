import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:flutter/material.dart';

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
            color: context.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(kMobileCorner),
          ),
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.place_outlined,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
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
        Icon(Icons.copy, color: Colors.grey),
      ],
    );
  }
}

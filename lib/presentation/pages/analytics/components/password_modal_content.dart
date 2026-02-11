import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_tile.dart';
import 'package:flutter/material.dart';

class PasswordsModalContent extends StatelessWidget {
  const PasswordsModalContent({
    super.key,
    required this.entries,
    required this.color,
    required this.subtitle,
    this.info,
  });

  final List<PasswordEntryEntity> entries;
  final Color color;
  final String subtitle;
  final String? info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(context.xl),
        child: Center(
          child: Text(
            'No hay entradas en esta categoría',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: context.sm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            SizedBox(width: context.sm),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        if (info.isNotNullAndNotEmpty) ...[
          SizedBox(height: context.sm),
          Text(info!, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
        SizedBox(height: context.sm),
        ...entries.map(
          (e) =>
              Padding(padding: EdgeInsets.symmetric(vertical: context.sm), child: PasswordEntryTile(passwordEntry: e)),
        ),
      ],
    );
  }
}

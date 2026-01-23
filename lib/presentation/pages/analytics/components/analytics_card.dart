import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/pages/passwords_entries/components/password_entry_tile.dart';
import 'package:flutter/material.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.title,
    required this.passwordEntries,
  });

  final String title;
  final List<PasswordEntryEntity> passwordEntries;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.only(bottom: context.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.xl),
            child: Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (passwordEntries.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.xl,
                vertical: context.lg,
              ),
              child: Text(
                'No hay elementos',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.xl),
              child: Column(
                children: passwordEntries.asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < passwordEntries.length - 1 ? context.s : 0,
                    ),
                    child: PasswordEntryTile(passwordEntry: entry.value),
                  );
                }).toList(),
              ),
            ),
          SizedBox(height: context.xl),
        ],
      ),
    );
  }
}

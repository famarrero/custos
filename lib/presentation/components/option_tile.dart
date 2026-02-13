import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({super.key, required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.corner()),
        child: Padding(
          padding: EdgeInsets.all(context.xl),
          child: Row(
            spacing: context.md,
            children: [
              Icon(icon, color: context.colorScheme.primary),
              Expanded(child: Text(title, style: context.textTheme.bodyLarge)),
              Icon(AppIcons.chevronRight, color: context.colorScheme.onSurface.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

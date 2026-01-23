import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: EdgeInsets.symmetric(horizontal: context.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.analytics,
              size: 64,
              color: context.colorScheme.primary.withValues(alpha: 0.6),
            ),
            SizedBox(height: context.lg),
            Text(
              'Analytics',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.s),
            Text(
              'Contenido próximamente',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key, this.icon, required this.text});

  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.lg,
        vertical: context.lg,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.warningContainer,
        borderRadius: BorderRadius.circular(context.corner()),
      ),
      child: Row(
        spacing: 12.0,
        children: [
          Icon(
            icon ?? AppIcons.warning,
            color: context.colorScheme.waring,
            size: 28.0,
          ),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.waring,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

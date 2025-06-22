import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key, this.icon, required this.text});

  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      children: [
        Icon(
          icon ?? HugeIcons.strokeRoundedAlert02,
          color: context.colorScheme.waring,
          size: 28.0,
        ),
        Expanded(child: Text(text, style: context.textTheme.labelMedium)),
      ],
    );
  }
}

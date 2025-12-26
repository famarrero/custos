import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({
    super.key,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    required this.onTap,
  });

  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: AppIcons.close,
      iconColor: iconColor ?? Colors.white,
      backgroundColor:
          backgroundColor ??
          context.colorScheme.secondary.withValues(alpha: 0.6),
      iconSize: iconSize ?? 18.0,
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:custos/core/utils/app_spacing.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
    this.borderRadius,
    required this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final double? borderRadius;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            backgroundColor != null
                ? EdgeInsets.all(context.m)
                : EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(borderRadius ?? context.corner(0.8)),
          color: backgroundColor,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
                ? const EdgeInsets.all(8.0)
                : EdgeInsets.zero,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}

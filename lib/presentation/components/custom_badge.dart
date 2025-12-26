import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    this.color,
    this.icon,
    this.text,
    this.corner,
    this.style,
    this.height = 32,
    this.iconSize = 14,
    this.applyAlpha = true,
    this.hideBackground = false,
    this.margin,
  });

  final Color? color;
  final IconData? icon;
  final String? text;
  final double height;
  final double? corner;
  final double iconSize;
  final TextStyle? style;
  final bool applyAlpha;
  final bool hideBackground;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? EdgeInsets.symmetric(vertical: context.xs),
      padding: EdgeInsets.symmetric(horizontal: context.sm),
      decoration: BoxDecoration(
        color:
            hideBackground
                ? null
                : (color ??
                    context.colorScheme.primary),
        borderRadius: BorderRadius.all(
          Radius.circular(corner ?? (context.corner() * 0.6)),
        ),
        border: Border.all(
          color:
              color ??
              context.colorScheme.primary,
          width: context.border() * 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            FittedBox(
              child: Icon(
                icon,
                color: hideBackground ? color : Colors.white,
                size: iconSize,
              ),
            ),
          if (text != null && text!.isNotEmpty)
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: context.sm, right: context.sm),
                child: Text(
                  text ?? '',
                  maxLines: 1,
                  style:
                      style ??
                      context.textTheme.labelSmall?.copyWith(
                        color: hideBackground ? color : Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

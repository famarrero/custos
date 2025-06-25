import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    this.color,
    this.icon,
    this.text,
    this.corner,
    this.style,
    this.height = 21,
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
    final alpha = applyAlpha ? 40 : 255;
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color:
            hideBackground
                ? null
                : (color?.withAlpha(alpha) ??
                    context.colorScheme.primary.withAlpha(alpha)),
        borderRadius: BorderRadius.all(
          Radius.circular(corner ?? kMobileCorner),
        ),
        border: Border.all(
          color:
              color?.withAlpha(alpha) ??
              context.colorScheme.primary.withAlpha(alpha),
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
                color: color ?? context.colorScheme.secondary,
                size: iconSize,
              ),
            ),
          if (text != null && text!.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: Text(
                  text ?? '',
                  maxLines: 1,
                  style:
                      style ??
                      context.textTheme.labelSmall?.copyWith(
                        color: color ?? context.colorScheme.primary,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

/// A reusable container with app-default corner radius and an optional primary border.
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.corner,
    this.borderColor,
    this.borderWidth,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? corner;
  final Color? borderColor;
  final double? borderWidth;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveCorner = corner ?? context.corner();
    final effectiveBorderWidth = borderWidth ?? context.border();
    final effectiveBorderColor =
        borderColor ?? context.colorScheme.primary.withValues(alpha: 0.2);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(effectiveCorner),
      side: BorderSide(
        color: effectiveBorderColor,
        width: effectiveBorderWidth,
        style: BorderStyle.solid,
      ),
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color:
            backgroundColor ??
            (Theme.of(context).brightness == Brightness.light
                ? context.colorScheme.surfaceContainerLowest
                : context.colorScheme.surfaceContainerHigh),
        shape: shape,

        shadowColor: Colors.black,
        clipBehavior: clipBehavior,
        child:
            padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
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
    this.showBorder = true,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? corner;
  final Color? borderColor;
  final double? borderWidth;
  final bool showBorder;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveCorner = corner ?? kMobileCorner;
    final effectiveBorderWidth = borderWidth ?? kMobileBorderSideWidth;
    final effectiveBorderColor = (borderColor ?? context.colorScheme.primary).withValues(alpha: 0.8);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(effectiveCorner),
      side:
          showBorder
              ? BorderSide(
                color: effectiveBorderColor,
                width: effectiveBorderWidth,
              )
              : BorderSide.none,
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        shape: shape,
        clipBehavior: clipBehavior,
        child:
            padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

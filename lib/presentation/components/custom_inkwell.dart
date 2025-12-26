import 'package:flutter/material.dart';
import 'package:custos/core/utils/app_spacing.dart';

/// Standardized InkWell wrapper that guarantees a [Material] ancestor and
/// applies padding around the [child].
class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.corner,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.enableFeedback = true,
    this.hideGradient = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final double? corner;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final bool enableFeedback;
  final bool hideGradient;
  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(corner ?? context.corner());
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: context.xs, vertical: context.m);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveBorderRadius,
        splashColor: hideGradient ? Colors.transparent : splashColor,
        highlightColor: hideGradient ? Colors.transparent : highlightColor,
        hoverColor: hideGradient ? Colors.transparent : null,
        onTap: onTap,
        onLongPress: onLongPress,
        enableFeedback: enableFeedback,
        child: Padding(padding: effectivePadding, child: child),
      ),
    );
  }
}

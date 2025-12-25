import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';

/// Standardized InkWell wrapper that guarantees a [Material] ancestor and
/// applies padding around the [child].
class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
    this.corner,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.enableFeedback = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final double? corner;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(corner ?? kMobileCorner);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: effectiveBorderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor,
        highlightColor: highlightColor,
        enableFeedback: enableFeedback,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

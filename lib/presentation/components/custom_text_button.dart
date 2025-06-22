import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';

/// A custom [CustomTextButton] used throughout the app.
class CustomTextButton extends StatelessWidget {
  /// Text use in the [TextButton]
  final String label;

  /// The function that is executed when the button is pressed.
  final VoidCallback? onPressed;

  /// Style of text.
  final TextStyle? textStyle;

  /// Color of text.
  final Color? color;

  /// Focus node of button
  final FocusNode? focusNode;

  /// The size of the tap target.
  final MaterialTapTargetSize? tapTargetSize;

  const CustomTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textStyle,
    this.color,
    this.focusNode,
    this.tapTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      focusNode: focusNode,
      onPressed: onPressed,
      style: context.theme.textButtonTheme.style?.copyWith(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: color != null
            ? WidgetStatePropertyAll(color!.withValues(alpha: 0.1))
            : null,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        ),
        tapTargetSize: tapTargetSize,
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kMobileCorner),
          ),
        ),
      ),
      child: Text(
        label,
        style:
            textStyle ??
            context.textTheme.bodyMedium?.copyWith(
              color: color ?? context.colorScheme.primary,
            ),
      ),
    );
  }
}

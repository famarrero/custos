import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
  BuildContext context, {
  bool isEmpty = false,
  String? label,
  String? hint,
  String? errorText,
  bool? filled,
  Color? fillColor,
  bool enabled = true,
  bool isDense = true,
  bool isCollapsed = false,
  bool hideCounterText = false,
  Widget? prefixIcon,
  Widget? suffixIcon,
  InputBorder? border,
  EdgeInsetsGeometry? contentPadding,
  double? corner,
  TextStyle? hintStyle,
}) {
  OutlineInputBorder border0({Color? borderColor}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(corner ?? context.corner()),
    borderSide: BorderSide(
      color: borderColor ?? context.colorScheme.primary.withValues(alpha: 0.4),
      style: BorderStyle.solid,
      width: context.border(),
    ),
  );

  return InputDecoration(
    enabled: enabled,
    isDense: isDense,
    isCollapsed: isCollapsed,
    filled: filled ?? true,
    fillColor:
        fillColor ??
        (Theme.of(context).brightness == Brightness.light
            ? context.colorScheme.surfaceContainerLowest
            : context.colorScheme.surfaceContainerHigh),
    enabledBorder: border ?? border0(),
    disabledBorder: border ?? border0(),
    focusedBorder: border ?? border0(),
    errorBorder: border ?? border0(borderColor: context.colorScheme.error),
    focusedErrorBorder:
        border ?? border0(borderColor: context.colorScheme.error),
    contentPadding: contentPadding,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    counterStyle:
        hideCounterText ? const TextStyle(height: double.minPositive) : null,
    counterText: hideCounterText ? '' : null,
    border: InputBorder.none,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelStyle: context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.onSurface,
    ),
    labelText: label,
    labelStyle: context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.onSurface,
    ),
    hintText: hint,
    hintStyle:
        hintStyle ??
        context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
    errorText: errorText,
    errorStyle: context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.error,
    ),
  );
}

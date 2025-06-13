import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
  BuildContext context, {
  bool isEmpty = false,
  String? hint,
  String? errorText,
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
    borderRadius: BorderRadius.circular(corner ?? kMobileCorner),
    borderSide: BorderSide(
      color: borderColor ?? context.colorScheme.primary,
      style: BorderStyle.solid,
      width: 1.0,
    ),
  );

  return InputDecoration(
    enabled: enabled,
    isDense: isDense,
    isCollapsed: isCollapsed,
    enabledBorder: border ?? border0(),
    disabledBorder: border ?? border0(),
    focusedBorder: border ?? border0(),
    errorBorder: border ?? border0(borderColor: context.colorScheme.error),
    focusedErrorBorder:
        border ?? border0(borderColor: context.colorScheme.error),
    contentPadding:
        contentPadding ?? EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    counterStyle:
        hideCounterText ? const TextStyle(height: double.minPositive) : null,
    counterText: hideCounterText ? '' : null,
    border: InputBorder.none,
    hintText: hint,
    hintStyle:
        hintStyle ??
        context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.onSurface,
        ),
    errorText: errorText,
    errorStyle: context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.error,
    ),
  );
}

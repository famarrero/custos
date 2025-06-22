// ignore_for_file: must_be_immutable

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/form/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

/// Custom TextFormField widget for use throughout the app.
///
/// This widget is based on the [TextFormField] widget
class CustomTextFormField extends StatelessWidget {
  /// The [TextEditingController] used for this text field.
  final TextEditingController? controller;

  /// The label text to be displayed above the text field.
  final String? label;

  /// A function used for validation of the input text.
  final String? Function(String?)? validator;

  /// The hint text to be displayed on the text field.
  final String? hint;

  /// Whether the field is required or not.
  ///
  /// By default `isRequired=false`
  final bool isRequired;

  /// Whether the field is enabled or disabled.
  ///
  /// By default `isEnabled=true`
  final bool isEnabled;

  /// If true the decoration's container is filled with [fillColor].
  final bool? filled;

  /// The base fill color of the decoration's container color.
  final Color? fillColor;

  /// The type of input expected for this text field.
  ///
  /// By default `textInputType=TextInputType.text`
  final TextInputType textInputType;

  /// The maximum number of lines to be displayed.
  ///
  /// By default `maxLines=1`
  final int? maxLines;

  /// The [Widget] that will be displayed at the begin of the [CustomTextFormField]
  final Widget? prefixIcon;

  /// The [Widget] that will be displayed at the end of the [CustomTextFormField]
  final Widget? suffixIcon;

  /// The [Padding] applied to the content of the text field. It doesn't include the [suffixIcon].
  final EdgeInsetsGeometry? contentPadding;

  /// The [InputBorder] of the text field.
  final InputBorder? border;

  /// The [onChanged] function of the text field.
  final Function(String)? onChanged;

  /// The [onFieldSubmitted] function of the text field.
  final Function(String)? onFieldSubmitted;

  /// The [FocusNode] of the text field.
  final FocusNode? focusNode;

  /// Set the text input style
  final TextStyle? textStyle;

  /// The input formatters that will be use in this [TextField]
  final List<TextInputFormatter>? inputFormatters;

  /// Obscure the text of the [TextField]
  ///
  /// If true, a button will be shown that allows the user to toggle the visibility of the password and
  /// the following properties will be set:
  ///
  /// * autocorrect: false
  /// * enableSuggestions: false
  final bool obscureText;

  /// Notifier used to show/hide password
  late ValueNotifier<bool> _obscureTextNotifier;

  /// TextInputAction of the text field
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// A list of strings that helps the autofill service identify the type of this text input.
  Iterable<String>? autofillHints;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// Whether to exclude the focus suffix on the [CustomTextFormField]
  /// By default `excludeFocusSuffix=false`
  final bool excludeFocusSuffix;

  /// The style to use for the [hint].
  final TextStyle? hintStyle;

  /// An optional error message displayed below the dropdown field when validation fails.
  /// If null, no error message is shown.
  final String? errorText;

  CustomTextFormField({
    this.autofillHints,
    this.expands = false,
    this.validator,
    this.controller,
    this.label,
    this.hint,
    this.hintStyle,
    this.isRequired = false,
    this.isEnabled = true,
    this.focusNode,
    this.textInputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.border,
    this.onChanged,
    this.onFieldSubmitted,
    this.textStyle,
    this.inputFormatters,
    this.obscureText = false,
    this.textInputAction,
    this.filled,
    this.fillColor,
    this.excludeFocusSuffix = false,
    this.errorText,
    super.key,
  }) : assert(
         suffixIcon == null || !obscureText,
         'Cannot show a suffixIcon when obscureText is already displaying a show/hide password widget.',
       ) {
    _obscureTextNotifier = ValueNotifier(obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final suffix =
        suffixIcon ??
        (obscureText
            ? ValueListenableBuilder(
              valueListenable: _obscureTextNotifier,
              builder: (context, value, _) {
                return IconButton(
                  onPressed:
                      () =>
                          _obscureTextNotifier.value =
                              !_obscureTextNotifier.value,
                  icon: Icon(
                    value
                        ? HugeIcons.strokeRoundedViewOff
                        : HugeIcons.strokeRoundedEye,
                    color: context.colorScheme.secondary,
                  ),
                );
              },
            )
            : null);

    final decoration = getInputDecoration(
      context,
      label:
          label != null
              ? isRequired
                  ? '$label*'
                  : label!
              : null,
      hint: hint,
      suffixIcon: suffix,
      prefixIcon: prefixIcon,
      errorText: errorText,
      border: border,
      hintStyle: hintStyle,
    );

    final InputDecoration effectiveDecoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    return ValueListenableBuilder(
      valueListenable: _obscureTextNotifier,
      builder: (context, __, _) {
        return TextFormField(
          autofillHints: autofillHints,
          expands: expands,
          obscureText: _obscureTextNotifier.value,
          autocorrect: !obscureText,
          enableSuggestions: !obscureText,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          enabled: isEnabled,
          focusNode: focusNode,
          controller: controller,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style:
              textStyle ??
              context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
          decoration: effectiveDecoration,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}

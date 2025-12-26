import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/presentation/components/form/input_decoration.dart';
import 'package:flutter/material.dart';

/// Custom DropdownButton to use across the app.
class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    this.value,
    this.label,
    this.validator,
    this.hint,
    this.isRequired = false,
    this.prefixIcon,
    required this.options,
    required this.itemBuilder,
    required this.onValueUpdate,
    this.errorText,
    this.contentPadding,
    this.corner,
    this.hideDefaultIcon = false,
    this.boxShadow,
  });

  /// The currently selected value of the dropdown.
  /// If null, no value is selected.
  final T? value;

  /// The label text displayed above the dropdown field.
  /// Optional. If null, no label is shown.
  final String? label;

  /// A function used for validation of the input text.
  final String? Function(T?)? validator;

  /// The hint text displayed inside the dropdown when no value is selected.
  /// Optional. If null, no hint is shown.
  final String? hint;

  /// Whether the field is required or not.
  /// If true, indicates that the dropdown field is mandatory.
  /// By default, `isRequired=false`.
  final bool isRequired;

  /// A function that returns the list of options (items) for the dropdown.
  /// This allows for dynamic loading of options.
  final List<T> Function() options;

  /// A function that builds the widget for each item in the dropdown list.
  /// This allows for customizing the appearance of each dropdown item.
  final Widget Function(T item) itemBuilder;

  /// A callback function triggered when the selected value changes.
  /// The new selected value is passed as an argument to this function.
  final ValueChanged<T?> onValueUpdate;

  /// An optional icon displayed at the start of the dropdown field.
  /// Used for visual decoration or to indicate the purpose of the field.
  final IconData? prefixIcon;

  /// An optional error message displayed below the dropdown field when validation fails.
  /// If null, no error message is shown.
  final String? errorText;

  /// Content padding of field.
  final EdgeInsetsGeometry? contentPadding;

  /// Corner of field.
  final double? corner;

  /// Hide the default drop dawn icon.
  final bool hideDefaultIcon;

  /// Optional shadow behind the field (useful for search bars, etc.)
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final decoration = getInputDecoration(
      context,
      corner: corner,
      suffixIcon:
          hideDefaultIcon
              ? const SizedBox.shrink()
              : Icon(
                AppIcons.dropdown,
                color: context.colorScheme.secondary,
              ),
      errorText: errorText,
    );

    final InputDecoration effectiveDecoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    final dropdown = DropdownButtonFormField<T>(
      initialValue: value,
      validator: validator,
      isExpanded: true,
      isDense: true,
      decoration: effectiveDecoration,
      hint: Text(
        hint ?? '',
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),

      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface,
      ),
      items:
          options()
              .map((e) => DropdownMenuItem<T>(value: e, child: itemBuilder(e)))
              .toList(),
      onChanged: (newValue) {
        onValueUpdate.call(newValue);
      },
      icon: const SizedBox.shrink(),
    );

    final widget =
        boxShadow == null
            ? dropdown
            : DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(corner ?? context.corner()),
                boxShadow: boxShadow,
              ),
              child: dropdown,
            );

    final children = <Widget>[
      if (label != null)
        Padding(
          padding: EdgeInsets.only(left: context.xl),
          child: Text(
            isRequired ? '$label*' : label!,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      widget,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.s,
      children: children,
    );
  }
}

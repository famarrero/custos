import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/datetime_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/form/input_decoration.dart';
import 'package:flutter/material.dart';

/// Custom date picker field to use across the app.
///
/// Visually matches the rest of the form fields (label + `getInputDecoration`).
/// Internally it uses a [FormField] so validation works with [DateTime] values.
class CustomSelectDatePicker extends StatefulWidget {
  const CustomSelectDatePicker({
    super.key,
    required this.onValueUpdate,
    this.value,
    this.label,
    this.hint,
    this.validator,
    this.isRequired = false,
    this.isEnabled = true,
    this.errorText,
    this.prefixIcon,
    this.contentPadding,
    this.corner,
    this.allowClear = false,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.locale,
    this.formatter,
  });

  /// The currently selected date.
  final DateTime? value;

  /// The label text displayed above the field.
  final String? label;

  /// The hint text displayed inside the field when no value is selected.
  final String? hint;

  /// A function used for validation of the selected [DateTime].
  final String? Function(DateTime?)? validator;

  /// Whether the field is required or not.
  final bool isRequired;

  /// Whether the field is enabled or disabled.
  final bool isEnabled;

  /// An optional error message displayed below the field.
  /// If not null, it takes precedence over the [validator] error.
  final String? errorText;

  /// Optional icon displayed at the start of the field.
  final IconData? prefixIcon;

  /// Content padding of field.
  final EdgeInsetsGeometry? contentPadding;

  /// Corner radius of field.
  final double? corner;

  /// Whether the user can clear the selected date.
  final bool allowClear;

  /// Minimum selectable date.
  ///
  /// Defaults to `DateTime(1900)`.
  final DateTime? firstDate;

  /// Maximum selectable date.
  ///
  /// Defaults to `DateTime(2100)`.
  final DateTime? lastDate;

  /// Optional initial date passed to the date picker dialog.
  ///
  /// If null, it will use [value] or `DateTime.now()`.
  final DateTime? initialDate;

  /// Optional locale for the date picker.
  final Locale? locale;

  /// Optional formatter for the selected date.
  ///
  /// If null, uses `MaterialLocalizations.formatMediumDate`.
  final String Function(BuildContext context, DateTime date)? formatter;

  /// Callback called whenever the date changes.
  final ValueChanged<DateTime?> onValueUpdate;

  @override
  State<CustomSelectDatePicker> createState() => _CustomSelectDatePickerState();
}

class _CustomSelectDatePickerState extends State<CustomSelectDatePicker> {
  final GlobalKey<FormFieldState<DateTime?>> _fieldKey =
      GlobalKey<FormFieldState<DateTime?>>();

  void _syncExternalValue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = _fieldKey.currentState;
      if (state == null) return;
      if (state.value == widget.value) return;
      state.didChange(widget.value);
    });
  }

  @override
  void didUpdateWidget(covariant CustomSelectDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _syncExternalValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (widget.label != null)
        Padding(
          padding: EdgeInsets.only(left: context.xl),
          child: Text(
            widget.isRequired ? '${widget.label}*' : widget.label!,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      FormField<DateTime?>(
        key: _fieldKey,
        initialValue: widget.value,
        validator: widget.validator,
        builder: (field) {
          final effectiveErrorText = widget.errorText ?? field.errorText;
          final date = field.value;

          final text =
              date == null
                  ? ''
                  : (widget.formatter?.call(context, date) ?? date.formatDate);

          final suffixIcon =
              (widget.allowClear && widget.isEnabled && date != null)
                  ? IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).deleteButtonTooltip,
                    onPressed: () {
                      field.didChange(null);
                      widget.onValueUpdate.call(null);
                    },
                    icon: Icon(
                      AppIcons.close,
                      color: context.colorScheme.secondary,
                    ),
                  )
                  : Icon(
                    AppIcons.calendar,
                    color: context.colorScheme.secondary,
                  );

          final decoration = getInputDecoration(
            context,
            hint: widget.hint,
            enabled: widget.isEnabled,
            errorText: effectiveErrorText,
            contentPadding: widget.contentPadding,
            corner: widget.corner,
            prefixIcon:
                widget.prefixIcon == null
                    ? null
                    : Icon(
                      widget.prefixIcon,
                      color: context.colorScheme.secondary,
                    ),
            suffixIcon: suffixIcon,
          );

          final InputDecoration effectiveDecoration = decoration.applyDefaults(
            Theme.of(context).inputDecorationTheme,
          );

          Future<void> openPicker() async {
            final first = widget.firstDate ?? DateTime(1900);
            final last = widget.lastDate ?? DateTime(2100);

            DateTime initial =
                date ?? widget.initialDate ?? DateTime.now().toLocal();
            if (initial.isBefore(first)) initial = first;
            if (initial.isAfter(last)) initial = last;

            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: first,
              lastDate: last,
              locale: widget.locale,
            );

            if (!mounted) return;
            if (picked == null) return;

            field.didChange(picked);
            widget.onValueUpdate.call(picked);
          }

          final borderRadius = BorderRadius.circular(
            widget.corner ?? context.corner(),
          );

          return InkWell(
            onTap: widget.isEnabled ? openPicker : null,
            borderRadius: borderRadius,
            child: InputDecorator(
              decoration: effectiveDecoration,
              isEmpty: date == null,
              child: Text(
                text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.s,
      children: children,
    );
  }
}

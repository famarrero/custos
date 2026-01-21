import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

/// Custom CheckboxListTile to use across the app.
class CustomCheckBoxTitle extends StatelessWidget {
  const CustomCheckBoxTitle({
    super.key,
    this.value = false,
    required this.title,
    this.style,
    required this.onChanged,
  });

  /// The current state of the checkbox (checked or unchecked).
  /// If true, the checkbox is checked; if false, it is unchecked.
  final bool value;

  /// The title text displayed next to the checkbox.
  /// This is typically used to describe the purpose of the checkbox.
  final String title;

  /// The text style applied to the title text.
  /// Optional. If null, the default text style is used.
  final TextStyle? style;

  /// A callback function triggered when the checkbox state changes.
  /// The new state (true or false) is passed as an argument to this function.
  final ValueSetter<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0.0,
      child: CheckboxListTile(
        value: value,
        onChanged: (value) => onChanged(value ?? false),
        title: Text(
          title,
          style: style ??
              context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        splashRadius: 0,
        checkboxShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_text_button.dart';
import 'package:custos/presentation/components/form/custom_check_box_title.dart';
import 'package:flutter/material.dart';

/// A widget that displays a confirmation dialog.
///
/// This dialog provides a title, optional content, and two customizable buttons.
/// It can also include a checkbox to manage button states based on user interaction.
class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.child,
    this.checkBoxTitle,
    this.labelLeftButton,
    this.onPressedLeftButton,
    this.labelRightButton,
    this.onPressedRightButton,
    this.backgroundColorLeft,
    this.disableBackgroundColorLeft,
    this.disableForegroundColorRight,
    this.disableBackgroundColorRight,
    this.backgroundColorRight,
    this.disabledForegroundColorRight,
    this.foregroundColorRight,
    this.disabledForegroundColorLeft,
    this.foregroundColorLeft,
    this.enableLeftButtonOnCheckOnly = false,
    this.enableRightButtonOnCheckOnly = false,
  });

  /// The title displayed at the top of the dialog.
  ///
  /// If `null`, defaults to `context.l10n.sureWantPerformThisAction`.
  final String? title;

  /// A widget displayed below the title.
  ///
  /// Useful for showing additional content in the dialog.
  final Widget? child;

  /// The title of the checkbox.
  ///
  /// If `null`, the checkbox is not shown.
  final String? checkBoxTitle;

  /// Label displayed inside the left button.
  final String? labelLeftButton;

  /// Callback executed when the left button is pressed.
  ///
  /// The parameter `isCheck` reflects the current state of the checkbox
  final Function(bool isCheck)? onPressedLeftButton;

  /// Label displayed inside the right button.
  final String? labelRightButton;

  /// Callback executed when the right button is pressed.
  ///
  /// The parameter `isCheck` reflects the current state of the checkbox
  final Function(bool isCheck)? onPressedRightButton;

  /// Background color for the left button.
  final Color? backgroundColorLeft;

  /// Background color for the right button.
  final Color? backgroundColorRight;

  /// Disabled foreground color for the right button.
  final Color? disabledForegroundColorRight;

  /// Foreground color for the right button.
  final Color? foregroundColorRight;

  /// Disabled foreground color for the left button.
  final Color? disabledForegroundColorLeft;

  /// Disabled foreground color for the right button.
  final Color? disableForegroundColorRight;

  /// Disabled background color for the right button.
  final Color? disableBackgroundColorRight;

  /// Foreground color for the left button.
  final Color? foregroundColorLeft;

  /// Disabled background color for the left button.
  final Color? disableBackgroundColorLeft;

  /// Enables or disables the left button based on the checkbox state.
  ///
  /// Default value: `false`.
  /// - If `true`, the left button is enabled only if the checkbox is checked.
  /// - If `false`, the left button is always enabled.
  final bool enableLeftButtonOnCheckOnly;

  /// Enables or disables the right button based on the checkbox state.
  ///
  /// Default value: `false`.
  /// - If `true`, the right button is enabled only if the checkbox is checked.
  /// - If `false`, the right button is always enabled.
  final bool enableRightButtonOnCheckOnly;

  @override
  State<StatefulWidget> createState() {
    return _ConfirmationDialogState();
  }
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  /// Current state of the checkbox.
  /// Default `false`
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    /// The enablement of the left or right buttons depends on several factors. For a button to be enabled, a callback must be provided.
    /// If a callback exists, the button's state may depend on the checkbox state, determined by the enableLeftButtonOnCheck or
    /// enableRightButtonOnCheck properties. If any these properties are true and the checkbox is visible (checkBoxValue is not null),
    /// the button's state will react to the checkbox state.
    /// If the checkbox is not visible (checkBoxValue is null), the button will always be enabled.

    final enableLeftButton =
        widget.onPressedLeftButton != null &&
        (widget.enableLeftButtonOnCheckOnly ? checkBoxValue : true);
    final enableRightButton =
        widget.onPressedRightButton != null &&
        (widget.enableRightButtonOnCheckOnly ? checkBoxValue : true);

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: kMobileMaxColumnWidthInDialog,
        ),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(kMobileCorner),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog title
              Text(
                widget.title ?? context.l10n.sureWantPerformThisAction,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8.0),

              // Additional content
              if (widget.child != null) ...[
                Align(child: widget.child!),
                const SizedBox(height: 8.0),
              ],

              // Checkbox
              if (widget.checkBoxTitle != null) ...[
                Material(
                  color: context.colorScheme.surface,
                  child: CustomCheckBoxTitle(
                    title: widget.checkBoxTitle!,
                    value: checkBoxValue,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    onChanged: (value) {
                      setState(() {
                        checkBoxValue = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
              ],

              // Buttons
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (widget.labelLeftButton != null) ...[
                        CustomTextButton(
                          label: widget.labelLeftButton!,
                          onPressed:
                              enableLeftButton
                                  ? () => widget.onPressedLeftButton?.call(
                                    checkBoxValue,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 24),
                      ],
                      if (widget.labelRightButton != null)
                        CustomTextButton(
                          label: widget.labelRightButton!,
                          color: context.colorScheme.error,
                          onPressed:
                              enableRightButton
                                  ? () => widget.onPressedRightButton?.call(
                                    checkBoxValue,
                                  )
                                  : null,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

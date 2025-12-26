// ignore_for_file: must_be_immutable

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

/// A custom [TextButton] used throughout the app.
class CustomButton extends StatefulWidget {
  /// The function that is executed when the button is pressed.
  final VoidCallback? onPressed;

  /// Vertical padding that separates the text from vertical borders of the bottom
  late EdgeInsets? padding;

  /// Creates a new button for scrolling to the top of the screen.
  ///
  /// The [onPressed] argument must be a function that will be executed when the user presses the button.

  /// Defines the width of the [CustomButton]
  /// If `infiniteWidth=true` the [CustomButton] will had `width=double.infinity`, otherwise,
  /// the button will be sized according to its content while respecting the padding.
  ///
  /// By default is `true`
  final bool infiniteWidth;

  /// Label to show inside the button when [isLoading] is false.
  ///
  /// By default is an empty string.
  final String label;

  /// When true a [CircularProgressIndicator] will be shown. When false, a [Text] widget with [label] will show instead.
  ///
  /// By default is `false`
  final bool isLoading;

  /// Specify the backgroundColor of the button.
  final Color? backgroundColor;

  /// Specify the foregroundColor of the button.
  final Color? foregroundColor;

  /// Icon to show at the beginning of the button.
  final IconData? prefixIconData;

  /// Type of the button.
  final CustomTextButtonEnum type;

  /// Focus node of button.
  final FocusNode? focusNode;

  /// Autofocus of button.
  final bool autofocus;

  /// Button corner.
  final double? corner;

  /// Set a fixed width for the button.
  final double? fixedWidth;

  /// Horizontal padding that separates the text from horizontal borders of the bottom.
  final double? horizontalTextPadding;

  CustomButton({
    super.key,
    this.label = '',
    this.type = CustomTextButtonEnum.filled,
    this.prefixIconData,
    this.isLoading = false,
    this.onPressed,
    this.infiniteWidth = false,
    this.padding,
    this.foregroundColor,
    this.backgroundColor,
    this.focusNode,
    this.autofocus = false,
    this.corner,
    this.fixedWidth,
    this.horizontalTextPadding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final child = IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: widget.isLoading,
            child: Positioned(
              top: 0,
              bottom: 0,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(context.m),
                  child: CustomCircularProgressIndicator(
                    color:
                        widget.foregroundColor ??
                        (widget.type == CustomTextButtonEnum.filled
                            ? Colors.white
                            : context.colorScheme.primary),
                    strokeWidth: 6.0,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !widget.isLoading,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: widget.horizontalTextPadding ?? context.lg),
                if (widget.prefixIconData != null) ...[
                  Icon(
                    widget.prefixIconData,
                    color:
                        widget.foregroundColor ??
                        (widget.type == CustomTextButtonEnum.filled
                            ? Colors.white
                            : context.colorScheme.primary),
                    size: 22,
                  ),
                  SizedBox(width: context.m),
                ],
                SizedBox(
                  width: widget.fixedWidth,
                  child: Center(
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.md),
                        child: Text(
                          widget.label,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color:
                                widget.foregroundColor ??
                                (widget.type == CustomTextButtonEnum.filled
                                    ? Colors.white
                                    : context.colorScheme.primary),
                            height: 2.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: widget.horizontalTextPadding ?? context.lg),
              ],
            ),
          ),
        ],
      ),
    );

    final isFilled = widget.type == CustomTextButtonEnum.filled;

    return TextButton(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onPressed: !widget.isLoading ? widget.onPressed : () {},
      style: context.theme.textButtonTheme.style?.copyWith(
        minimumSize: WidgetStatePropertyAll(
          Size(widget.infiniteWidth ? double.infinity : 0, 0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll(widget.padding),
        backgroundColor:
            isFilled
                ? WidgetStatePropertyAll(
                  widget.backgroundColor ?? context.colorScheme.primary,
                )
                : null,
        side:
            isFilled
                ? null
                : WidgetStatePropertyAll(
                  BorderSide(
                    color:
                        widget.foregroundColor ?? context.colorScheme.primary,
                  ),
                ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side:
                isFilled
                    ? BorderSide.none
                    : BorderSide(
                      color:
                          widget.foregroundColor ?? context.colorScheme.primary,
                      width: context.border(),
                    ),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.corner ?? context.corner()),
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}

/// Enum that defines the type of [CustomButton].
enum CustomTextButtonEnum { filled, outlined }

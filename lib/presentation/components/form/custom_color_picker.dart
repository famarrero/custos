import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

/// Custom Color Picker widget that allows users to select a color
/// and displays the selected color along with its name and code.
class CustomColorPicker extends StatefulWidget {
  const CustomColorPicker({
    super.key,
    required this.label,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final String label;
  final Color? selectedColor;
  final Function(Color) onColorSelected;

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  final defaultColor = Colors.blue;
  late Color dialogPickerColor;

  @override
  void initState() {
    super.initState();
    dialogPickerColor = widget.selectedColor ?? defaultColor;
  }

  @override
  void didUpdateWidget(covariant CustomColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedColor != oldWidget.selectedColor &&
        widget.selectedColor != dialogPickerColor) {
      setState(() {
        dialogPickerColor = widget.selectedColor ?? defaultColor;
      });
    }
  }

  Future<void> colorPickerDialog() async {
    final Color pickedColor = await showColorPickerDialog(
      context,
      dialogPickerColor,
      title: Text('Pick a color', style: context.textTheme.titleMedium),
    );

    if (pickedColor != dialogPickerColor) {
      setState(() {
        dialogPickerColor = pickedColor;
      });
      widget.onColorSelected(pickedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      children: [
        ColorIndicator(
          width: 44.0,
          height: 44.0,
          borderRadius: kMobileCorner,
          color: dialogPickerColor,
          onSelectFocus: false,
          onSelect: () async {
            await colorPickerDialog();
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: context.textTheme.bodyMedium),
            Text(
              ColorTools.materialName(
                dialogPickerColor,
                colorSwatchNameMap: ColorTools.primaryColorNames,
              ),
              style: context.textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

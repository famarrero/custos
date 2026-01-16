import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/group_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:flutter/material.dart';

/// A reusable custom icon picker widget.
class CustomIconPicker extends StatefulWidget {
  const CustomIconPicker({
    super.key,
    required this.label,
    required this.selectedIconId,
    required this.onIconSelected,
  });

  final String label;
  final int? selectedIconId;
  final ValueChanged<int?> onIconSelected;

  @override
  State<CustomIconPicker> createState() => _CustomIconPickerState();
}

class _CustomIconPickerState extends State<CustomIconPicker> {
  late int currentIconId;

  @override
  void initState() {
    super.initState();
    currentIconId = widget.selectedIconId ?? GroupIcons.defaultId;
  }

  /// Opens the icon picker dialog and updates the selected icon if changed.
  Future<void> _showIconPickerDialog() async {
    final int? pickedIconId = await showIconPickerDialog(
      context,
      initialIconId: currentIconId,
      currentIconId: currentIconId,
      title: Text(
        context.l10n.iconPickerTitle,
        style: context.textTheme.titleMedium,
      ),
    );

    if (pickedIconId != null && pickedIconId != currentIconId) {
      setState(() {
        currentIconId = pickedIconId;
      });
      widget.onIconSelected(pickedIconId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: _showIconPickerDialog,
      child: Row(
        spacing: 12.0,
        children: [
          SizedBox.square(
            dimension: 44.0,
            child: Icon(GroupIcons.iconFor(currentIconId), size: 32),
          ),
          Flexible(
            child: Text(widget.label, style: context.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// Shows a dialog allowing the user to select an icon from a grid.
Future<int?> showIconPickerDialog(
  BuildContext context, {
  required int initialIconId,
  required int currentIconId,
  required Widget title,
}) async {
  int? selectedIconId = currentIconId;
  final options = GroupIcons.options;

  return await showDialog<int>(
    context: context,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (innerContext) {
      return StatefulBuilder(
        builder: (innerContext, setState) {
          return PopScope(
            canPop: true,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.corner()),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.xl,
                vertical: context.xl,
              ),
              insetPadding: EdgeInsets.symmetric(
                horizontal: context.xxxl,
                vertical: context.xxxl,
              ),
              title: title,
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: context.lg,
                    crossAxisSpacing: context.lg,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option.id == selectedIconId;

                    return InkWell(
                      onTap: () => setState(() => selectedIconId = option.id),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(context.m),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? context.colorScheme.primary
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                context.corner(),
                              ),
                            ),
                            padding: EdgeInsets.all(context.sm),
                            child: Center(
                              child: Icon(
                                option.icon,
                                size: 22,
                                color:
                                    isSelected
                                        ? context.colorScheme.onPrimary
                                        : context.colorScheme.contrastColor(),
                              ),
                            ),
                          ),
                          SizedBox(height: context.xs),
                          Expanded(
                            child: Text(
                              option.label(context),
                              style: context.textTheme.labelSmall,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(innerContext).pop(initialIconId),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(innerContext).pop(selectedIconId),
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

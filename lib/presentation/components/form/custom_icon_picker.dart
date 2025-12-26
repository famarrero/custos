import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:flutter/material.dart';

/// Default fallback icon.
const defaultIcon = AppIcons.groupOthers;

/// A class representing an icon and its corresponding label.
class IconAndLabel {
  final IconData icon;
  final String Function(BuildContext context) labelBuilder;

  const IconAndLabel({required this.icon, required this.labelBuilder});

  String label(BuildContext context) => labelBuilder(context);

  @override
  String toString() => 'IconAndLabel(icon: $icon)';
}

/// A predefined list of icon options categorized for password groups.
final List<IconAndLabel> iconOptions = [
  IconAndLabel(
    icon: AppIcons.groupHome,
    labelBuilder: (context) => context.l10n.iconLabelHome,
  ),
  IconAndLabel(
    icon: AppIcons.groupSecurity,
    labelBuilder: (context) => context.l10n.iconLabelSecurity,
  ),
  IconAndLabel(
    icon: AppIcons.groupCrypto,
    labelBuilder: (context) => context.l10n.iconLabelCrypto,
  ),
  IconAndLabel(
    icon: AppIcons.groupFinance,
    labelBuilder: (context) => context.l10n.iconLabelFinance,
  ),
  IconAndLabel(
    icon: AppIcons.groupCards,
    labelBuilder: (context) => context.l10n.iconLabelCards,
  ),
  IconAndLabel(
    icon: AppIcons.groupPersonal,
    labelBuilder: (context) => context.l10n.iconLabelPersonal,
  ),
  IconAndLabel(
    icon: AppIcons.groupUsers,
    labelBuilder: (context) => context.l10n.iconLabelUsers,
  ),
  IconAndLabel(
    icon: AppIcons.groupIdentity,
    labelBuilder: (context) => context.l10n.iconLabelIdentity,
  ),
  IconAndLabel(
    icon: AppIcons.groupBusiness,
    labelBuilder: (context) => context.l10n.iconLabelBusiness,
  ),
  IconAndLabel(
    icon: AppIcons.groupTravel,
    labelBuilder: (context) => context.l10n.iconLabelTravel,
  ),
  IconAndLabel(
    icon: AppIcons.groupSocial,
    labelBuilder: (context) => context.l10n.iconLabelSocial,
  ),
  IconAndLabel(
    icon: AppIcons.groupWebsites,
    labelBuilder: (context) => context.l10n.iconLabelWebsites,
  ),
  IconAndLabel(
    icon: AppIcons.groupEmail,
    labelBuilder: (context) => context.l10n.iconLabelEmail,
  ),
  IconAndLabel(
    icon: AppIcons.groupMessaging,
    labelBuilder: (context) => context.l10n.iconLabelMessaging,
  ),
  IconAndLabel(
    icon: AppIcons.groupShopping,
    labelBuilder: (context) => context.l10n.iconLabelShopping,
  ),
  IconAndLabel(
    icon: AppIcons.groupGaming,
    labelBuilder: (context) => context.l10n.iconLabelGaming,
  ),
  IconAndLabel(
    icon: AppIcons.groupMobile,
    labelBuilder: (context) => context.l10n.iconLabelMobile,
  ),
  IconAndLabel(
    icon: AppIcons.groupWifi,
    labelBuilder: (context) => context.l10n.iconLabelWifi,
  ),
  IconAndLabel(
    icon: AppIcons.groupBackup,
    labelBuilder: (context) => context.l10n.iconLabelBackup,
  ),
  IconAndLabel(
    icon: AppIcons.groupCloud,
    labelBuilder: (context) => context.l10n.iconLabelCloud,
  ),
  IconAndLabel(
    icon: AppIcons.groupProtection,
    labelBuilder: (context) => context.l10n.iconLabelProtection,
  ),
  IconAndLabel(
    icon: AppIcons.groupConfiguration,
    labelBuilder: (context) => context.l10n.iconLabelConfiguration,
  ),
  IconAndLabel(
    icon: AppIcons.groupStatistics,
    labelBuilder: (context) => context.l10n.iconLabelStatistics,
  ),
  IconAndLabel(
    icon: AppIcons.groupServices,
    labelBuilder: (context) => context.l10n.iconLabelServices,
  ),
  IconAndLabel(
    icon: AppIcons.groupDevelopment,
    labelBuilder: (context) => context.l10n.iconLabelDevelopment,
  ),
  IconAndLabel(
    icon: AppIcons.groupBanking,
    labelBuilder: (context) => context.l10n.iconLabelBanking,
  ),
  IconAndLabel(
    icon: defaultIcon,
    labelBuilder: (context) => context.l10n.iconLabelOthers,
  ),
];

/// A reusable custom icon picker widget.
class CustomIconPicker extends StatefulWidget {
  const CustomIconPicker({
    super.key,
    required this.label,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  final String label;
  final IconData? selectedIcon;
  final Function(IconData?) onIconSelected;

  @override
  State<CustomIconPicker> createState() => _CustomIconPickerState();
}

class _CustomIconPickerState extends State<CustomIconPicker> {
  late IconData currentIcon;

  @override
  void initState() {
    super.initState();
    currentIcon = widget.selectedIcon ?? defaultIcon;
  }

  /// Opens the icon picker dialog and updates the selected icon if changed.
  Future<void> _showIconPickerDialog() async {
    final IconData? pickedIcon = await showIconPickerDialog(
      context,
      initialIcon: currentIcon,
      currentIcon: currentIcon,
      title: Text(
        context.l10n.iconPickerTitle,
        style: context.textTheme.titleMedium,
      ),
    );

    if (pickedIcon != null && pickedIcon != currentIcon) {
      setState(() {
        currentIcon = pickedIcon;
      });
      widget.onIconSelected(pickedIcon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      children: [
        GestureDetector(
          onTap: _showIconPickerDialog,
          child: SizedBox.square(
            dimension: 44.0,
            child: Icon(currentIcon, size: 32),
          ),
        ),
        Flexible(
          child: Text(widget.label, style: context.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

/// Shows a dialog allowing the user to select an icon from a grid.
Future<IconData?> showIconPickerDialog(
  BuildContext context, {
  required IconData initialIcon,
  required IconData currentIcon,
  required Widget title,
}) async {
  IconData? selectedIcon = currentIcon;

  return await showDialog<IconData>(
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
              contentPadding: EdgeInsets.symmetric(horizontal: context.s),
              title: title,
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: iconOptions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: context.lg,
                    crossAxisSpacing: context.lg,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final iconData = iconOptions[index];
                    final isSelected = iconData.icon == selectedIcon;

                    return InkWell(
                      onTap: () => setState(() => selectedIcon = iconData.icon),
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
                            child: Icon(
                              iconData.icon,
                              size: 32,
                              color:
                                  isSelected
                                      ? context.colorScheme.onPrimary
                                      : context.colorScheme.blackAndWith,
                            ),
                          ),
                          SizedBox(height: context.xs),
                          Expanded(
                            child: Text(
                              iconData.label(context),
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
                  onPressed: () => Navigator.of(innerContext).pop(initialIcon),
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(innerContext).pop(selectedIcon),
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

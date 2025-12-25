import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Default fallback icon.
const defaultIcon = HugeIcons.strokeRoundedUser;

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
    icon: HugeIcons.strokeRoundedHome01,
    labelBuilder: (context) => context.l10n.iconLabelHome,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedKey01,
    labelBuilder: (context) => context.l10n.iconLabelSecurity,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedBitcoin02,
    labelBuilder: (context) => context.l10n.iconLabelCrypto,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedWallet01,
    labelBuilder: (context) => context.l10n.iconLabelFinance,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedCreditCard,
    labelBuilder: (context) => context.l10n.iconLabelCards,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedUserAccount,
    labelBuilder: (context) => context.l10n.iconLabelPersonal,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedUserMultiple,
    labelBuilder: (context) => context.l10n.iconLabelUsers,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedIdentityCard,
    labelBuilder: (context) => context.l10n.iconLabelIdentity,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedBriefcase01,
    labelBuilder: (context) => context.l10n.iconLabelBusiness,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedAirplane01,
    labelBuilder: (context) => context.l10n.iconLabelTravel,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedGroupItems,
    labelBuilder: (context) => context.l10n.iconLabelSocial,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedWebProgramming,
    labelBuilder: (context) => context.l10n.iconLabelWebsites,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedMail01,
    labelBuilder: (context) => context.l10n.iconLabelEmail,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedBubbleChat,
    labelBuilder: (context) => context.l10n.iconLabelMessaging,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedShoppingBag01,
    labelBuilder: (context) => context.l10n.iconLabelShopping,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedGameController01,
    labelBuilder: (context) => context.l10n.iconLabelGaming,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedSmartPhone01,
    labelBuilder: (context) => context.l10n.iconLabelMobile,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedWifi01,
    labelBuilder: (context) => context.l10n.iconLabelWifi,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedCloudUpload,
    labelBuilder: (context) => context.l10n.iconLabelBackup,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedCloud,
    labelBuilder: (context) => context.l10n.iconLabelCloud,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedShield01,
    labelBuilder: (context) => context.l10n.iconLabelProtection,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedSettings01,
    labelBuilder: (context) => context.l10n.iconLabelConfiguration,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedChart01,
    labelBuilder: (context) => context.l10n.iconLabelStatistics,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedPackageAdd,
    labelBuilder: (context) => context.l10n.iconLabelServices,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedCode,
    labelBuilder: (context) => context.l10n.iconLabelDevelopment,
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedBank,
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
                borderRadius: BorderRadius.circular(kMobileCorner),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: title,
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: iconOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final iconData = iconOptions[index];
                    final isSelected = iconData.icon == selectedIcon;

                    return InkWell(
                      onTap: () => setState(() => selectedIcon = iconData.icon),
                      borderRadius: BorderRadius.circular(8),
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
                                kMobileCorner,
                              ),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              iconData.icon,
                              size: 32,
                              color:
                                  isSelected
                                      ? context.colorScheme.onPrimary
                                      : context.colorScheme.blackAndWith,
                            ),
                          ),
                          const SizedBox(height: 2),
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

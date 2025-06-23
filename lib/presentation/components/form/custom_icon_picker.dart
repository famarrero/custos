import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/color_scheme_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Default fallback icon.
const defaultIcon = HugeIcons.strokeRoundedMoreHorizontalSquare02;

/// A class representing an icon and its corresponding label.
class IconAndLabel {
  final IconData icon;
  final String label;

  const IconAndLabel({required this.icon, required this.label});

  @override
  String toString() => 'IconAndLabel(icon: $icon, label: $label)';
}

/// A predefined list of icon options categorized for password groups.
final List<IconAndLabel> iconOptions = [
  IconAndLabel(icon: HugeIcons.strokeRoundedHome01, label: 'Hogar'),
  IconAndLabel(icon: HugeIcons.strokeRoundedKey01, label: 'Seguridad'),
  IconAndLabel(icon: HugeIcons.strokeRoundedBitcoin02, label: 'Criptomonedas'),
  IconAndLabel(icon: HugeIcons.strokeRoundedWallet01, label: 'Finanzas'),
  IconAndLabel(icon: HugeIcons.strokeRoundedUserAccount, label: 'Personal'),
  IconAndLabel(icon: HugeIcons.strokeRoundedUserMultiple, label: 'Usuarios'),
  IconAndLabel(icon: HugeIcons.strokeRoundedBriefcase01, label: 'Empresarial'),
  IconAndLabel(icon: HugeIcons.strokeRoundedAirplane01, label: 'Viajes'),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedGroupItems,
    label: 'Redes sociales',
  ),
  IconAndLabel(
    icon: HugeIcons.strokeRoundedWebProgramming,
    label: 'Sitios webs',
  ),
  IconAndLabel(icon: HugeIcons.strokeRoundedCloudUpload, label: 'Respaldo'),
  IconAndLabel(icon: HugeIcons.strokeRoundedShield01, label: 'Protección'),
  IconAndLabel(icon: HugeIcons.strokeRoundedSettings01, label: 'Configuración'),
  IconAndLabel(icon: HugeIcons.strokeRoundedChart01, label: 'Estadísticas'),
  IconAndLabel(icon: HugeIcons.strokeRoundedPackageAdd, label: 'Servicios'),
  IconAndLabel(icon: HugeIcons.strokeRoundedBank, label: 'Banca'),
  IconAndLabel(icon: defaultIcon, label: 'Otros'),
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
      title: Text('Pick an icon', style: context.textTheme.titleMedium),
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
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final iconData = iconOptions[index];
                    final isSelected = iconData.icon == selectedIcon;

                    return InkWell(
                      onTap: () => setState(() => selectedIcon = iconData.icon),
                      borderRadius: BorderRadius.circular(12),
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
                              iconData.label,
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
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(innerContext).pop(selectedIcon),
                  child: const Text('Ok'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

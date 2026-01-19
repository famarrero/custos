import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';

/// Group icon registry.
///
/// Groups persist their icon as an **int id** (not `IconData`) so release icon
/// tree-shaking works and the database stays stable.
typedef GroupIconLabelBuilder = String Function(BuildContext context);

final class GroupIconOption {
  const GroupIconOption({required this.id, required this.icon, required this.labelBuilder});

  final int id;
  final IconData icon;
  final GroupIconLabelBuilder labelBuilder;

  String label(BuildContext context) => labelBuilder(context);
}

final class GroupIcons {
  GroupIcons._();

  /// Default icon id used when none is selected.
  static const int defaultId = 999;

  /// Single source of truth for group icon catalog (id + icon + localized label).
  static final List<GroupIconOption> options = <GroupIconOption>[
    GroupIconOption(id: 1, icon: AppIcons.groupHome, labelBuilder: (context) => context.l10n.iconLabelHome),
    GroupIconOption(id: 2, icon: AppIcons.groupSecurity, labelBuilder: (context) => context.l10n.iconLabelSecurity),
    GroupIconOption(id: 3, icon: AppIcons.groupCrypto, labelBuilder: (context) => context.l10n.iconLabelCrypto),
    GroupIconOption(id: 4, icon: AppIcons.groupFinance, labelBuilder: (context) => context.l10n.iconLabelFinance),
    GroupIconOption(id: 5, icon: AppIcons.groupCards, labelBuilder: (context) => context.l10n.iconLabelCards),
    GroupIconOption(id: 6, icon: AppIcons.groupPersonal, labelBuilder: (context) => context.l10n.iconLabelPersonal),
    GroupIconOption(id: 7, icon: AppIcons.groupUsers, labelBuilder: (context) => context.l10n.iconLabelUsers),
    GroupIconOption(id: 8, icon: AppIcons.groupIdentity, labelBuilder: (context) => context.l10n.iconLabelIdentity),
    GroupIconOption(id: 9, icon: AppIcons.groupBusiness, labelBuilder: (context) => context.l10n.iconLabelBusiness),
    GroupIconOption(id: 10, icon: AppIcons.groupTravel, labelBuilder: (context) => context.l10n.iconLabelTravel),
    GroupIconOption(id: 11, icon: AppIcons.groupSocial, labelBuilder: (context) => context.l10n.iconLabelSocial),
    GroupIconOption(id: 12, icon: AppIcons.groupWebsites, labelBuilder: (context) => context.l10n.iconLabelWebsites),
    GroupIconOption(id: 13, icon: AppIcons.groupEmail, labelBuilder: (context) => context.l10n.iconLabelEmail),
    GroupIconOption(id: 14, icon: AppIcons.groupMessaging, labelBuilder: (context) => context.l10n.iconLabelMessaging),
    GroupIconOption(id: 15, icon: AppIcons.groupShopping, labelBuilder: (context) => context.l10n.iconLabelShopping),
    GroupIconOption(id: 16, icon: AppIcons.groupGaming, labelBuilder: (context) => context.l10n.iconLabelGaming),
    GroupIconOption(id: 17, icon: AppIcons.groupMobile, labelBuilder: (context) => context.l10n.iconLabelMobile),
    GroupIconOption(id: 18, icon: AppIcons.groupWifi, labelBuilder: (context) => context.l10n.iconLabelWifi),
    GroupIconOption(id: 19, icon: AppIcons.groupBackup, labelBuilder: (context) => context.l10n.iconLabelBackup),
    GroupIconOption(id: 20, icon: AppIcons.groupCloud, labelBuilder: (context) => context.l10n.iconLabelCloud),
    GroupIconOption(
      id: 21,
      icon: AppIcons.groupProtection,
      labelBuilder: (context) => context.l10n.iconLabelProtection,
    ),
    GroupIconOption(
      id: 22,
      icon: AppIcons.groupConfiguration,
      labelBuilder: (context) => context.l10n.iconLabelConfiguration,
    ),
    GroupIconOption(
      id: 23,
      icon: AppIcons.groupStatistics,
      labelBuilder: (context) => context.l10n.iconLabelStatistics,
    ),
    GroupIconOption(id: 24, icon: AppIcons.groupServices, labelBuilder: (context) => context.l10n.iconLabelServices),
    GroupIconOption(
      id: 25,
      icon: AppIcons.groupDevelopment,
      labelBuilder: (context) => context.l10n.iconLabelDevelopment,
    ),
    GroupIconOption(id: 26, icon: AppIcons.groupBanking, labelBuilder: (context) => context.l10n.iconLabelBanking),
    GroupIconOption(id: defaultId, icon: AppIcons.groupOthers, labelBuilder: (context) => context.l10n.iconLabelOthers),
  ];

  static final Map<int, IconData> _byId = <int, IconData>{for (final option in options) option.id: option.icon};

  /// Returns an icon for an id, falling back to the default icon.
  static IconData iconFor(int? id) => _byId[id] ?? _byId[defaultId]!;

  /// Returns the id for an icon. If the icon isn't in the registry, returns null.
  static int? idOf(IconData? icon) {
    if (icon == null) return null;
    for (final entry in _byId.entries) {
      if (entry.value == icon) return entry.key;
    }
    return null;
  }
}

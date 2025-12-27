import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';

/// Group icon registry.
///
/// Groups persist their icon as an **int id** (not `IconData`) so release icon
/// tree-shaking works and the database stays stable.
typedef GroupIconLabelBuilder = String Function(BuildContext context);

final class GroupIconOption {
  const GroupIconOption({
    required this.id,
    required this.icon,
    required this.labelBuilder,
  });

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
    GroupIconOption(
      id: 1,
      icon: AppIcons.groupHome,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelHome,
    ),
    GroupIconOption(
      id: 2,
      icon: AppIcons.groupSecurity,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelSecurity,
    ),
    GroupIconOption(
      id: 3,
      icon: AppIcons.groupCrypto,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelCrypto,
    ),
    GroupIconOption(
      id: 4,
      icon: AppIcons.groupFinance,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelFinance,
    ),
    GroupIconOption(
      id: 5,
      icon: AppIcons.groupCards,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelCards,
    ),
    GroupIconOption(
      id: 6,
      icon: AppIcons.groupPersonal,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelPersonal,
    ),
    GroupIconOption(
      id: 7,
      icon: AppIcons.groupUsers,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelUsers,
    ),
    GroupIconOption(
      id: 8,
      icon: AppIcons.groupIdentity,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelIdentity,
    ),
    GroupIconOption(
      id: 9,
      icon: AppIcons.groupBusiness,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelBusiness,
    ),
    GroupIconOption(
      id: 10,
      icon: AppIcons.groupTravel,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelTravel,
    ),
    GroupIconOption(
      id: 11,
      icon: AppIcons.groupSocial,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelSocial,
    ),
    GroupIconOption(
      id: 12,
      icon: AppIcons.groupWebsites,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelWebsites,
    ),
    GroupIconOption(
      id: 13,
      icon: AppIcons.groupEmail,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelEmail,
    ),
    GroupIconOption(
      id: 14,
      icon: AppIcons.groupMessaging,
      labelBuilder:
          (context) => AppLocalizations.of(context).iconLabelMessaging,
    ),
    GroupIconOption(
      id: 15,
      icon: AppIcons.groupShopping,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelShopping,
    ),
    GroupIconOption(
      id: 16,
      icon: AppIcons.groupGaming,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelGaming,
    ),
    GroupIconOption(
      id: 17,
      icon: AppIcons.groupMobile,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelMobile,
    ),
    GroupIconOption(
      id: 18,
      icon: AppIcons.groupWifi,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelWifi,
    ),
    GroupIconOption(
      id: 19,
      icon: AppIcons.groupBackup,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelBackup,
    ),
    GroupIconOption(
      id: 20,
      icon: AppIcons.groupCloud,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelCloud,
    ),
    GroupIconOption(
      id: 21,
      icon: AppIcons.groupProtection,
      labelBuilder:
          (context) => AppLocalizations.of(context).iconLabelProtection,
    ),
    GroupIconOption(
      id: 22,
      icon: AppIcons.groupConfiguration,
      labelBuilder:
          (context) => AppLocalizations.of(context).iconLabelConfiguration,
    ),
    GroupIconOption(
      id: 23,
      icon: AppIcons.groupStatistics,
      labelBuilder:
          (context) => AppLocalizations.of(context).iconLabelStatistics,
    ),
    GroupIconOption(
      id: 24,
      icon: AppIcons.groupServices,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelServices,
    ),
    GroupIconOption(
      id: 25,
      icon: AppIcons.groupDevelopment,
      labelBuilder:
          (context) => AppLocalizations.of(context).iconLabelDevelopment,
    ),
    GroupIconOption(
      id: 26,
      icon: AppIcons.groupBanking,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelBanking,
    ),
    GroupIconOption(
      id: defaultId,
      icon: AppIcons.groupOthers,
      labelBuilder: (context) => AppLocalizations.of(context).iconLabelOthers,
    ),
  ];

  static final Map<int, IconData> _byId = <int, IconData>{
    for (final option in options) option.id: option.icon,
  };

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

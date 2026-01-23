import 'package:custos/routes/routes.dart';
import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  /// Gets the current route
  String get currentRoute => routerDelegate.currentConfiguration.last.matchedLocation;

  /// Returns whether [name] is considered a main page.
  bool isMainRoute(String name) =>
      name == const PasswordsEntriesRoute().location ||
      name == const GroupsRoute().location ||
      name == const OtpRoute().location ||
      name == const AnalyticsRoute().location ||
      name == SettingsRoute().location;

  /// Gets the current route name
  String get currentRouteName => routerDelegate.currentConfiguration.last.route.name ?? '';

  /// Returns whether [name] is considered a main page.
  bool isMainRouteName(String name) => 
      name == PasswordsEntriesRoute.name || 
      name == GroupsRoute.name ||
      name == OtpRoute.name ||
      name == AnalyticsRoute.name ||
      name == SettingsRoute.name;

  /// Return the app bar title based on the current route.
  String appBarTitle(BuildContext context) {
    switch (currentRouteName) {
      case PasswordsEntriesRoute.name:
        return context.l10n.navPasswords;
      case GroupsRoute.name:
        return context.l10n.navGroups;
      case OtpRoute.name:
        return 'OTP';
      case AnalyticsRoute.name:
        return 'Analytics';
      case SettingsRoute.name:
        return context.l10n.navSettings;
      default:
        return '';
    }
  }
}

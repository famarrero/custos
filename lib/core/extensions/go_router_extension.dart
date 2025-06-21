import 'package:custos/routes/routes.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  /// Gets the current route
  String get currentRoute =>
      routerDelegate.currentConfiguration.last.matchedLocation;

  /// Returns whether [name] is considered a main page.
  bool isMainRoute(String name) =>
      name == const PasswordsEntriesRoute().location ||
      name == const SettingsRoute().location;

  /// Gets the current route name
  String get currentRouteName =>
      routerDelegate.currentConfiguration.last.route.name ?? '';

  /// Returns whether [name] is considered a main page.
  bool isMainRouteName(String name) =>
      name == PasswordsEntriesRoute.name || name == SettingsRoute.name;

  /// Return the app bar tile based on the current route.
  String get appBarTitle {
    switch (currentRouteName) {
      case PasswordsEntriesRoute.name:
        return 'Passwords';
      case GroupsRoute.name:
        return 'Groups';
      case SettingsRoute.name:
        return 'Settings';
      default:
        return '';
    }
  }
}

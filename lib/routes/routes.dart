import 'dart:async';

import 'package:custos/presentation/pages/main/main_page.dart';
import 'package:custos/presentation/pages/not_found/not_found_page.dart';
import 'package:custos/presentation/pages/passwords_entries/passwords_entries_page.dart';
import 'package:custos/presentation/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

final router = GoRouter(
  routes: $appRoutes,
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  onException: (_, __, router) => router.go(const PageNotFoundRoute().location),
);

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

@TypedShellRoute<MainRoute>(
  routes: [
    TypedGoRoute<PasswordsEntriesRoute>(
      path: PasswordsEntriesRoute.path,
      name: PasswordsEntriesRoute.name,
      routes: [
        TypedGoRoute<SettingsRoute>(
          path: SettingsRoute.path,
          name: SettingsRoute.name,
        ),
        TypedGoRoute<PageNotFoundRoute>(
          path: PageNotFoundRoute.path,
          name: PageNotFoundRoute.name,
        ),
      ],
    ),
  ],
)
class MainRoute extends ShellRouteData {
  const MainRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Page<void> pageBuilder(context, state, navigator) {
    return _routeTransition(
      state: state,
      context: context,
      child: MainPage(child: navigator),
    );
  }
}

class PasswordsEntriesRoute extends GoRouteData {
  static const path = '/';
  static const name = 'passwords-entries';

  const PasswordsEntriesRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const PasswordsEntriesPage(),
    );
  }
}

class SettingsRoute extends GoRouteData {
  static const path = '/settings';
  static const name = 'settings';

  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const SettingsPage(),
    );
  }
}

class PageNotFoundRoute extends GoRouteData {
  static const path = '/page-not-found';
  static const name = 'page-not-found';

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  const PageNotFoundRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const NotFoundPage(),
    );
  }
}

/// Routes custom animations
CustomTransitionPage<void> _routeTransition({
  required GoRouterState state,
  required BuildContext context,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    // barrierColor: context.theme.scaffoldBackgroundColor,
    reverseTransitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder: (_, animation, __, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.98,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOut)).animate(animation),
        child: FadeTransition(
          opacity: CurveTween(curve: Curves.easeOut).animate(animation),
          child: child,
        ),
      );
    },
  );
}

import 'dart:async';

import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/login_page.dart';
import 'package:custos/presentation/pages/wrapper_authenticated_routes/wrapper_authenticated_routes_page.dart';
import 'package:custos/presentation/pages/not_found/not_found_page.dart';
import 'package:custos/presentation/pages/passwords_entries/passwords_entries_page.dart';
import 'package:custos/presentation/pages/register/register_page.dart';
import 'package:custos/presentation/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: LoginRoute().location,
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

@TypedGoRoute<WrapperAppRoutes>(
  path: '/',
  routes: [
    TypedGoRoute<LoginRoute>(path: LoginRoute.path, name: LoginRoute.name),
    TypedGoRoute<RegisterRoute>(
      path: RegisterRoute.path,
      name: RegisterRoute.name,
    ),
    TypedShellRoute<WrapperAuthenticatedRoutes>(
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
    ),
  ],
)
class WrapperAppRoutes extends GoRouteData {
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final AuthCubit authCubit = context.read<AuthCubit>();

    if (authCubit.state.isUserAuthenticated) {
      // If the user is authenticated, redirect to the PasswordsEntriesRoute
      return PasswordsEntriesRoute().location;
    } else if (authCubit.state.isMasterKeySet) {
      // If the master key is set but the user is not authenticated, redirect to LoginRoute
      return LoginRoute().location;
    } else {
      // If the master key is not set, redirect to RegisterRoute
      return RegisterRoute().location;
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const SizedBox.shrink(),
    );
  }
}

class LoginRoute extends GoRouteData {
  static const path = 'login';
  static const name = 'login';

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  const LoginRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const LoginPage(),
    );
  }
}

class RegisterRoute extends GoRouteData {
  static const path = 'register';
  static const name = 'register';

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  const RegisterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _routeTransition(
      state: state,
      context: context,
      child: const RegisterPage(),
    );
  }
}

class WrapperAuthenticatedRoutes extends ShellRouteData {
  const WrapperAuthenticatedRoutes();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Page<void> pageBuilder(context, state, navigator) {
    return _routeTransition(
      state: state,
      context: context,
      child: WrapperAuthenticatedRoutesPage(child: navigator),
    );
  }
}

class PasswordsEntriesRoute extends GoRouteData {
  static const path = 'passwords-entries';
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
  static const path = 'settings';
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
  static const path = 'page-not-found';
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

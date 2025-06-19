import 'dart:async';

import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/presentation/pages/login/login_page.dart';
import 'package:custos/presentation/pages/wrapper_main/wrapper_main_page.dart';
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

@TypedShellRoute<WrapperMainRoute>(
  routes: [
    TypedGoRoute<PasswordsEntriesRoute>(
      path: PasswordsEntriesRoute.path,
      name: PasswordsEntriesRoute.name,
      routes: [
        TypedGoRoute<LoginRoute>(path: LoginRoute.path, name: LoginRoute.name),
        TypedGoRoute<RegisterRoute>(
          path: RegisterRoute.path,
          name: RegisterRoute.name,
        ),
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
class WrapperMainRoute extends ShellRouteData {
  const WrapperMainRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Page<void> pageBuilder(context, state, navigator) {
    return _routeTransition(
      state: state,
      context: context,
      child: WrapperMainPage(child: navigator),
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
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    // If the user is authenticated in and the current route is the LoginRoute, 
    // redirect to PasswordsEntriesRoute.
    if (context.read<AuthCubit>().state.isUserAuthenticated &&
        state.fullPath == const LoginRoute().location) {
      return const PasswordsEntriesRoute().location;
    }
    return null;
  }

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

class PasswordsEntriesRoute extends GoRouteData {
  static const path = '/';
  static const name = 'passwords-entries';

  const PasswordsEntriesRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final AuthRepository authRepository = di();
    final AuthCubit authCubit = context.read<AuthCubit>();
    
    // If the current route is PasswordsEntriesRoute
    if (state.fullPath == const PasswordsEntriesRoute().location) {
      // If masterKey is not set
      if (!(await authRepository.hasMasterKeyBeenSet())) {
        // Go to RegisterRoute
        return const RegisterRoute().location;
        // If masterKey is set and user is not authenticated
      } else if (await authRepository.hasMasterKeyBeenSet() &&
          !authCubit.state.isUserAuthenticated) {
        // Go to LoginRoute
        return const LoginRoute().location;
      }
    }

    return null;
  }

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

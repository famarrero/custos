import 'dart:async';

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_app_bar.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/cubit/auth/auth_cubit.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WrapperMainPage extends StatefulWidget {
  const WrapperMainPage({super.key, required this.child});

  final Widget child;

  @override
  State<WrapperMainPage> createState() => _WrapperMainPageState();
}

class _WrapperMainPageState extends State<WrapperMainPage> {
  DateTime? _lastBackPressedAt;
  bool _exitArmed = false;
  Timer? _exitArmTimer;

  void _armExitForTwoSeconds() {
    _exitArmTimer?.cancel();
    setState(() => _exitArmed = true);
    _exitArmTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _exitArmed = false);
    });
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    // When canPop == true and the pop succeeds, we don't need to do anything.
    if (didPop) return;

    // If there's anything to pop in the navigation stack, pop it normally.
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    final now = DateTime.now();
    final last = _lastBackPressedAt;
    final isOutsideWindow = last == null || now.difference(last) > const Duration(seconds: 3);

    if (isOutsideWindow) {
      _lastBackPressedAt = now;
      _armExitForTwoSeconds();
      context.showSnackBar(message: context.l10n.pressAgainToExit);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: _exitArmed,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: ScaffoldWidget(
        safeAreaTop: true,
        appBar: CustomAppBar(
          titleString: context.router.appBarTitle(context),
          actions: [
            CustomIconButton(
              icon: AppIcons.settings,
              onTap: () {
                context.push(SettingsRoute().location);
              },
            ),

            SizedBox(width: context.xxl),

            CustomIconButton(
              icon: AppIcons.logout,
              onTap: () {
                context.showConfirmationDialog(
                  title: context.l10n.logoutTitle,
                  subtitle: context.l10n.confirmLogoutTitle,
                  labelLeftButton: context.l10n.cancel,
                  onPressedLeftButton: (_) => context.pop(),
                  labelRightButton: context.l10n.logoutConfirmButton,
                  onPressedRightButton: (_) {
                    context.pop();
                    context.read<AuthCubit>().logout(GoRouter.of(context));
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _exitArmTimer?.cancel();
    super.dispose();
  }
}

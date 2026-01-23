import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_inkwell.dart';
import 'package:custos/presentation/components/custom_navigation_bar/cubit/custom_navigation_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// BottomNavigationBar
class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late GoRouter _router;
  late CustomNavigationBarCubit _customNavigationBarCubit;

  @override
  void initState() {
    _customNavigationBarCubit = CustomNavigationBarCubit(
      router: GoRouter.of(context),
    );

    _router = GoRouter.of(context);
    _router.routerDelegate.addListener(_onRouterLocationChanged);

    super.initState();
  }

  /// Callback triggered whenever the [GoRouter] location updates.
  void _onRouterLocationChanged() => _customNavigationBarCubit
      .onLocationChanged(location: _router.currentRoute);

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouterLocationChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomNavigationBarCubit, CustomNavigationBarState>(
      bloc: _customNavigationBarCubit,
      listener: (context, state) {
        if (state.currentPage.$2) {
          context.go(
            CustomNavigationBarCubit.pageToLocation(state.currentPage.$1),
          );
        }
      },
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(context.corner()),
            topLeft: Radius.circular(context.corner()),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _bottomBarItem(
                  context: context,
                  path: AppIcons.key,
                  label: context.l10n.navPasswords,
                  isSelected: state.currentPage.$1 == 0,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 0);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: AppIcons.groups,
                  label: context.l10n.navGroups,
                  isSelected: state.currentPage.$1 == 1,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 1);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: AppIcons.otp,
                  label: 'OTP',
                  isSelected: state.currentPage.$1 == 2,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 2);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: AppIcons.analytics,
                  label: 'Analytics',
                  isSelected: state.currentPage.$1 == 3,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 3);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: AppIcons.settings,
                  label: context.l10n.navSettings,
                  isSelected: state.currentPage.$1 == 4,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 4);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Create [Widget]s that will appear in the [NavigationBar]
  Widget _bottomBarItem({
    required BuildContext context,
    required IconData path,
    required String label,
    required bool isSelected,
    required Function()? onTap,
  }) {
    return CustomInkWell(
      padding: EdgeInsets.zero,
      hideGradient: true,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4.0,
        children: [
          Icon(
            path,
            color:
                isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color:
                  isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (isSelected)
            Container(
              width: 4.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_navigation_bar/cubit/custom_navigation_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

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
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(kMobileCorner),
            topLeft: Radius.circular(kMobileCorner),
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
                  path: HugeIcons.strokeRoundedKey01,
                  label: 'Passwords',
                  isSelected: state.currentPage.$1 == 0,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 0);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: HugeIcons.strokeRoundedGroup01,
                  label: 'Groups',
                  isSelected: state.currentPage.$1 == 1,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 1);
                  },
                ),
                _bottomBarItem(
                  context: context,
                  path: HugeIcons.strokeRoundedSettings01,
                  label: 'Settings',
                  isSelected: state.currentPage.$1 == 2,
                  onTap: () {
                    _customNavigationBarCubit.onPageChanged(page: 2);
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            spacing: 4.0,
            children: [
              Icon(
                path,
                color:
                    isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24.0,
              ),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color:
                      isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

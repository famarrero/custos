import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/extensions/go_router_extension.dart';
import 'package:custos/presentation/pages/settings/settings_page.dart';
import 'package:custos/routes/routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'custom_navigation_bar_state.dart';
part 'custom_navigation_bar_cubit.freezed.dart';

class CustomNavigationBarCubit extends Cubit<CustomNavigationBarState> {
  CustomNavigationBarCubit({required this.router}) : super(const CustomNavigationBarState());

  final GoRouter router;

  FutureOr<void> onPageChanged({required int page, bool redirect = true}) {
    emit(state.copyWith(currentPage: (page, redirect)));
  }

  FutureOr<void> onLocationChanged({required String location}) {
    if (router.isMainRoute(location) && location != pageToLocation(state.currentPage.$1)) {
      onPageChanged(page: _locationToPage(location), redirect: false);
    }
  }

  static String pageToLocation(int page) {
    switch (page) {
      case 0:
        return const PasswordsEntriesRoute().location;
      case 1:
        return const GroupsRoute().location;
      case 2:
        return SettingsRoute().location;
      default:
        return const PasswordsEntriesRoute().location;
    }
  }

  static int _locationToPage(String location) {
    if (location == const PasswordsEntriesRoute().location) {
      return 0;
    } else if (location == const GroupsRoute().location) {
      return 1;
    } else if (location == SettingsRoute().location) {
      return 2;
    } else {
      return 0;
    }
  }
}

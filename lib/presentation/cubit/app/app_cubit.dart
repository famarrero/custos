import 'package:bloc/bloc.dart';
import 'package:custos/core/app_environment.dart';
import 'package:custos/data/repositories/preferences/preferences_repository.dart';
import 'package:custos/di_container.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required ThemeMode themeMode, required Locale locale})
    : super(
        AppState(
          flavor: AppEnvironment.flavor,
          themeMode: themeMode,
          locale: locale,
          devicePreviewState: false,
        ),
      );

  final PreferencesRepository _preferencesRepository = di();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // void openDrawable() {
  //   if (_scaffoldKey.currentState != null) {
  //     _scaffoldKey.currentState!.openEndDrawer();
  //   }
  // }

  // void closeDrawable() {
  //   if (_scaffoldKey.currentState != null) {
  //     _scaffoldKey.currentState!.closeEndDrawer();
  //   }
  // }

  void onThemeChanged({required ThemeMode themeMode}) async {
    await _preferencesRepository.setThemeMode(themeMode: themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  void onLocaleChanged({required Locale locale}) async {
    await _preferencesRepository.setLocale(locale: locale);
    emit(state.copyWith(locale: locale));
  }

  void onDevicePreviewClicked() async {
    emit(state.copyWith(devicePreviewState: !state.devicePreviewState));
  }
}

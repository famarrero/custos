import 'package:bloc/bloc.dart';
import 'package:custos/core/app_environment.dart';
import 'package:custos/data/repositories/preference/preference_repository.dart';
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

  final PreferenceRepository _preferencesRepository = di();

  void onThemeChanged() async {
    ThemeMode themeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
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

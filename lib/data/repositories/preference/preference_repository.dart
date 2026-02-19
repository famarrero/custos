import 'package:flutter/material.dart';

abstract class PreferenceRepository {
  /// Get the ThemeMode saved
  Future<ThemeMode?> getThemeMode();

  /// Save the theme mode
  Future<void> setThemeMode({required ThemeMode themeMode});

  /// Get the locale saved
  Future<Locale> getLocale({required Locale defaultLocale});

  /// Save the locale
  Future<void> setLocale({required Locale locale});

  /// Return true if the locale is set by user
  Future<bool> get isLocaleSelected;

  /// Clear locale selection
  Future<void> get clearLocale;

  /// Returns true if the user has already seen the introduction flow.
  Future<bool> getHasSeenIntroduction();

  /// Mark the introduction as seen.
  Future<void> setHasSeenIntroduction({required bool value});
}

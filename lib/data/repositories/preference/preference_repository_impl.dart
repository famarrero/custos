import 'dart:async';

import 'package:custos/data/providers/preference/preference_provider.dart';
import 'package:custos/data/repositories/preference/preference_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PreferenceRepositoryImpl implements PreferenceRepository {
  final PreferenceProvider preferencesProvider = di();

  /// Key use to access to saved theme mode
  static const String _themeMode = 'theme_mode';

  /// Key use to access to saved locale
  static const String _locale = 'locale';

  @override
  Future<ThemeMode?> getThemeMode() async {
    final themeIndex = await preferencesProvider.getInt(key: _themeMode);
    return themeIndex != null ? ThemeMode.values[themeIndex] : null;
  }

  @override
  Future<void> setThemeMode({required ThemeMode themeMode}) async =>
      await preferencesProvider.setInt(value: themeMode.index, key: _themeMode);

  @override
  Future<Locale> getLocale({required Locale defaultLocale}) async {
    final locale = Locale(
      await preferencesProvider.getString(key: _locale) ??
          defaultLocale.languageCode,
    );
    return !AppLocalizations.supportedLocales.contains(locale)
        ? AppLocalizations.supportedLocales.first
        : locale;
  }

  @override
  Future<void> setLocale({required Locale locale}) async =>
      await preferencesProvider.setString(
        value: locale.languageCode,
        key: _locale,
      );

  @override
  Future<bool> get isLocaleSelected async =>
      await preferencesProvider.getString(key: _locale) != null;

  @override
  Future<void> get clearLocale async =>
      await preferencesProvider.remove(key: _locale);
}

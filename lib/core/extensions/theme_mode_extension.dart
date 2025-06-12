import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  /// Returns if the [ThemeMode] is the darks one
  bool get isDarkMode => this == ThemeMode.dark;

  /// Returns if the [ThemeMode] is the light one
  bool get isLightMode => this == ThemeMode.light;
}

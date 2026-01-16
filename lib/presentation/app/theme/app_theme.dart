import 'package:custos/core/extensions/theme_mode_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/core/utils/device_type.dart';
import 'package:custos/presentation/app/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

/// The themes for the app
///
/// It includes [textTheme] and the [_colorScheme].
class AppTheme extends ThemeExtension<AppTheme> {
  /// Used to initialize some properties depending of the current theme
  final ThemeMode themeMode;

  /// Determine the type of device
  /// [DeviceType.mobile] for mobile devices
  /// [DeviceType.tablet] for tablets
  final DeviceType deviceType;

  /// ColorScheme according to the theme
  late ColorScheme _colorScheme;

  /// TextTheme according to the variant
  late TextTheme _textTheme;

  /// IconSize apply to all [IconButton] depending of the current variant
  late double _iconSize;

  /// Padding of the TextField.
  late EdgeInsets _contentPadding;

  /// Border radius of dialog.
  late double _dialogBorderRadius;

  AppTheme({required this.themeMode, required this.deviceType}) {
    // Initialize variables depending of the current ThemeMode
    if (themeMode.isDarkMode) {
      // Color scheme for light mode.
      _colorScheme = const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xff6B47CE),
        surfaceTint: Color(0xffa6c8ff),
        onPrimary: Color(0xff00344a),
        primaryContainer: Color(0xff224876),
        onPrimaryContainer: Color(0xffd4e3ff),
        secondary: Color(0xffbcc7dc),
        onSecondary: Color(0xff273141),
        secondaryContainer: Color(0xff3d4758),
        onSecondaryContainer: Color(0xffd8e3f8),
        tertiary: Color(0xffdabde2),
        onTertiary: Color(0xff3d2846),
        tertiaryContainer: Color(0xff553f5d),
        onTertiaryContainer: Color(0xfff7d8ff),
        error: Color(0xffffb4ab),
        onError: Color(0xff690005),
        errorContainer: Color(0xff93000a),
        onErrorContainer: Color(0xffffdad6),
        surface: Color(0xff111318),
        onSurface: Color(0xffe1e2e9),
        onSurfaceVariant: Color(0xffc3c6cf),
        outline: Color(0xff8d9199),
        outlineVariant: Color(0xff43474e),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xffe1e2e9),
        inversePrimary: Color(0xff3c6090),
        primaryFixed: Color(0xffd4e3ff),
        onPrimaryFixed: Color(0xff001c3a),
        primaryFixedDim: Color(0xffa6c8ff),
        onPrimaryFixedVariant: Color(0xff224876),
        secondaryFixed: Color(0xffd8e3f8),
        onSecondaryFixed: Color(0xff111c2b),
        secondaryFixedDim: Color(0xffbcc7dc),
        onSecondaryFixedVariant: Color(0xff3d4758),
        tertiaryFixed: Color(0xfff7d8ff),
        onTertiaryFixed: Color(0xff271430),
        tertiaryFixedDim: Color(0xffdabde2),
        onTertiaryFixedVariant: Color(0xff553f5d),
        surfaceDim: Color(0xff111318),
        surfaceBright: Color(0xff37393e),
        surfaceContainerLowest: Color(0xff0c0e13),
        surfaceContainerLow: Color(0xff191c20),
        surfaceContainer: Color(0xff1d2024),
        surfaceContainerHigh: Color(0xff282a2f),
        surfaceContainerHighest: Color(0xff32353a),
      );
    }

    if (themeMode.isLightMode) {
      // Color scheme for light mode.
      _colorScheme = const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff6B47CE),
        surfaceTint: Color(0xff3c6090),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xffd4e3ff),
        onPrimaryContainer: Color(0xff224876),
        secondary: Color(0xff545f71),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xffd8e3f8),
        onSecondaryContainer: Color(0xff3d4758),
        tertiary: Color(0xff6e5676),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xfff7d8ff),
        onTertiaryContainer: Color(0xff553f5d),
        error: Color(0xffba1a1a),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffffdad6),
        onErrorContainer: Color(0xff93000a),
        surface: Color(0xfff9f9ff),
        onSurface: Color(0xff191c20),
        onSurfaceVariant: Color(0xff43474e),
        outline: Color(0xff74777f),
        outlineVariant: Color(0xffc3c6cf),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff2e3035),
        inversePrimary: Color(0xffa6c8ff),
        primaryFixed: Color(0xffd4e3ff),
        onPrimaryFixed: Color(0xff001c3a),
        primaryFixedDim: Color(0xffa6c8ff),
        onPrimaryFixedVariant: Color(0xff224876),
        secondaryFixed: Color(0xffd8e3f8),
        onSecondaryFixed: Color(0xff111c2b),
        secondaryFixedDim: Color(0xffbcc7dc),
        onSecondaryFixedVariant: Color(0xff3d4758),
        tertiaryFixed: Color(0xfff7d8ff),
        onTertiaryFixed: Color(0xff271430),
        tertiaryFixedDim: Color(0xffdabde2),
        onTertiaryFixedVariant: Color(0xff553f5d),
        surfaceDim: Color(0xffd9dae0),
        surfaceBright: Color(0xfff9f9ff),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff3f3fa),
        surfaceContainer: Color(0xffededf4),
        surfaceContainerHigh: Color(0xffe7e8ee),
        surfaceContainerHighest: Color(0xffe1e2e9),
      );
    }

    if (deviceType == DeviceType.isMobile) {
      // Set the text theme according to the device type.
      _textTheme = _buildBaseTextTheme(
        baseBodyMediumFontSize: 16,
        colorScheme: _colorScheme,
      );

      _iconSize = 20;
      _contentPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 14);
      _dialogBorderRadius = AppSpacing.baseCorner;
    } else {
      // Set the text theme according to the device type.
      _textTheme = _buildBaseTextTheme(
        baseBodyMediumFontSize: 18,
        colorScheme: _colorScheme,
      );

      _iconSize = 30;
      _contentPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 18);
      _dialogBorderRadius = AppSpacing.baseCorner * 1.2;
    }
  }

  ThemeData toThemeData() => ThemeData(
    extensions: [this],
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    scaffoldBackgroundColor: _colorScheme.surfaceContainerLow,
    iconTheme: IconThemeData(color: _colorScheme.primary, size: _iconSize),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        foregroundColor: _colorScheme.onPrimaryContainer,
        iconSize: _iconSize,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      // There must be at least one style from even if it is empty
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.baseMobile,
          vertical: AppSpacing.baseMobile,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.baseCorner),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      // There must be at least one style from even if it is empty
      style: TextButton.styleFrom(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: _textTheme.bodyMedium?.copyWith(
        color: _colorScheme.onSurface,
      ),
      hintStyle: _textTheme.bodySmall?.copyWith(color: _colorScheme.outline),
      contentPadding: _contentPadding,
      border: WidgetStateInputBorder.resolveWith(
        (states) => OutlineInputBorder(
          borderSide: BorderSide(color: _colorScheme.secondary),
          borderRadius: const BorderRadius.all(
            Radius.circular(AppSpacing.baseCorner),
          ),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _colorScheme.surface,
      surfaceTintColor: _colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogBorderRadius),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: _colorScheme.secondary,
      unselectedItemColor: _colorScheme.primary.withValues(alpha: 0.6),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _colorScheme.primary,
      foregroundColor: _colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.baseCorner),
      ),
    ),
  );

  @override
  ThemeExtension<AppTheme> copyWith({
    ThemeMode? themeMode,
    DeviceType? deviceType,
  }) {
    return AppTheme(
      themeMode: themeMode ?? this.themeMode,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    if (other is! AppTheme) return this;
    return AppTheme(themeMode: other.themeMode, deviceType: other.deviceType);
  }
}

TextTheme _buildBaseTextTheme({
  required double baseBodyMediumFontSize,
  required ColorScheme colorScheme,
}) {
  return TextTheme(
    // DISPLAY
    displayLarge: TextStyle(
      fontSize: baseBodyMediumFontSize + 18,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    displayMedium: TextStyle(
      fontSize: baseBodyMediumFontSize + 16,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    displaySmall: TextStyle(
      fontSize: baseBodyMediumFontSize + 14,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),

    // HEADLINE
    headlineLarge: TextStyle(
      fontSize: baseBodyMediumFontSize + 12,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    headlineMedium: TextStyle(
      fontSize: baseBodyMediumFontSize + 10,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    headlineSmall: TextStyle(
      fontSize: baseBodyMediumFontSize + 8,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),

    // TITLE
    titleLarge: TextStyle(
      fontSize: baseBodyMediumFontSize + 6,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    titleMedium: TextStyle(
      fontSize: baseBodyMediumFontSize + 4,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),
    titleSmall: TextStyle(
      fontSize: baseBodyMediumFontSize + 2,
      fontWeight: FontWeight.w700,
      fontFamily: FontFamily.nunito,
    ),

    // BODY
    bodyLarge: TextStyle(
      fontSize: baseBodyMediumFontSize + 2,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
      fontFamily: FontFamily.nunito,
    ),
    bodyMedium: TextStyle(
      fontSize: baseBodyMediumFontSize,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
      fontFamily: FontFamily.nunito,
    ),
    bodySmall: TextStyle(
      fontSize: baseBodyMediumFontSize - 2,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
      fontFamily: FontFamily.nunito,
    ),

    // LABEL
    labelLarge: TextStyle(
      fontSize: baseBodyMediumFontSize,
      fontWeight: FontWeight.w300,
      letterSpacing: 1.5,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
      fontFamily: FontFamily.nunito,
    ),
    labelMedium: TextStyle(
      fontSize: baseBodyMediumFontSize - 1,
      fontWeight: FontWeight.w300,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
      fontFamily: FontFamily.nunito,
    ),
    labelSmall: TextStyle(
      fontSize: baseBodyMediumFontSize - 2,
      fontWeight: FontWeight.w300,
      letterSpacing: 1.5,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
      fontFamily: FontFamily.nunito,
    ),
  );
}

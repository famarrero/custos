import 'package:custos/core/utils/device_type.dart';
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

  /// TextTheme according to the variant
  late TextTheme _textTheme;
  
  /// ColorScheme according to the theme
  late ColorScheme _colorScheme;

  /// IconSize apply to all [IconButton] depending of the current variant
  late double _iconSize;

  /// Padding of the TextField.
  late EdgeInsets _contentPadding;

  /// Border radius of dialog.
  late double _dialogBorderRadius;

  late double bodyMediumFontSize;

  AppTheme({required this.themeMode, required this.deviceType}) {
    // Initialize variables depending of the current ThemeMode
    if (themeMode.isDarkMode) {
      // Color scheme for light mode.
      _colorScheme = const ColorScheme(
        primary: Color(0xFFF4BD4A),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFF4BD4A),
        onPrimaryContainer: Color(0xFF28282C),
        secondary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFF000000),
        onSecondaryContainer: Color(0xFFFFFFFF),
        tertiary: Color(0xFFF23031),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFF23031),
        onTertiaryContainer: Color(0xFFFFFFFF),
        error: Color(0xFFF23031),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFF23031),
        onErrorContainer: Color(0xFFFFFFFF),
        surface: Color(0xFFF3F3F3),
        onSurface: Color(0xFF28282C),
        surfaceContainerHighest: Color(0xFFFFFFFF),
        onSurfaceVariant: Color(0xFF28282C),
        brightness: Brightness.dark,
      );
    }

    if (themeMode.isLightMode) {
      // Color scheme for light mode.
      _colorScheme = const ColorScheme(
        primary: Color(0xFFF4BD4A),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFF4BD4A),
        onPrimaryContainer: Color(0xFF28282C),
        secondary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFF000000),
        onSecondaryContainer: Color(0xFFFFFFFF),
        tertiary: Color(0xFFF23031),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFF23031),
        onTertiaryContainer: Color(0xFFFFFFFF),
        error: Color(0xFFF23031),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFF23031),
        onErrorContainer: Color(0xFFFFFFFF),
        surface: Color(0xFFF3F3F3),
        onSurface: Color(0xFF28282C),
        surfaceContainerHighest: Color(0xFFFFFFFF),
        onSurfaceVariant: Color(0xFF28282C),
        brightness: Brightness.light,
      );
    }

    // Set the text theme according to the device type.
    if (deviceType == DeviceType.isMobile) {
      _dialogBorderRadius = kMobileCorner;
      _iconSize = 24;
      _contentPadding = const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      );
      _textTheme = const TextTheme(
        // DISPLAY
        displayLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 32.0,
        ),
        displayMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 30.0,
        ),
        displaySmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 28.0,
        ),

        // HEAD LINE
        headlineLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w700,
          fontSize: 26.0,
        ),
        headlineMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
        ),
        headlineSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w700,
          fontSize: 22.0,
        ),

        // TITLE
        titleLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 20.0,
        ),
        titleMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 18.0,
        ),
        titleSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 16.0,
        ),

        // BODY
        bodyLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        bodyMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        bodySmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),

        // LABEL
        labelLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
          letterSpacing: 1.5,
        ),
        labelMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 14.0,
          letterSpacing: 1.5,
        ),
        labelSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 12.0,
          letterSpacing: 1.5,
        ),
      );
    } else {
      _dialogBorderRadius = kMobileCorner;
      _iconSize = 28;
      _contentPadding = const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      );
      _textTheme = const TextTheme(
        // DISPLAY
        displayLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 57.0,
        ),
        displayMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 45.0,
        ),
        displaySmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 36.0,
        ),

        // HEAD LINE
        headlineLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 30.0,
        ),
        headlineMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 28.0,
        ),
        headlineSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w600,
          fontSize: 26.0,
        ),

        // TITLE
        titleLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 24.0,
        ),
        titleMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 22.0,
        ),
        titleSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w800,
          fontSize: 20.0,
        ),

        // BODY
        bodyLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 22.0,
        ),
        bodyMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
        bodySmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),

        // LABEL
        labelLarge: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 20.0,
          letterSpacing: 1.5,
        ),
        labelMedium: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 18.0,
          letterSpacing: 1.5,
        ),
        labelSmall: TextStyle(
          fontFamily: FontFamily.akshar,
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
          letterSpacing: 1.5,
        ),
      );
    }

    // Applying the color scheme to the text theme.
    _textTheme = _textTheme.apply(
      displayColor: _colorScheme.onPrimaryContainer,
      bodyColor: _colorScheme.onSurface,
    );
  }

  ThemeData toThemeData() => ThemeData(
    extensions: [this],
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    scaffoldBackgroundColor: _colorScheme.surface,
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
      style: TextButton.styleFrom(),
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
          borderSide: BorderSide(color: _colorScheme.secondary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(kMobileCorner)),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
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

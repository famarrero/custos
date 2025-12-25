import 'package:custos/core/extensions/theme_mode_extension.dart';
import 'package:custos/core/utils/constants.dart';
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

  static const double _defaultTextAlpha = 0.75;

  // Tablet values are derived from mobile base values using these multipliers
  // to keep the UI visually equivalent across breakpoints.
  static const double _tabletBodyScale = 20.0 / 14.0; // 14 -> 20
  static const double _tabletIconScale = 28.0 / 24.0; // 24 -> 28
  static const double _tabletVerticalPaddingScale = 1.2; // v * 1.2

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

    // Set the text theme according to the device type.
    _configureForDeviceType(
      baseTextTheme: _buildBaseTextTheme(
        baseBodyMediumFontSize: 16.0,
        baseColor: _colorScheme.onSurface.withValues(alpha: _defaultTextAlpha),
      ),
      baseDialogBorderRadius: kMobileCorner,
      baseIconSize: 24.0,
      baseContentPadding: const EdgeInsets.symmetric(
        horizontal: kMobileHorizontalPadding,
        vertical: kMobileVerticalPadding,
      ),
      baseBodyMediumFontSize: 16.0,
    );
  }

  void _configureForDeviceType({
    required TextTheme baseTextTheme,
    required double baseDialogBorderRadius,
    required double baseIconSize,
    required EdgeInsets baseContentPadding,
    required double baseBodyMediumFontSize,
  }) {
    final bool isMobile = deviceType == DeviceType.isMobile;

    final double scale = isMobile ? 1.0 : _tabletBodyScale;

    _dialogBorderRadius = baseDialogBorderRadius;
    _iconSize =
        isMobile
            ? baseIconSize
            : _roundToDouble(baseIconSize * _tabletIconScale, 0);
    _contentPadding =
        isMobile
            ? baseContentPadding
            : EdgeInsets.fromLTRB(
              baseContentPadding.left,
              baseContentPadding.top * _tabletVerticalPaddingScale,
              baseContentPadding.right,
              baseContentPadding.bottom * _tabletVerticalPaddingScale,
            );

    bodyMediumFontSize = _roundToDouble(baseBodyMediumFontSize * scale, 1);
    _textTheme = _scaleTextTheme(baseTextTheme, scale);
  }

  TextTheme _buildBaseTextTheme({
    required double baseBodyMediumFontSize,
    required Color baseColor,
  }) {
    // Mobile is the source-of-truth. Tablet is computed by scaling this theme.
    final double bm = baseBodyMediumFontSize;

    TextStyle s({
      required double size,
      required FontWeight weight,
      Color? color,
      double? letterSpacing,
    }) {
      return TextStyle(
        fontFamily: FontFamily.inter,
        fontWeight: weight,
        fontSize: size,
        color: color,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      // DISPLAY
      displayLarge: s(size: bm + 18, weight: FontWeight.w600),
      displayMedium: s(size: bm + 16, weight: FontWeight.w600),
      displaySmall: s(size: bm + 14, weight: FontWeight.w600),

      // HEADLINE
      headlineLarge: s(size: bm + 12, weight: FontWeight.w700),
      headlineMedium: s(size: bm + 10, weight: FontWeight.w700),
      headlineSmall: s(size: bm + 8, weight: FontWeight.w700),

      // TITLE
      titleLarge: s(size: bm + 6, weight: FontWeight.w800),
      titleMedium: s(size: bm + 4, weight: FontWeight.w800),
      titleSmall: s(size: bm + 2, weight: FontWeight.w800),

      // BODY
      bodyLarge: s(size: bm + 2, weight: FontWeight.w600, color: baseColor),
      bodyMedium: s(size: bm, weight: FontWeight.w600, color: baseColor),
      bodySmall: s(size: bm - 2, weight: FontWeight.w600, color: baseColor),

      // LABEL
      labelLarge: s(
        size: bm,
        weight: FontWeight.w600,
        letterSpacing: 1.5,
        color: baseColor,
      ),
      labelMedium: s(
        size: bm - 2,
        weight: FontWeight.w600,
        letterSpacing: 1.5,
        color: baseColor,
      ),
      labelSmall: s(
        size: bm - 3,
        weight: FontWeight.w600,
        letterSpacing: 1.5,
        color: baseColor,
      ),
    );
  }

  TextTheme _scaleTextTheme(TextTheme base, double scale) {
    TextStyle? st(TextStyle? style) {
      if (style == null) return null;
      final size = style.fontSize;
      if (size == null) return style;
      return style.copyWith(fontSize: _roundToDouble(size * scale, 1));
    }

    return base.copyWith(
      displayLarge: st(base.displayLarge),
      displayMedium: st(base.displayMedium),
      displaySmall: st(base.displaySmall),
      headlineLarge: st(base.headlineLarge),
      headlineMedium: st(base.headlineMedium),
      headlineSmall: st(base.headlineSmall),
      titleLarge: st(base.titleLarge),
      titleMedium: st(base.titleMedium),
      titleSmall: st(base.titleSmall),
      bodyLarge: st(base.bodyLarge),
      bodyMedium: st(base.bodyMedium),
      bodySmall: st(base.bodySmall),
      labelLarge: st(base.labelLarge),
      labelMedium: st(base.labelMedium),
      labelSmall: st(base.labelSmall),
    );
  }

  double _roundToDouble(double value, int decimals) {
    final factor = switch (decimals) {
      0 => 1.0,
      1 => 10.0,
      2 => 100.0,
      3 => 1000.0,
      _ => 10.0,
    };
    return (value * factor).roundToDouble() / factor;
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
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMobileCorner),
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
          borderSide: BorderSide(color: _colorScheme.secondary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(kMobileCorner)),
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

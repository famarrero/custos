import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get warningContainer =>
      brightness == Brightness.light
          ? const Color.fromARGB(82, 249, 184, 71)
          : const Color.fromARGB(82, 249, 184, 71);

  Color get waring =>
      brightness == Brightness.light
          ? const Color.fromARGB(255, 255, 164, 8)
          : const Color.fromARGB(255, 255, 164, 8);

  /// Colores para la gráfica de fortaleza de contraseñas (fuerte, media, débil).
  Color get passwordStrengthStrong => const Color(0xFF2196F3);
  Color get passwordStrengthMedium => const Color(0xFFFF9800);
  Color get passwordStrengthWeak => const Color(0xFFE53935);

  /// Returns the contrast color based on the brightness of the color scheme.
  Color contrastColor({Color lightColor = Colors.black, Color darkColor = Colors.white}) =>
      brightness == Brightness.light ? lightColor : darkColor;
}

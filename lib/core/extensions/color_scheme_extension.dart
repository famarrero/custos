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
  
  /// Returns the contrast color based on the brightness of the color scheme.
  Color contrastColor({Color lightColor = Colors.black, Color darkColor = Colors.white}) =>
      brightness == Brightness.light ? lightColor : darkColor;
}

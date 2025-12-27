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

  Color get blackAndWith =>
      brightness == Brightness.light ? Colors.black : Colors.white;
}

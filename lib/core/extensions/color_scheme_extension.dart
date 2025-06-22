import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get waring =>
      brightness == Brightness.light
          ? const Color.fromARGB(255, 228, 151, 17)
          : const Color.fromARGB(255, 228, 151, 17);
}

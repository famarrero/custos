import 'dart:convert';

import 'package:custos/core/utils/reg_exp.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';

/// Support methods for the String class.
extension StringExtension on String {
  bool get isValidEmail {
    return regExpValidEmail.hasMatch(this);
  }

  bool get isValidURL {
    return regExpValidURL.hasMatch(this);
  }

  /// Convert String to double and multiplicate by 100 to convert to int.
  int get fromDecimalStringToInt {
    return (double.parse(this) * 100).toInt();
  }
  
  /// Get the first character of String and convert to UpperCase.
  String get firstLetterToUpperCase {
    return this[0].toUpperCase();
  }

  /// Trim and convert to LowerCase.
  String get trimToLowerCase {
    return trim().toLowerCase();
  }

  /// Replaces each character in the string with an asterisk (*).
  String get masked => '*' * length;

  /// Convert String to IconData.
  IconData? get toIconData {
    try {
      final decoded = jsonDecode(this);
      if (decoded is! Map<String, dynamic>) return null;

      // Migration fallback: previously stored icons from the `hugeicons` package.
      // If the package is no longer present, the glyph won't render.
      final fontPackage = decoded['fontPackage'] as String?;
      if (fontPackage == 'hugeicons') return AppIcons.groupOthers;

      return IconData(
        decoded['codePoint'] as int,
        fontFamily: decoded['fontFamily'] as String?,
        fontPackage: fontPackage,
        matchTextDirection: decoded['matchTextDirection'] as bool? ?? false,
      );
    } catch (_) {
      return null;
    }
  }
}

extension NullableStringExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

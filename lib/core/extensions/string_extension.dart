import 'dart:convert';

import 'package:custos/core/utils/reg_exp.dart';
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
    final json = jsonDecode(this);
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: json['fontPackage'] as String?,
      matchTextDirection: json['matchTextDirection'] as bool? ?? false,
    );
  }
}

extension NullableStringExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

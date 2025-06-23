import 'dart:convert';

import 'package:flutter/material.dart';

/// Support methods for the String class.
extension IconDataExtension on IconData {
  String get toJsonString {
    return jsonEncode({
      'codePoint': codePoint,
      'fontFamily': fontFamily,
      'fontPackage': fontPackage,
      'matchTextDirection': matchTextDirection,
    });
  }
}

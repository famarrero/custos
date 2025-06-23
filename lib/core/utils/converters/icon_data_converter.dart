import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class IconDataConverter implements JsonConverter<IconData?, Map<String, dynamic>?> {
  const IconDataConverter();

  @override
  IconData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: json['fontPackage'] as String?,
      matchTextDirection: json['matchTextDirection'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic>? toJson(IconData? icon) {
    if (icon == null) return null;
    return {
      'codePoint': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
      'matchTextDirection': icon.matchTextDirection,
    };
  }
}

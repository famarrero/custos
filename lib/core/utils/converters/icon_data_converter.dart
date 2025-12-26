import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:custos/core/utils/app_icons.dart';

class IconDataConverter implements JsonConverter<IconData?, Map<String, dynamic>?> {
  const IconDataConverter();

  @override
  IconData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final fontPackage = json['fontPackage'] as String?;

    // Migration fallback: old persisted icons from the `hugeicons` package.
    if (fontPackage == 'hugeicons') return AppIcons.groupOthers;
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String?,
      fontPackage: fontPackage,
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

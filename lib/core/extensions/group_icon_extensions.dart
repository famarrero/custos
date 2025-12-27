import 'package:custos/core/utils/group_icons.dart';
import 'package:flutter/material.dart';

extension GroupIconIdExtensions on int? {
  /// Converts a persisted group icon id to its `IconData`.
  ///
  /// If the id is null/unknown, returns the default group icon.
  IconData get toGroupIconData => GroupIcons.iconFor(this);
}

extension GroupIconDataExtensions on IconData? {
  /// Converts an `IconData` to a persisted group icon id.
  ///
  /// If the icon isn't part of the registry, returns null.
  int? get toGroupIconId => GroupIcons.idOf(this);
}



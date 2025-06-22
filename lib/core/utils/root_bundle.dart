import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> loadPrivacyPolicy(BuildContext context) async {
  final locale = Localizations.localeOf(context).languageCode;
  final path = 'assets/md/privacy_policy/$locale.md';
  return await rootBundle.loadString(path);
}
import 'dart:io';

import 'package:flutter/foundation.dart';

// Build release of prod flavor
// flutter build apk --flavor prod --dart-define=flavor=prod

// Build debug of prod flavor
// flutter build apk --flavor prod --dart-define=flavor=prod --debug

// Build release of dev flavor
// flutter build apk --flavor dev --dart-define=flavor=dev

// Build debug of dev flavor
// flutter build apk --flavor dev --dart-define=flavor=dev --debug

class AppEnvironment {
  /// The current flavor of the app.
  static const flavor = String.fromEnvironment(
    'flavor',
    defaultValue: kDevFlavor,
  );

  /// Whether the current flavor is dev.
  static const isDev = flavor == kDevFlavor;

  /// Whether the current flavor is prod.
  static const isProd = flavor == kProdFlavor;

  static final isWindows = !kIsWeb && Platform.isWindows;
  static final isAndroid = !kIsWeb && Platform.isAndroid;
  static final isIOS = !kIsWeb && Platform.isIOS;
  static final isMacOS = !kIsWeb && Platform.isMacOS;

  /// Return true if flavor is dev or app is running in debug mode.
  static const isDevOrDebugMode = isDev || kDebugMode;
}

const kDevFlavor = 'dev';
const kProdFlavor = 'prod';

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get custos => 'Custos';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get unknownErrorOccurred => 'An unknown error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidField => 'Invalid field';

  @override
  String get passwordsNotMatch => 'Passwords not match';

  @override
  String get incorrectMasterKey => 'Master key is incorrect';

  @override
  String get masterKeyNotSet => 'Master key not set yet';
}

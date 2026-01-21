import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDate {
    final locale = Intl.getCurrentLocale();
    final normalized = locale.toLowerCase();
    final pattern = normalized.startsWith('en') ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    return DateFormat(pattern, locale).format(toLocal());
  }

  String get formatDateTimeAmPm {
    final locale = Intl.getCurrentLocale();
    final normalized = locale.toLowerCase();
    final pattern = normalized.startsWith('en') ? 'MM/dd/yyyy hh:mm a' : 'dd/MM/yyyy hh:mm a';
    return DateFormat(pattern, locale).format(toLocal());
  }
}

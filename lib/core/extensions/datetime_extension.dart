import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formatDate {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
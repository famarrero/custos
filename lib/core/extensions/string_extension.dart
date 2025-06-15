import 'package:custos/core/utils/reg_exp.dart';

/// Support methods for the String class.
extension StringExtension on String {
  bool get isValidEmail {
    return regExpValidEmail.hasMatch(this);
  }

  /// Convert String to double and multiplicate by 100 to convert to int.
  int get fromDecimalStringToInt {
    return (double.parse(this) * 100).toInt();
  }
}

extension NullableStringExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

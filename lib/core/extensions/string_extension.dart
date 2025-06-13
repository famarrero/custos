/// Support methods for the String class.
extension StringExtension on String {
  /// Convert String to double and multiplicate by 100 to convert to int.
  int get fromDecimalStringToInt {
    return (double.parse(this) * 100).toInt();
  }
}

extension NullableStringExtension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

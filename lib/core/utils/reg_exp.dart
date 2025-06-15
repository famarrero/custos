/// Validate email.
final regExpValidEmail = RegExp(
  r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);

/// Validate phone number.
final regExpValidPhone = RegExp(
  r'^(?:[+0][1-9])?[0-9]{10,12}$',
);

/// Only decimals.
/// Valid examples 12.34, 0.12, 123.45, 8.1, 89.
final regExpOnlyDecimal = RegExp(r'^\d*\.?\d{0,2}');

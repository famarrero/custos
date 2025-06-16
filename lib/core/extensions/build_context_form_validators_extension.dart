import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:flutter/material.dart';

/// Extension of [BuildContext] to form validators.
extension BuildContextFormValidatorsExtension on BuildContext {
  /// Validate that a field is required
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.requiredField;
    } else {
      return null;
    }
  }

  /// Validate that a object is required
  String? validateRequiredObject(dynamic value) {
    if (value == null) {
      return l10n.requiredField;
    } else {
      return null;
    }
  }

  /// Validate the email field
  String? validateEmail(String? email, {bool isRequired = false}) {
    if (isRequired) {
      if (email == null || email.isEmpty) {
        return l10n.requiredField;
      } else if (!email.isValidEmail) {
        return l10n.invalidField;
      }
    } else {
      if (email != null && email.isNotEmpty) {
        if (!email.isValidEmail) {
          return l10n.invalidField;
        }
      }
    }
    return null;
  }

  /// Validate the URL field
  String? validateURL(String? url, {bool isRequired = false}) {
    if (isRequired) {
      if (url == null || url.isEmpty) {
        return l10n.requiredField;
      } else if (!url.isValidURL) {
        return l10n.invalidField;
      }
    } else {
      if (url != null && url.isNotEmpty) {
        if (!url.isValidURL) {
          return l10n.invalidField;
        }
      }
    }
    return null;
  }

  /// Validate that passwords match
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return l10n.requiredField;
    } else {
      return null;
    }
  }

  /// Validate that passwords match
  String? validatePasswordMatch(String? password1, String? password2) {
    if (password2 == null || password2.isEmpty) {
      return l10n.requiredField;
    } else if (password1 != password2) {
      return l10n.passwordsNotMatch;
    } else {
      return null;
    }
  }
}

enum PasswordStrength { weak, medium, strong }

class AuxMethods {
  static PasswordStrength evaluatePasswordStrength(String password) {
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSymbol = RegExp(r'[^a-zA-Z0-9]').hasMatch(password);

    final length = password.length;

    // Débil
    if (length < 8) {
      return PasswordStrength.weak;
    }

    final varietyCount = [hasLower, hasUpper, hasNumber, hasSymbol].where((e) => e).length;

    if (varietyCount <= 1) {
      return PasswordStrength.weak;
    }

    // Fuerte
    if (length >= 12 && varietyCount >= 3 && hasSymbol) {
      return PasswordStrength.strong;
    }

    // Media
    return PasswordStrength.medium;
  }
}

import 'dart:math';

import 'package:custos/presentation/components/password_generator/cubit/password_generator_cubit.dart';

extension PasswordGeneratorStateExtension on PasswordGeneratorState {
  /// Generates a secure password based on the current state
  String generatePassword() {
    const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_-+=<>?/{}[]|~';

    String allowedChars = '';
    final passwordChars = <String>[];

    // Build the allowed character set and ensure at least one of each selected type
    if (includeUppercase) {
      allowedChars += upperCaseLetters;
      passwordChars.add(_randomChar(upperCaseLetters));
    }
    if (includeLowercase) {
      allowedChars += lowerCaseLetters;
      passwordChars.add(_randomChar(lowerCaseLetters));
    }
    if (includeNumbers) {
      allowedChars += numbers;
      passwordChars.add(_randomChar(numbers));
    }
    if (includeSymbols) {
      allowedChars += symbols;
      passwordChars.add(_randomChar(symbols));
    }

    if (allowedChars.isEmpty) return ''; // or throw if desired

    final random = Random.secure();

    // Fill the rest of the password
    while (passwordChars.length < length) {
      passwordChars.add(allowedChars[random.nextInt(allowedChars.length)]);
    }

    // Shuffle to avoid predictable first characters
    passwordChars.shuffle(random);

    return passwordChars.join();
  }

  static String _randomChar(String from) {
    final random = Random.secure();
    return from[random.nextInt(from.length)];
  }
}

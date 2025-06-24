part of 'password_generator_cubit.dart';

@freezed
abstract class PasswordGeneratorState with _$PasswordGeneratorState {
  const PasswordGeneratorState._();

  const factory PasswordGeneratorState({
    required int length,
    required bool includeUppercase,
    required bool includeLowercase,
    required bool includeNumbers,
    required bool includeSymbols,
    required String? generatedPassword,
  }) = _PasswordGeneratorState;
}

part of 'otp_code_cubit.dart';

@freezed
abstract class OtpCodeState with _$OtpCodeState {
  const OtpCodeState._();

  const factory OtpCodeState({
    @Default('') String code,
    @Default(30) int remainingSeconds,
    @Default(0.0) double progress,
  }) = _OtpCodeState;

  factory OtpCodeState.initial() => const OtpCodeState();
}

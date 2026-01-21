part of 'otp_cubit.dart';

@freezed
abstract class OtpState with _$OtpState {
  const OtpState._();

  const factory OtpState({
    required BaseState<List<OtpEntity>> otps,
  }) = _OtpState;
}

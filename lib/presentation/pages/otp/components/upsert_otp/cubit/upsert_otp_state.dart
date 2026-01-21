part of 'upsert_otp_cubit.dart';

@freezed
abstract class UpsertOtpState with _$UpsertOtpState {
  const UpsertOtpState._();

  const factory UpsertOtpState({
    required BaseState<bool> upsertOtpState,
  }) = _UpsertOtpState;
}

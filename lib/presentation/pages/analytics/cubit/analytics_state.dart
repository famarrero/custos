part of 'analytics_cubit.dart';

@freezed
abstract class AnalyticsState with _$AnalyticsState {
  const AnalyticsState._();

  const factory AnalyticsState({
    required BaseState<List<RepeatedPasswordGroupEntity>> repetitivePasswordsGroups,
    required BaseState<PasswordStrengthGroupEntity> passwordsByStrength,
    required BaseState<List<PasswordEntryEntity>> olderPasswordsEntries,
  }) = _AnalyticsState;
}

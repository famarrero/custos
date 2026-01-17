part of 'master_key_validator_cubit.dart';

@freezed
abstract class MasterKeyValidatorState with _$MasterKeyValidatorState {
  const MasterKeyValidatorState._();

  const factory MasterKeyValidatorState({
    required BaseState<String> validationState,
  }) = _MasterKeyValidatorState;
}

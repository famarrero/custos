part of 'biometric_setup_dialog_cubit.dart';

@freezed
abstract class BiometricSetupDialogState with _$BiometricSetupDialogState {
  const BiometricSetupDialogState._();

  const factory BiometricSetupDialogState({
    @Default(false) bool isChecking,
    @Default(false) bool isAvailable,
    @Default(false) bool showMasterKeyForm,
    @Default(false) bool isValidatingMasterKey,
    String? errorMessage,
    ProfileModel? updatedProfile,
  }) = _BiometricSetupDialogState;
}

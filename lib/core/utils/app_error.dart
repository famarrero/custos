/// This `enum` is use for identify all the errors that could occur across the app
enum AppError {
  // Unknown error or an error from a different error domain.
  unknown('unknown'),

  errorDerivingEncryptionKey('error_deriving_encryption_key'),

  encryptionKeyNotSet('encryption_key_not_set'),

  incorrectMasterKey('incorrect_master_key'),

  contentNotFound('content_not_found'),

  biometricAuthFailed('biometric_auth_failed');

  const AppError(this.code);

  final String code;
}

/// This `enum` is use for identify all the errors that could occur across the app
enum AppError {
  // Unknown error or an error from a different error domain.
  unknown('unknown'),

  incorrectMasterKey('incorrect_master_key'),

  masterKeyNotSet('master_key_not_set');

  const AppError(this.code);

  final String code;
}

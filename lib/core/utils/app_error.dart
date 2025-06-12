/// This `enum` is use for identify all the errors that could occur across the app
enum AppError {
  // Unknown error or an error from a different error domain.
  unknown('unknown');

  const AppError(this.code);

  final String code;
}

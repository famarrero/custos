import 'package:custos/core/utils/app_error.dart';

abstract class Failure {
  const Failure(this.code, {this.message});

  final AppError code;
  final String? message;
}

class AppFailure extends Failure {
  const AppFailure(
    super.code, {
    super.message,
  });
}
import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';

abstract class AuthRepository {
  Future<bool> hasMasterKeyBeenSet();

  Future<Either<Failure, void>> registerMasterKey(String password);

  Future<Either<Failure, void>> verifyMasterKey(String password);

  Future<void> logout();
}

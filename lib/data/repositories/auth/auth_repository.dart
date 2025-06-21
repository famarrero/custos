import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, ProfileModel>> registerProfileWhitMasterKey({
    required String profileName,
    required String masterKey,
  });

  Future<Either<Failure, void>> verifyProfileByMasterKey({
    required String profileId,
    required String masterKey,
  });

  Future<Either<Failure, void>> deleteProfileAndMasterKey({required String profileId});

  Future<Either<Failure, void>> logout();
}

import 'package:custos/core/utils/either.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, ProfileModel>> registerProfileWhitMasterKey({
    String? profileName,
    ProfileModel? importProfile,
    required String masterKey,
  });

  Future<Either<Failure, void>> verifyProfileByMasterKey({required ProfileModel profile, required String masterKey});

  Future<Either<Failure, void>> deleteProfileAndMasterKey({required ProfileModel profile});

  Future<Either<Failure, void>> logout();

  /// Habilita la autenticación biométrica para un perfil y guarda la master key protegida por biométrica
  Future<Either<Failure, ProfileModel>> enableBiometricAuth({required ProfileModel profile, required String masterKey});

  /// Deshabilita la autenticación biométrica para un perfil y elimina la master key protegida por biométrica
  Future<Either<Failure, ProfileModel>> disableBiometricAuth({required ProfileModel profile});

  /// Obtiene la master key protegida por biométrica para un perfil
  /// Retorna null si no está disponible o si la biométrica falla
  Future<Either<Failure, String?>> getMasterKeyWithBiometrics({required ProfileModel profile});
}

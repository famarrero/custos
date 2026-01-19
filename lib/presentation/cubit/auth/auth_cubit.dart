import 'package:bloc/bloc.dart';
import 'package:custos/core/services/biometric_auth_service.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/routes/routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(
        AuthState(
          loginState: BaseState.initial(),
          deleteProfile: BaseState.initial(),
          logoutState: BaseState.initial(),
        ),
      );

  final AuthRepository authRepository = di();
  final BiometricAuthService biometricAuthService = di();

  /// Intenta login con biométrica, si falla o no está configurada, retorna false
  /// La verificación biométrica se hace internamente en unlockHiveKeyWithBiometrics
  Future<bool> loginWithBiometric(GoRouter router, {required ProfileModel profile}) async {
    // Solo intentar biométrica si está habilitada
    if (!profile.hasBiometricEnabled) {
      return false;
    }

    try {
      // Verificar si hay biométrica disponible
      final isAvailable = await biometricAuthService.isFingerprintAvailable();
      if (!isAvailable) {
        return false;
      }

      // Desbloquear K_hive y abrir Hive (la verificación biométrica se hace internamente)
      final hiveKeyResult = await authRepository.unlockHiveKeyWithBiometrics(profile: profile);

      return await hiveKeyResult.fold(
        (failure) async {
          // Si hay un error al obtener K_hive (incluyendo cancelación biométrica), retornar false para usar master key manual
          return false;
        },
        (_) async {
          // Si se obtuvo K_hive y se abrió Hive correctamente, hacer login
          // Hive ya está abierto, solo necesitamos actualizar el estado y navegar
          emit(state.copyWith(loginState: BaseState.data(profile)));
          router.go(PasswordsEntriesRoute().location);
          return true;
        },
      );
    } catch (e) {
      // Cualquier otro error, usar master key como fallback
      return false;
    }
  }

  Future<void> loginWithMasterKey(GoRouter router, {required ProfileModel profile, required String masterKey}) async {
    emit(state.copyWith(loginState: BaseState.loading()));

    final response = await authRepository.verifyProfileByMasterKey(profile: profile, masterKey: masterKey);

    response.fold(
      (failure) {
        emit(state.copyWith(loginState: BaseState.error(failure)));
      },
      (login) {
        emit(state.copyWith(loginState: BaseState.data(profile)));
        router.go(PasswordsEntriesRoute().location);
      },
    );
  }

  Future<void> deleteProfile(GoRouter router) async {
    if (!state.loginState.isData) return;

    emit(state.copyWith(deleteProfile: BaseState.loading()));

    final response = await authRepository.deleteProfileAndMasterKey(profile: state.loginState.data);

    response.fold(
      (failure) {
        emit(state.copyWith(deleteProfile: BaseState.error(failure)));
      },
      (register) {
        // Clear authenticated state first so route guards/redirects won't keep the user
        // inside the authenticated shell after deletion.
        emit(
          state.copyWith(
            loginState: BaseState.initial(),
            deleteProfile: BaseState.data(true),
            logoutState: BaseState.initial(),
          ),
        );
        router.go(LoginRoute().location);
      },
    );
  }

  Future<void> logout(GoRouter router) async {
    emit(state.copyWith(logoutState: BaseState.loading()));

    final response = await authRepository.logout();

    response.fold(
      (failure) {
        emit(state.copyWith(logoutState: BaseState.error(failure)));
      },
      (register) {
        emit(state.copyWith(loginState: BaseState.initial(), logoutState: BaseState.data(true)));
        router.go(LoginRoute().location);
      },
    );
  }

  /// Actualiza el perfil en el estado (útil cuando se actualiza desde fuera del cubit)
  void updateProfile(ProfileModel updatedProfile) {
    if (state.loginState.isData && state.loginState.data.id == updatedProfile.id) {
      emit(state.copyWith(loginState: BaseState.data(updatedProfile)));
    }
  }
}

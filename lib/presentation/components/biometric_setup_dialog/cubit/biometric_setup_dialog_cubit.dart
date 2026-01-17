import 'package:bloc/bloc.dart';
import 'package:custos/core/services/biometric_auth_service.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'biometric_setup_dialog_cubit.freezed.dart';
part 'biometric_setup_dialog_state.dart';

class BiometricSetupDialogCubit extends Cubit<BiometricSetupDialogState> {
  BiometricSetupDialogCubit({required this.profile})
      : super(const BiometricSetupDialogState()) {
    _checkBiometricAvailability();
  }

  final ProfileModel profile;
  final BiometricAuthService _biometricAuthService = di();
  final AuthRepository _authRepository = di();

  /// Verifica la disponibilidad de biométrica
  Future<void> _checkBiometricAvailability() async {
    emit(state.copyWith(isChecking: true));

    try {
      final isAvailable = await _biometricAuthService.isFingerprintAvailable();
      emit(state.copyWith(
        isAvailable: isAvailable,
        isChecking: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isAvailable: false,
        isChecking: false,
      ));
    }
  }

  /// Muestra el formulario de master key
  void showMasterKeyInput() {
    emit(state.copyWith(showMasterKeyForm: true));
  }

  /// Habilita la biométrica para el perfil
  Future<void> enableBiometric(String masterKey) async {
    // Si no se ha mostrado el formulario de master key, mostrarlo
    if (!state.showMasterKeyForm) {
      showMasterKeyInput();
      return;
    }

    emit(state.copyWith(isValidatingMasterKey: true, errorMessage: null));

    try {
      // Validar la master key antes de guardarla con biométrica
      final verifyResult = await _authRepository.verifyProfileByMasterKey(
        profile: profile,
        masterKey: masterKey.trim(),
      );

      await verifyResult.fold(
        (failure) async {
          // Si la master key es incorrecta, emitir error
          emit(state.copyWith(
            isValidatingMasterKey: false,
            errorMessage: 'La clave maestra es incorrecta',
          ));
        },
        (_) async {
          // Si la master key es correcta, verificar biométrica disponible
          if (!state.isAvailable) {
            emit(state.copyWith(isValidatingMasterKey: false));
            return;
          }

          // Intentar autenticar con huella digital para configurar
          final didAuthenticate = await _biometricAuthService.authenticateWithFingerprint(
            localizedReason:
                'Autentícate con tu huella digital para habilitar el acceso rápido a ${profile.name}',
          );

          if (didAuthenticate) {
            // Si la autenticación fue exitosa, guardar master key con biométrica y habilitar en el perfil
            final result = await _authRepository.enableBiometricAuth(
              profile: profile,
              masterKey: masterKey.trim(),
            );

            result.fold(
              (failure) {
                // Si hay un error, emitir error
                emit(state.copyWith(
                  isValidatingMasterKey: false,
                  errorMessage: 'Error al habilitar biométrica: ${failure.message ?? 'Error desconocido'}',
                ));
              },
              (updatedProfile) {
                // Si se habilitó correctamente, emitir éxito
                emit(state.copyWith(
                  isValidatingMasterKey: false,
                  updatedProfile: updatedProfile,
                ));
              },
            );
          } else {
            // Si el usuario canceló la biométrica, solo resetear el estado
            emit(state.copyWith(isValidatingMasterKey: false));
          }
        },
      );
    } on LocalAuthException {
      // Si el usuario canceló o hubo un error de biométrica, resetear estado
      emit(state.copyWith(isValidatingMasterKey: false));
    } catch (e) {
      // Si hay un error, emitir error
      emit(state.copyWith(
        isValidatingMasterKey: false,
        errorMessage: 'Error al configurar biométrica: ${e.toString()}',
      ));
    }
  }

  /// Deshabilita la biométrica para el perfil
  Future<void> disableBiometric() async {
    emit(state.copyWith(isValidatingMasterKey: true, errorMessage: null));

    try {
      // Deshabilitar biométrica en el perfil
      final result = await _authRepository.disableBiometricAuth(profile: profile);

      result.fold(
        (failure) {
          // Si hay un error, emitir error
          emit(state.copyWith(
            isValidatingMasterKey: false,
            errorMessage: 'Error al deshabilitar biométrica: ${failure.message ?? 'Error desconocido'}',
          ));
        },
        (updatedProfile) {
          // Si se deshabilitó correctamente, emitir éxito
          emit(state.copyWith(
            isValidatingMasterKey: false,
            updatedProfile: updatedProfile,
          ));
        },
      );
    } catch (e) {
      // Si hay un error, emitir error
      emit(state.copyWith(
        isValidatingMasterKey: false,
        errorMessage: 'Error al deshabilitar biométrica: ${e.toString()}',
      ));
    }
  }
}

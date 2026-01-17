import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_key_validator_cubit.freezed.dart';
part 'master_key_validator_state.dart';

class MasterKeyValidatorCubit extends Cubit<MasterKeyValidatorState> {
  MasterKeyValidatorCubit({required ProfileModel profile})
    : _profile = profile,
      super(MasterKeyValidatorState(validationState: BaseState.initial()));

  final ProfileModel _profile;
  final AuthRepository _authRepository = di();

  /// Valida la master key del perfil
  Future<void> validateMasterKey(String masterKey) async {
    emit(state.copyWith(validationState: BaseState.loading()));

    try {
      final result = await _authRepository.verifyProfileByMasterKey(profile: _profile, masterKey: masterKey.trim());

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              validationState: BaseState.error(
                AppFailure(failure.code, message: failure.message ?? 'La clave maestra es incorrecta'),
              ),
            ),
          );
        },
        (_) {
          // Master key válida
          emit(state.copyWith(validationState: BaseState.data(masterKey.trim())));
        },
      );
    } catch (e) {
      emit(state.copyWith(validationState: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/auth/auth_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState(addProfile: BaseState.initial()));

  final AuthRepository authRepository = di();

  void setAcceptPrivacyPolicy(bool value) {
    emit(state.copyWith(acceptPrivacyPolicy: value));
  }

  Future<void> addProfile({required String profileName, required String masterKey}) async {
    emit(state.copyWith(addProfile: BaseState.loading()));

    final response = await authRepository.registerProfileWhitMasterKey(profileName: profileName, masterKey: masterKey);

    response.fold(
      (failure) => emit(state.copyWith(addProfile: BaseState.error(failure))),
      (profile) => emit(state.copyWith(addProfile: BaseState.data(profile))),
    );
  }
}

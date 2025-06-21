import 'package:bloc/bloc.dart';
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

  Future<void> login(
    GoRouter router, {
    required ProfileModel profile,
    required String masterKey,
  }) async {
    emit(state.copyWith(loginState: BaseState.loading()));

    final response = await authRepository.verifyProfileByMasterKey(
      profileId: profile.id,
      masterKey: masterKey,
    );

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

    final response = await authRepository.deleteProfileAndMasterKey(
      profileId: state.loginState.data.id,
    );

    response.fold(
      (failure) {
        emit(state.copyWith(deleteProfile: BaseState.error(failure)));
      },
      (register) {
        emit(state.copyWith(deleteProfile: BaseState.data(true)));
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
        emit(
          state.copyWith(
            loginState: BaseState.initial(),
            logoutState: BaseState.data(true),
          ),
        );
        router.go(LoginRoute().location);
      },
    );
  }
}

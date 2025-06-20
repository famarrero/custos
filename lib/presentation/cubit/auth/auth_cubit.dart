import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
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
          isMasterKeySet: false,
          registerState: BaseState.initial(),
          loginState: BaseState.initial(),
          logoutState: BaseState.initial(),
        ),
      );

  final AuthRepository authRepository = di();

  Future<void> stared() async {
    final hasPassword = await authRepository.hasMasterKeyBeenSet();

    if (hasPassword) {
      // Show login page.
      emit(state.copyWith(isMasterKeySet: true));
    } else {
      // Show register page.
      emit(state.copyWith(isMasterKeySet: false));
    }
  }

  Future<void> login(GoRouter router, {required String masterKey}) async {
    emit(state.copyWith(loginState: BaseState.loading()));

    final response = await authRepository.verifyMasterKey(masterKey);

    response.fold(
      (failure) {
        emit(state.copyWith(loginState: BaseState.error(failure)));
      },
      (login) {
        emit(state.copyWith(loginState: BaseState.data(true)));
        router.go(PasswordsEntriesRoute().location);
      },
    );
  }

  Future<void> register(GoRouter router, {required String masterKey}) async {
    emit(state.copyWith(registerState: BaseState.loading()));

    final response = await authRepository.registerMasterKey(masterKey);

    response.fold(
      (failure) {
        emit(state.copyWith(registerState: BaseState.error(failure)));
      },
      (register) {
        emit(
          state.copyWith(
            isMasterKeySet: true,
            registerState: BaseState.data(true),
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

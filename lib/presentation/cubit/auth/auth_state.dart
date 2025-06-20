part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required bool isMasterKeySet,
    required BaseState<bool> registerState,
    required BaseState<bool> loginState,
    required BaseState<bool> logoutState,
  }) = _AuthState;

  bool get isUserAuthenticated => loginState.dataOrNull == true;
}

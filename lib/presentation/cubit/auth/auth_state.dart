part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required bool isUserAuthenticated,
    required bool isMasterKeySet,
    required BaseState<bool> loginState,
    required BaseState<bool> registerState,
  }) = _AuthState;
}

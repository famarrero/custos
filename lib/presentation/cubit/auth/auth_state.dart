part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required BaseState<ProfileModel> loginState,
    required BaseState<bool> deleteProfile,
    required BaseState<bool> logoutState,
  }) = _AuthState;

  bool get isUserAuthenticated => loginState.dataOrNull?.id != null;
}

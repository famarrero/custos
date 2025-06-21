part of 'login_cubit.dart';

@freezed
abstract class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    required BaseState<List<ProfileModel>> profiles,
  }) = _LoginState;
}

part of 'register_cubit.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({required BaseState<ProfileModel> addProfile, @Default(false) bool acceptPrivacyPolicy}) =
      _RegisterState;
}

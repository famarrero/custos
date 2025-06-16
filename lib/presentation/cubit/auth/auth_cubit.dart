import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(AuthState(isUserAuthenticated: false, isMasterKeySet: false));

  void stared() {
    emit(state.copyWith(isUserAuthenticated: false, isMasterKeySet: false));
  }
}

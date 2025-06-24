import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/presentation/components/password_generator/cubit/password_generator_state_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'password_generator_cubit.freezed.dart';
part 'password_generator_state.dart';

class PasswordGeneratorCubit extends Cubit<PasswordGeneratorState> {
  PasswordGeneratorCubit({required this.router})
    : super(
        PasswordGeneratorState(
          length: 12,
          includeUppercase: true,
          includeLowercase: true,
          includeNumbers: true,
          includeSymbols: false,
          generatedPassword: null,
        ),
      );

  final GoRouter router;

  Future<void> updateValues({required PasswordGeneratorState state}) async {
    emit(state.copyWith(generatedPassword: state.generatePassword()));
  }

  Future<void> generatePassword() async {
    emit(state.copyWith(generatedPassword: state.generatePassword()));
    router.pop(state.generatedPassword);
  }
}

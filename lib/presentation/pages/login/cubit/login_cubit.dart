import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/repositories/profiles/profiles_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
    : super(
        LoginState(
          profiles: BaseState.initial(),
        ),
      );

  final ProfilesRepository profilesRepository = di();

  StreamSubscription<List<ProfileModel>>? _profileModelSubscription;

  Future<void> watchProfiles() async {
    emit(state.copyWith(profiles: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _profileModelSubscription?.cancel();

    _profileModelSubscription = profilesRepository.watchProfiles().listen(
      (profiles) {
        emit(
          state.copyWith(
            profiles:
                profiles.isEmpty ? BaseState.empty() : BaseState.data(profiles),
          ),
        );
      },
      onError: (e) {
        emit(
          state.copyWith(
            profiles: BaseState.error(
              AppFailure(AppError.unknown, message: e.toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _profileModelSubscription?.cancel();
    return super.close();
  }
}

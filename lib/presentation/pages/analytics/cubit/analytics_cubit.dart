import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_entity.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_cubit.freezed.dart';
part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit()
      : super(
          AnalyticsState(
            repetitivePasswordsGroups: BaseState.initial(),
            passwordsByStrength: BaseState.initial(),
          ),
        );

  final PasswordEntryRepository passwordEntryRepository = di();

  Future<void> getRepetitivePasswordsGroups() async {
    try {
      emit(state.copyWith(repetitivePasswordsGroups: BaseState.loading()));

      final response = await passwordEntryRepository.getRepetitivePasswordsGroups();

      emit(
        state.copyWith(
          repetitivePasswordsGroups: response.isEmpty
              ? BaseState.empty()
              : BaseState.data(response),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          repetitivePasswordsGroups: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> getPasswordsByStrength() async {
    try {
      emit(state.copyWith(passwordsByStrength: BaseState.loading()));

      final response = await passwordEntryRepository.getPasswordsByStrength();

      emit(
        state.copyWith(
          passwordsByStrength: BaseState.data(response),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          passwordsByStrength: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }
}

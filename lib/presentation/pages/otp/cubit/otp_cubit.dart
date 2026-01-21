import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/data/repositories/otp/otp_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_cubit.freezed.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpState(otps: BaseState.initial()));

  final OtpRepository otpRepository = di();

  StreamSubscription<List<OtpEntity>>? _otpsSubscription;

  Future<void> watchOtps() async {
    emit(state.copyWith(otps: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _otpsSubscription?.cancel();

    _otpsSubscription = otpRepository.watchOtps().listen(
      (otps) {
        emit(
          state.copyWith(
            otps: otps.isEmpty ? BaseState.empty() : BaseState.data(otps),
          ),
        );
      },
      onError: (e) {
        emit(
          state.copyWith(
            otps: BaseState.error(
              AppFailure(AppError.unknown, message: e.toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _otpsSubscription?.cancel();
    return super.close();
  }
}

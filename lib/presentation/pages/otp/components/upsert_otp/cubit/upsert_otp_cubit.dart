import 'package:bloc/bloc.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/data/repositories/otp/otp_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_otp_cubit.freezed.dart';
part 'upsert_otp_state.dart';

class UpsertOtpCubit extends Cubit<UpsertOtpState> {
  UpsertOtpCubit()
    : super(UpsertOtpState(upsertOtpState: BaseState.initial()));

  final OtpRepository otpRepository = di();

  Future<void> upsertOtp({required OtpEntity otp}) async {
    try {
      emit(state.copyWith(upsertOtpState: BaseState.loading()));

      await otpRepository.upsertOtp(otp: otp);

      emit(state.copyWith(upsertOtpState: BaseState.data(true)));
    } catch (e) {
      emit(
        state.copyWith(
          upsertOtpState: BaseState.error(
            AppFailure(AppError.unknown, message: e.toString()),
          ),
        ),
      );
    }
  }
}

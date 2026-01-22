import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/services/qr_scan_service.dart';
import 'package:custos/core/utils/app_error.dart';
import 'package:custos/core/utils/base_state/base_state.dart';
import 'package:custos/core/utils/failures.dart';
import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/data/repositories/otp/otp_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'otp_cubit.freezed.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpState(otps: BaseState.initial()));

  final OtpRepository otpRepository = di();
  final QRScanService qrScanService = di();

  StreamSubscription<List<OtpEntity>>? _otpsSubscription;

  Future<void> watchOtps() async {
    emit(state.copyWith(otps: BaseState.loading()));

    // Cancel any existing subscription before starting a new one
    await _otpsSubscription?.cancel();

    _otpsSubscription = otpRepository.watchOtps().listen(
      (otps) {
        emit(state.copyWith(otps: otps.isEmpty ? BaseState.empty() : BaseState.data(otps)));
      },
      onError: (e) {
        emit(state.copyWith(otps: BaseState.error(AppFailure(AppError.unknown, message: e.toString()))));
      },
    );
  }

  Future<void> scanQRCode() async {
    try {
      emit(state.copyWith(scanQRState: BaseState.loading()));

      final qrData = await qrScanService.scanQRCode();

      if (qrData == null || qrData.isEmpty) {
        emit(state.copyWith(scanQRState: BaseState.data(false)));
        return;
      }

      final uri = Uri.parse(qrData);

      if (uri.scheme != 'otpauth' || uri.host != 'totp') {
        emit(
          state.copyWith(scanQRState: BaseState.error(AppFailure(AppError.unknown, message: 'Invalid QR code format'))),
        );
        return;
      }

      final secret = uri.queryParameters['secret'];
      final issuer = uri.queryParameters['issuer'];

      if (secret == null || secret.isEmpty) {
        emit(
          state.copyWith(
            scanQRState: BaseState.error(AppFailure(AppError.unknown, message: 'Secret code not found in QR code')),
          ),
        );
        return;
      }

      final digitsParam = int.tryParse(uri.queryParameters['digits'] ?? '');
      final periodParam = int.tryParse(uri.queryParameters['period'] ?? '');

      final digits = (digitsParam != null && (digitsParam == 6 || digitsParam == 8)) ? digitsParam : 6;
      final period = (periodParam != null && periodParam > 0) ? periodParam : 30;

      final rawLabel = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      final decodedLabel = Uri.decodeComponent(rawLabel);

      final name = decodedLabel.contains(':') ? decodedLabel.split(':').last : decodedLabel;

      final now = DateTime.now().toUtc();

      await otpRepository.upsertOtp(
        otp: OtpEntity(
          id: const Uuid().v4(),
          name: '${issuer ?? 'Unknown'}:${name.isNotEmpty ? name : 'unknown'}'.trim(),
          secretCode: secret.normalizeSecret,
          digits: digits,
          period: period,
          createdAt: now,
          updatedAt: now,
        ),
      );

      emit(state.copyWith(scanQRState: BaseState.data(true)));
    } catch (e) {
      emit(
        state.copyWith(
          scanQRState: BaseState.error(
            AppFailure(AppError.unknown, message: 'Error scanning QR code: ${e.toString()}'),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _otpsSubscription?.cancel();
    return super.close();
  }
}

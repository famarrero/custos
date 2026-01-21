import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:custos/core/services/encryption_service.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_code_cubit.freezed.dart';
part 'otp_code_state.dart';

class OtpCodeCubit extends Cubit<OtpCodeState> {
  OtpCodeCubit({required String secret, int interval = 30, int digits = 6})
    : _secret = secret,
      _interval = interval,
      _digits = digits,
      _encryptionService = di(),
      super(OtpCodeState.initial()) {
    _startTimer();
  }

  final String _secret;
  final int _interval;
  final int _digits;
  final EncryptionService _encryptionService;
  Timer? _timer;

  void _startTimer() {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = _interval - (now % _interval);
    final code = _encryptionService.generateTOTP(_secret, interval: _interval, digits: _digits);
    final progress = remaining / _interval;

    emit(state.copyWith(code: code, remainingSeconds: remaining, progress: progress));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import 'package:custos/data/models/otp/otp_model.dart';

abstract class OtpProvider {
  Future<List<OtpModel>> getOtps();

  Stream<List<OtpModel>> watchOtps();

  Future<OtpModel?> getOtp({required String id});

  Future<OtpModel> upsertOtp({required OtpModel otp});

  Future<OtpModel> upsertOtpWithUpdatedAt({required OtpModel otp});

  Future<void> deleteOtp({required String id});
}

import 'package:custos/data/models/otp/otp_entity.dart';

abstract class OtpRepository {
  Future<List<OtpEntity>> getOtps();

  Stream<List<OtpEntity>> watchOtps();

  Future<OtpEntity?> getOtp({required String id});

  Future<OtpEntity> upsertOtp({
    required OtpEntity otp,
  });

  Future<void> deleteOtp({required String id});
}

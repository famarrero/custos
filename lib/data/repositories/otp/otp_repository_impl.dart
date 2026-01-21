import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/data/providers/otp/otp_provider.dart';
import 'package:custos/data/repositories/otp/otp_repository.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpProvider otpProvider = di();
  final VersionRepository versionRepository = di();

  @override
  Future<List<OtpEntity>> getOtps() async {
    final models = await otpProvider.getOtps();
    final entities = models.map((e) => e.toEntity()).toList();
    return entities;
  }

  @override
  Stream<List<OtpEntity>> watchOtps() {
    return otpProvider.watchOtps().map((models) {
      return models.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<OtpEntity?> getOtp({required String id}) async {
    final model = await otpProvider.getOtp(id: id);
    return model?.toEntity();
  }

  @override
  Future<OtpEntity> upsertOtp({
    required OtpEntity otp,
  }) async {
    await versionRepository.incrementVersion();
    final model = await otpProvider.upsertOtp(otp: otp.toModel());
    return model.toEntity();
  }

  @override
  Future<void> deleteOtp({required String id}) async {
    await versionRepository.incrementVersion();
    await otpProvider.deleteOtp(id: id);
  }
}

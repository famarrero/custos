import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/otp/otp_model.dart';
import 'package:custos/data/providers/otp/otp_provider.dart';
import 'package:custos/di_container.dart';

class OtpProviderImpl implements OtpProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<List<OtpModel>> getOtps() async {
    return hiveDatabase.getOtpBox.values.cast<OtpModel>().toList();
  }

  @override
  Stream<List<OtpModel>> watchOtps() async* {
    final box = hiveDatabase.getOtpBox;
    yield box.values.cast<OtpModel>().toList();

    yield* box.watch().map((_) => box.values.cast<OtpModel>().toList());
  }

  @override
  Future<OtpModel?> getOtp({required String id}) async {
    return hiveDatabase.getOtpBox.get(id);
  }

  @override
  Future<OtpModel> upsertOtp({required OtpModel otp}) async {
    await hiveDatabase.getOtpBox.put(otp.id, otp);
    return otp;
  }

  @override
  Future<void> deleteOtp({required String id}) {
    return hiveDatabase.getOtpBox.delete(id);
  }
}

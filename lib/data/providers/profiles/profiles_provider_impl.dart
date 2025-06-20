import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/profiles/profiles_provider.dart';
import 'package:custos/di_container.dart';

class ProfilesProviderImpl implements ProfilesProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<List<ProfileModel>> getProfiles() async {
    return hiveDatabase.getProfileBox.values.cast<ProfileModel>().toList();
  }

  @override
  Stream<List<ProfileModel>> watchProfiles() async* {
    final box = hiveDatabase.getProfileBox;
    yield box.values.cast<ProfileModel>().toList();

    yield* box.watch().map((_) => box.values.cast<ProfileModel>().toList());
  }

  @override
  Future<ProfileModel> getProfile({required String id}) async {
    return hiveDatabase.getProfileBox.get(id);
  }

  @override
  Future<int> upsertProfile({required ProfileModel profileModel}) async {
    return hiveDatabase.getProfileBox.add(profileModel);
  }

  @override
  Future<void> deleteProfile({required String id}) async {
    return hiveDatabase.getProfileBox.delete(id);
  }
}

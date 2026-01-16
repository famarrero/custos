import 'package:custos/data/models/profile/profile_model.dart';
import 'package:custos/data/providers/profile/profile_provider.dart';
import 'package:custos/data/repositories/profile/profile_repository.dart';
import 'package:custos/data/repositories/version/version_repository.dart';
import 'package:custos/di_container.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileProvider profilesProvider = di();
  final VersionRepository versionRepository = di();

  @override
  Future<List<ProfileModel>> getProfiles() async {
    return profilesProvider.getProfiles();
  }

  @override
  Stream<List<ProfileModel>> watchProfiles() {
    return profilesProvider.watchProfiles();
  }

  @override
  Future<ProfileModel> getProfile({required String id}) async {
    return profilesProvider.getProfile(id: id);
  }

  @override
  Future<ProfileModel> upsertProfile({
    required ProfileModel profileModel,
  }) async {
    await versionRepository.incrementVersion();
    return profilesProvider.upsertProfile(profileModel: profileModel);
  }

  @override
  Future<void> deleteProfile({required String id}) async {
    return profilesProvider.deleteProfile(id: id);
  }
}

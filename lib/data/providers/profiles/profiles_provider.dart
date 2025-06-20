import 'package:custos/data/models/profile/profile_model.dart';

abstract class ProfilesProvider {
  Future<List<ProfileModel>> getProfiles();

  Stream<List<ProfileModel>> watchProfiles();

  Future<ProfileModel> getProfile({required String id});

  Future<int> upsertProfile({required ProfileModel profileModel});

  Future<void> deleteProfile({required String id});
}

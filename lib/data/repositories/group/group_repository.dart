import 'package:custos/data/models/group/group_model.dart';

abstract class GroupRepository {
  Future<List<GroupModel>> getGroups();

  Stream<List<GroupModel>> watchGroups();

  Future<GroupModel> getGroup({required String id});

  Future<GroupModel> upsertGroup({required GroupModel group});

  Future<void> deleteGroup({required String id});
}

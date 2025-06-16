import 'package:custos/data/models/group/group_model.dart';

abstract class GroupRepository {
  Future<GroupModel> getGroup({required String id});

  Future<int> upsertGroup({required GroupModel group});

  Future<void> deleteGroup({required String id});
}

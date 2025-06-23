import 'package:custos/data/models/group/group_entity.dart';

abstract class GroupRepository {
  Future<List<GroupEntity>> getGroups();

  Stream<List<GroupEntity>> watchGroups();

  Future<GroupEntity> getGroup({required String id});

  Future<GroupEntity> upsertGroup({required GroupEntity group});

  Future<void> deleteGroup({required String id});
}

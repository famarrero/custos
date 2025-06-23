import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupProvider groupProvider = di();

  @override
  Future<List<GroupEntity>> getGroups() async {
    final models = await groupProvider.getGroups();
    final entities = await Future.wait(models.map((e) => e.toEntity()));
    return entities;
  }

  @override
  Stream<List<GroupEntity>> watchGroups() {
    return groupProvider.watchGroups().asyncMap((models) async {
      return await Future.wait(models.map((e) => e.toEntity()));
    });
  }

  @override
  Future<GroupEntity> getGroup({required String id}) async {
    return (await groupProvider.getGroup(id: id)).toEntity();
  }

  @override
  Future<GroupEntity> upsertGroup({required GroupEntity group}) async {
    return (await groupProvider.upsertGroup(group: group.toModel())).toEntity();
  }

  @override
  Future<void> deleteGroup({required String id}) async {
    return groupProvider.deleteGroup(id: id);
  }
}

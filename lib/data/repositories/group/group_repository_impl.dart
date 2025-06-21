import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupProvider groupProvider = di();

  @override
  Future<List<GroupModel>> getGroups() async {
    return await groupProvider.getGroups();
  }

  @override
  Stream<List<GroupModel>> watchGroups() {
    return groupProvider.watchGroups();
  }

  @override
  Future<GroupModel> getGroup({required String id}) async {
    return groupProvider.getGroup(id: id);
  }

  @override
  Future<GroupModel> upsertGroup({required GroupModel group}) async {
    return groupProvider.upsertGroup(group: group);
  }

  @override
  Future<void> deleteGroup({required String id}) async {
    return groupProvider.deleteGroup(id: id);
  }
}

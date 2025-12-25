import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/di_container.dart';

class GroupProviderImpl implements GroupProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<List<GroupModel>> getGroups() async {
    return hiveDatabase.getGroupBox.values.cast<GroupModel>().toList();
  }

  @override
  Stream<List<GroupModel>> watchGroups() async* {
    final box = hiveDatabase.getGroupBox;
    yield box.values.cast<GroupModel>().toList();

    yield* box.watch().map((_) => box.values.cast<GroupModel>().toList());
  }

  @override
  Future<GroupModel?> getGroup({required String id}) async {
    return hiveDatabase.getGroupBox.get(id);
  }

  @override
  Stream<GroupModel?> watchGroupById({required String id}) async* {
    final box = hiveDatabase.getGroupBox;
    yield box.get(id);
    yield* box.watch(key: id).map((_) => box.get(id));
  }

  @override
  Future<GroupModel> upsertGroup({required GroupModel group}) async {
    await hiveDatabase.getGroupBox.put(group.id, group);
    return group;
  }

  @override
  Future<void> deleteGroup({required String id}) async {
    hiveDatabase.getGroupBox.delete(id);
  }
}

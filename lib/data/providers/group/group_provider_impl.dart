import 'package:custos/core/services/hive_database_service.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/providers/group/group_provider.dart';
import 'package:custos/di_container.dart';

class GroupProviderImpl implements GroupProvider {
  final HiveDatabaseService hiveDatabase = di();

  @override
  Future<GroupModel> getGroup({required String id}) async {
    return hiveDatabase.getGroupBox.get(id);
  }

  @override
  Future<int> upsertGroup({required GroupModel group}) async {
    return hiveDatabase.getGroupBox.add(group);
  }

  @override
  Future<void> deleteGroup({required String id}) async {
    hiveDatabase.getGroupBox.delete(id);
  }
}

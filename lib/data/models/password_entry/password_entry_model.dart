import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/group/group_repository.dart';
import 'package:custos/di_container.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'password_entry_model.freezed.dart';
part 'password_entry_model.g.dart';

@freezed
@HiveType(typeId: 2)
abstract class PasswordEntryModel with _$PasswordEntryModel {
  const PasswordEntryModel._();

  const factory PasswordEntryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String? url,
    @HiveField(3) required String? username,
    @HiveField(4) required String? email,
    @HiveField(5) required String? phone,
    @HiveField(6) required String password,
    @HiveField(7) required String? note,
    @HiveField(8) required String? groupId,
  }) = _PasswordEntryModel;

  factory PasswordEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryModelFromJson(json);

  Future<PasswordEntryEntity> toEntity() async {
    // Get group by id
    GroupEntity? group =
        groupId != null
            ? await di<GroupRepository>().getGroup(id: groupId!)
            : null;

    return PasswordEntryEntity(
      id: id,
      name: name,
      url: url,
      username: username,
      email: email,
      phone: phone,
      password: password,
      note: note,
      group: group,
    );
  }
}

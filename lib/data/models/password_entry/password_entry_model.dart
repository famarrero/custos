import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'password_entry_model.freezed.dart';
part 'password_entry_model.g.dart';

@freezed
@HiveType(typeId: 2)
abstract class PasswordEntryModel with _$PasswordEntryModel {
  const PasswordEntryModel._();

  const factory PasswordEntryModel({
    @HiveField(0) required String name,
    @HiveField(1) required String? url,
    @HiveField(2) required String? username,
    @HiveField(3) required String password,
    @HiveField(4) required String? note,
    @HiveField(5) required String? groupId,
  }) = _PasswordEntryModel;

  factory PasswordEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryModelFromJson(json);

  PasswordEntryEntity toEntity() {
    return PasswordEntryEntity(
      name: name,
      url: url,
      username: username,
      password: password,
      note: note,
      // TODO: fix this
      group: GroupModel(id: '', name: '', color: ''),
    );
  }
}

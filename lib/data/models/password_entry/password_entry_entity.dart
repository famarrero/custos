import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_entry_entity.freezed.dart';
part 'password_entry_entity.g.dart';

@freezed
abstract class PasswordEntryEntity with _$PasswordEntryEntity {
  const PasswordEntryEntity._();

  const factory PasswordEntryEntity({
    required String id,
    required String name,
    required String? url,
    required String? username,
    required String password,
    required String? note,
    required GroupModel? group,
  }) = _PasswordEntryEntity;

  factory PasswordEntryEntity.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryEntityFromJson(json);

  PasswordEntryModel toModel() {
    return PasswordEntryModel(
      id: id,
      name: name,
      url: url,
      username: username,
      password: password,
      note: note,
      groupId: group?.id,
    );
  }
}

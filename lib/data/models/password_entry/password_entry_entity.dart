import 'package:custos/data/models/group/group_entity.dart';
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
    required String? email,
    required String? phone,
    required String password,
    required DateTime passwordEditedAt,
    required String? note,
    required GroupEntity? group,
    required DateTime? expirationDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PasswordEntryEntity;

  factory PasswordEntryEntity.fromJson(Map<String, dynamic> json) => _$PasswordEntryEntityFromJson(json);

  static PasswordEntryEntity empty() {
    final now = DateTime.now().toUtc();
    
    return PasswordEntryEntity(
      id: '',
      name: '',
      url: null,
      username: null,
      email: null,
      phone: null,
      password: '',
      passwordEditedAt: now,
      note: null,
      group: null,
      expirationDate: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  PasswordEntryModel toModel() {
    return PasswordEntryModel(
      id: id,
      name: name,
      url: url,
      username: username,
      email: email,
      phone: phone,
      password: password,
      passwordEditedAt: passwordEditedAt,
      note: note,
      groupId: group?.id,
      expirationDate: expirationDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

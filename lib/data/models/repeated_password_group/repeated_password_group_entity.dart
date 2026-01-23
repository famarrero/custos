import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repeated_password_group_entity.freezed.dart';
part 'repeated_password_group_entity.g.dart';

@freezed
abstract class RepeatedPasswordGroupEntity with _$RepeatedPasswordGroupEntity {
  const RepeatedPasswordGroupEntity._();

  const factory RepeatedPasswordGroupEntity({required String id, required List<PasswordEntryEntity> passwordsEntries}) =
      _RepeatedPasswordGroupEntity;

  factory RepeatedPasswordGroupEntity.fromJson(Map<String, dynamic> json) =>
      _$RepeatedPasswordGroupEntityFromJson(json);
}

import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_strength_group_entity.freezed.dart';
part 'password_strength_group_entity.g.dart';

@freezed
abstract class PasswordStrengthGroupEntity with _$PasswordStrengthGroupEntity {
  const PasswordStrengthGroupEntity._();

  const factory PasswordStrengthGroupEntity({
    required List<PasswordEntryEntity> weak,
    required List<PasswordEntryEntity> medium,
    required List<PasswordEntryEntity> strong,
  }) = _PasswordStrengthGroupEntity;

  factory PasswordStrengthGroupEntity.fromJson(Map<String, dynamic> json) =>
      _$PasswordStrengthGroupEntityFromJson(json);
}

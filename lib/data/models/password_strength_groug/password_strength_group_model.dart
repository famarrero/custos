import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/password_strength_groug/password_strength_group_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_strength_group_model.freezed.dart';
part 'password_strength_group_model.g.dart';

@freezed
abstract class PasswordStrengthGroupModel with _$PasswordStrengthGroupModel {
  const PasswordStrengthGroupModel._();

  const factory PasswordStrengthGroupModel({
    required List<PasswordEntryModel> weak,
    required List<PasswordEntryModel> medium,
    required List<PasswordEntryModel> strong,
  }) = _PasswordStrengthGroupModel;

  factory PasswordStrengthGroupModel.fromJson(Map<String, dynamic> json) => _$PasswordStrengthGroupModelFromJson(json);

  Future<PasswordStrengthGroupEntity> toEntity() async {
    final weakEntities = await Future.wait(weak.map((e) => e.toEntity()));
    final mediumEntities = await Future.wait(medium.map((e) => e.toEntity()));
    final strongEntities = await Future.wait(strong.map((e) => e.toEntity()));

    return PasswordStrengthGroupEntity(weak: weakEntities, medium: mediumEntities, strong: strongEntities);
  }
}

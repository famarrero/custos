import 'package:custos/data/models/password_entry/password_entry_model.dart';
import 'package:custos/data/models/repeated_password_group/repeated_password_group_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repeated_password_group_model.freezed.dart';
part 'repeated_password_group_model.g.dart';

@freezed
abstract class RepeatedPasswordGroupModel with _$RepeatedPasswordGroupModel {
  const RepeatedPasswordGroupModel._();

  const factory RepeatedPasswordGroupModel({required String id, required List<PasswordEntryModel> passwordsEntries}) =
      _RepeatedPasswordGroupModel;

  factory RepeatedPasswordGroupModel.fromJson(Map<String, dynamic> json) =>
      _$RepeatedPasswordGroupModelFromJson(json);

  Future<RepeatedPasswordGroupEntity> toEntity() async {
    final entities = await Future.wait(passwordsEntries.map((e) => e.toEntity()));
    return RepeatedPasswordGroupEntity(id: id, passwordsEntries: entities);
  }
}

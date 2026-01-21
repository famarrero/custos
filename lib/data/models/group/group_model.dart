import 'package:custos/data/models/group/group_entity.dart';
import 'package:custos/core/extensions/group_icon_extensions.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
@HiveType(typeId: 3)
abstract class GroupModel with _$GroupModel {
  const GroupModel._();

  const factory GroupModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required int? iconId,
    @HiveField(3) required int? colorCode,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime updatedAt,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Future<GroupEntity> toEntity() async {
    return GroupEntity(
      id: id,
      name: name,
      icon: iconId.toGroupIconData,
      color: colorCode != null ? Color(colorCode!) : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

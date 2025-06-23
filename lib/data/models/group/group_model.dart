import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/data/models/group/group_entity.dart';
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
    @HiveField(2) required String? iconCode,
    @HiveField(3) required int? colorCode,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Future<GroupEntity> toEntity() async {
    IconData? icon = iconCode?.toIconData;

    Color? color = colorCode != null ? Color(colorCode!) : null;

    return GroupEntity(id: id, name: name, icon: icon, color: color);
  }
}

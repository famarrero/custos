import 'package:custos/core/extensions/icon_data_extension.dart';
import 'package:custos/core/utils/converters/color_converter.dart';
import 'package:custos/core/utils/converters/icon_data_converter.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_entity.freezed.dart';
part 'group_entity.g.dart';

@freezed
abstract class GroupEntity with _$GroupEntity {
  const GroupEntity._();

  const factory GroupEntity({
    required String id,
    required String name,
    @IconDataConverter() required IconData? icon,
    @ColorConverter() required Color? color,
  }) = _GroupEntity;

  factory GroupEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupEntityFromJson(json);

  GroupModel toModel() {
    return GroupModel(
      id: id,
      name: name,
      iconCode:
          icon?.toJsonString,
      colorCode: color?.toARGB32(),
    );
  }
}

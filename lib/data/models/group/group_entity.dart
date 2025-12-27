import 'package:custos/core/utils/converters/color_converter.dart';
import 'package:custos/core/utils/group_icons.dart';
import 'package:custos/data/models/group/group_model.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/core/extensions/group_icon_extensions.dart';
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
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _groupIconFromJson, toJson: _groupIconToJson)
    @Default(AppIcons.groupOthers)
    IconData icon,
    @ColorConverter() required Color? color,
  }) = _GroupEntity;

  factory GroupEntity.fromJson(Map<String, dynamic> json) =>
      _$GroupEntityFromJson(json);

  GroupModel toModel() {
    return GroupModel(
      id: id,
      name: name,
      iconId: icon.toGroupIconId ?? GroupIcons.defaultId,
      colorCode: color?.toARGB32(),
    );
  }
}

IconData _groupIconFromJson(Object? json) {
  if (json is int) return GroupIcons.iconFor(json);
  return GroupIcons.iconFor(null);
}

Object? _groupIconToJson(IconData icon) =>
    icon.toGroupIconId ?? GroupIcons.defaultId;

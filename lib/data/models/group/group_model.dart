import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
@HiveType(typeId: 2)
abstract class GroupModel with _$GroupModel {
  const GroupModel._();

  const factory GroupModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String? color,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}

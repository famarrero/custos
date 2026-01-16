import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
@HiveType(typeId: 4)
abstract class VersionModel with _$VersionModel {
  const VersionModel._();

  const factory VersionModel({
    @HiveField(0) required int version,
  }) = _VersionModel;

  factory VersionModel.fromJson(Map<String, dynamic> json) =>
      _$VersionModelFromJson(json);
}

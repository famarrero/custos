import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'otp_model.freezed.dart';
part 'otp_model.g.dart';

@freezed
@HiveType(typeId: 5)
abstract class OtpModel with _$OtpModel {
  const OtpModel._();

  const factory OtpModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String secretCode,
    @HiveField(3) required DateTime createdAt,
    @HiveField(4) required DateTime updatedAt,
  }) = _OtpModel;

  factory OtpModel.fromJson(Map<String, dynamic> json) => _$OtpModelFromJson(json);

  OtpEntity toEntity() {
    return OtpEntity(id: id, name: name, secretCode: secretCode, createdAt: createdAt, updatedAt: updatedAt);
  }
}

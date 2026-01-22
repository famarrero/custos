import 'package:custos/data/models/otp/otp_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_entity.freezed.dart';
part 'otp_entity.g.dart';

@freezed
abstract class OtpEntity with _$OtpEntity {
  const OtpEntity._();

  const factory OtpEntity({
    required String id,
    required String name,
    required String secretCode,
    @Default(6) int digits,
    @Default(30) int period,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OtpEntity;

  factory OtpEntity.fromJson(Map<String, dynamic> json) => _$OtpEntityFromJson(json);

  OtpModel toModel() {
    return OtpModel(
      id: id,
      name: name,
      secretCode: secretCode,
      digits: digits,
      period: period,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

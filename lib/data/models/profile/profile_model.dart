import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String masterKeySaltSecureStorageAccessKey,
    @HiveField(3) required String masterKeyHashSecureStorageAccessKey,
    @HiveField(4) required String encryptionKeySaltSecureStorageAccessKey,
    @HiveField(5) required DateTime createdAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_entry_model.freezed.dart';
part 'password_entry_model.g.dart';

@freezed
abstract class PasswordEntryModel with _$PasswordEntryModel {
  const PasswordEntryModel._();

  const factory PasswordEntryModel({
    required String name,
    required String? url,
    required String? username,
    required String password,
    required String? note,
    required String? groupId,
  }) = _PasswordEntryModel;

  factory PasswordEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordEntryModelFromJson(json);
}

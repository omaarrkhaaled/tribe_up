import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/domain/entities/change_password_request_entity.dart';
part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  factory ChangePasswordRequest.fromEntity(ChangePasswordRequestEntity entity) {
    return ChangePasswordRequest(
      currentPassword: entity.currentPassword,
      newPassword: entity.newPassword,
      confirmNewPassword: entity.confirmNewPassword,
    );
  }
}

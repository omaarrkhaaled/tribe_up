import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/forget_password/domain/entities/forget_password_request_entity.dart';

@JsonSerializable()
class ForgetPasswordRequest {
  @JsonKey(name: 'email')
  final String email;

  const ForgetPasswordRequest({required this.email});

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordRequest(
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory ForgetPasswordRequest.fromEntity(ForgetPasswordRequestEntity entity) {
    return ForgetPasswordRequest(email: entity.email);
  }
}
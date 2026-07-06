import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_response/sign_up_response_entity.dart';
part 'sign_up_response_model.g.dart';

@JsonSerializable()
class SignUpResponseModel {
  final String? accessToken;
  final String? refreshToken;

  const SignUpResponseModel({this.accessToken, this.refreshToken});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);

  SignUpResponseEntity toEntity() {
    return SignUpResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

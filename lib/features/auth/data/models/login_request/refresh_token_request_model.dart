import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_model.g.dart';

@JsonSerializable()
class RefreshTokenRequestModel {
  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  @JsonKey(name: 'deviceId')
  final String deviceId;

  RefreshTokenRequestModel({
    required this.refreshToken,
    required this.deviceId,
  });

  factory RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestModelToJson(this);
}

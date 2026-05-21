import 'package:json_annotation/json_annotation.dart';

part 'create_invitation_request.g.dart';

@JsonSerializable()
class CreateInvitationRequest {
  final String? expiresAt;
  final int? maxUses;

  CreateInvitationRequest({this.expiresAt, this.maxUses});

  factory CreateInvitationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInvitationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateInvitationRequestToJson(this);
}

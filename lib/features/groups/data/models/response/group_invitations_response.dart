import 'package:json_annotation/json_annotation.dart';

part 'group_invitations_response.g.dart';

@JsonSerializable()
class InvitationResultDTO {
  final int? id;
  final String? token;
  final String? invitationUrl;
  final String? createdAt;
  final String? expiresAt;
  final int? maxUses;
  final int? usedCount;

  InvitationResultDTO({
    this.id,
    this.token,
    this.invitationUrl,
    this.createdAt,
    this.expiresAt,
    this.maxUses,
    this.usedCount,
  });

  factory InvitationResultDTO.fromJson(Map<String, dynamic> json) =>
      _$InvitationResultDTOFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationResultDTOToJson(this);
}

@JsonSerializable()
class InvitationDetailsDTO {
  final int? groupId;
  final String? groupName;
  final String? groupPicture;
  final int? membersCount;

  InvitationDetailsDTO({
    this.groupId,
    this.groupName,
    this.groupPicture,
    this.membersCount,
  });

  factory InvitationDetailsDTO.fromJson(Map<String, dynamic> json) =>
      _$InvitationDetailsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationDetailsDTOToJson(this);
}

@JsonSerializable()
class AcceptInvitationResponseDTO {
  final bool? success;
  final String? message;

  AcceptInvitationResponseDTO({this.success, this.message});

  factory AcceptInvitationResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AcceptInvitationResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptInvitationResponseDTOToJson(this);
}

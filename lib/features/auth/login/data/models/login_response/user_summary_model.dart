import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';

part 'user_summary_model.g.dart';

@JsonSerializable()
class UserSummaryModel {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'userName')
  final String? userName;
  @JsonKey(name: 'fullName')
  final String? fullName;
  @JsonKey(name: 'profilePicture')
  final String? profilePicture;

  UserSummaryModel({
    this.id,
    this.userName,
    this.fullName,
    this.profilePicture,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSummaryModelToJson(this);

  UserSummaryEntity toEntity() {
    return UserSummaryEntity(
      id: id,
      userName: userName,
      fullName: fullName,
      profilePicture: profilePicture,
    );
  }
}

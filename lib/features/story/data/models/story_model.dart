import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'caption')
  final String? caption;
  @JsonKey(name: 'mediaURL')
  final String? mediaURL;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'expiresAt')
  final String? expiresAt;
  @JsonKey(name: 'viewsCount')
  final int viewsCount;
  @JsonKey(name: 'creatorId')
  final String? creatorId;
  @JsonKey(name: 'creatorUserName')
  final String? creatorUserName;
  @JsonKey(name: 'groupProfilePicture')
  final String? groupProfilePicture;
  @JsonKey(name: 'isViewedByCurrentUser')
  final bool isViewedByCurrentUser;

  const StoryModel({
    required this.id,
    this.caption,
    this.mediaURL,
    required this.createdAt,
    this.expiresAt,
    required this.viewsCount,
    this.creatorId,
    this.creatorUserName,
    this.groupProfilePicture,
    required this.isViewedByCurrentUser,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      caption: caption,
      mediaURL: mediaURL,
      createdAt: createdAt,
      expiresAt: expiresAt,
      viewsCount: viewsCount,
      creatorId: creatorId,
      creatorUserName: creatorUserName,
      groupProfilePicture: groupProfilePicture,
      isViewedByCurrentUser: isViewedByCurrentUser,
    );
  }
}

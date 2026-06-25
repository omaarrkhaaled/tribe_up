import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';

part 'story_feed_item_model.g.dart';

@JsonSerializable()
class StoryFeedItemModel {
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'groupName')
  final String? groupName;
  @JsonKey(name: 'groupProfilePicture')
  final String? groupProfilePicture;
  @JsonKey(name: 'hasUnseenStories')
  final bool hasUnseenStories;
  @JsonKey(name: 'latestStoryDate')
  final String latestStoryDate;

  const StoryFeedItemModel({
    required this.groupId,
    this.groupName,
    this.groupProfilePicture,
    required this.hasUnseenStories,
    required this.latestStoryDate,
  });

  factory StoryFeedItemModel.fromJson(Map<String, dynamic> json) =>
      _$StoryFeedItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryFeedItemModelToJson(this);

  StoryFeedItemEntity toEntity() {
    return StoryFeedItemEntity(
      groupId: groupId,
      groupName: groupName,
      groupProfilePicture: groupProfilePicture,
      hasUnseenStories: hasUnseenStories,
      latestStoryDate: latestStoryDate,
    );
  }
}

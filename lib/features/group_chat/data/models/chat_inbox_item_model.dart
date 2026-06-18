import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/core/utils/date_parser.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';

part 'chat_inbox_item_model.g.dart';

@JsonSerializable()
class ChatInboxItemModel {
  @JsonKey(name: 'groupId', defaultValue: 0)
  final int groupId;
  @JsonKey(name: 'groupName')
  final String groupName;
  @JsonKey(name: 'groupProfilePicture')
  final String? groupProfilePicture;
  @JsonKey(name: 'lastMessageContent')
  final String? lastMessageContent;
  @JsonKey(name: 'lastMessageSenderName')
  final String? lastMessageSenderName;
  @JsonKey(name: 'lastMessageSentAt')
  final String? lastMessageSentAt;

  const ChatInboxItemModel({
    required this.groupId,
    required this.groupName,
    this.groupProfilePicture,
    this.lastMessageContent,
    this.lastMessageSenderName,
    this.lastMessageSentAt,
  });

  factory ChatInboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatInboxItemModelToJson(this);

  ChatInboxItemEntity toEntity() {
    return ChatInboxItemEntity(
      groupId: groupId,
      groupName: groupName,
      groupProfilePicture: groupProfilePicture,
      lastMessageContent: lastMessageContent,
      lastMessageSenderName: lastMessageSenderName,
      lastMessageSentAt: lastMessageSentAt != null
          ? DateParser.parseLocal(lastMessageSentAt!)
          : null,
    );
  }
}

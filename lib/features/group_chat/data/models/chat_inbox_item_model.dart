import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_message_model.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';

part 'chat_inbox_item_model.g.dart';

@JsonSerializable()
class ChatInboxItemModel {
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'groupName')
  final String groupName;
  @JsonKey(name: 'groupPicture')
  final String? groupPicture;
  @JsonKey(name: 'lastMessage')
  final ChatMessageModel? lastMessage;
  @JsonKey(name: 'unreadCount')
  final int unreadCount;

  const ChatInboxItemModel({
    required this.groupId,
    required this.groupName,
    this.groupPicture,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatInboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatInboxItemModelToJson(this);

  ChatInboxItemEntity toEntity() {
    return ChatInboxItemEntity(
      groupId: groupId,
      groupName: groupName,
      groupPicture: groupPicture,
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
    );
  }
}

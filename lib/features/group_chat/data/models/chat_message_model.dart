import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'groupId')
  final int groupId;
  @JsonKey(name: 'senderId')
  final String senderId;
  @JsonKey(name: 'senderName')
  final String senderName;
  @JsonKey(name: 'senderAvatar')
  final String? senderAvatar;
  @JsonKey(name: 'text')
  final String text;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'isEdited')
  final bool isEdited;

  const ChatMessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.text,
    required this.createdAt,
    this.isEdited = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      text: text,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      isEdited: isEdited,
    );
  }
}

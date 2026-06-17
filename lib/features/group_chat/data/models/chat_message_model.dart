import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/core/utils/date_parser.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(name: 'id', defaultValue: 0)
  final int id;
  @JsonKey(name: 'groupId', defaultValue: 0)
  final int groupId;
  @JsonKey(name: 'senderUserId')
  final String senderUserId;
  @JsonKey(name: 'senderName')
  final String senderName;
  @JsonKey(name: 'senderProfilePicture')
  final String? senderProfilePicture;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'sentAt')
  final String sentAt;
  @JsonKey(name: 'isEdited')
  final bool isEdited;

  const ChatMessageModel({
    required this.id,
    required this.groupId,
    required this.senderUserId,
    required this.senderName,
    this.senderProfilePicture,
    required this.content,
    required this.sentAt,
    this.isEdited = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      groupId: groupId,
      senderId: senderUserId,
      senderName: senderName,
      senderProfilePicture: senderProfilePicture,
      content: content,
      sentAt: DateParser.parseLocal(sentAt),
      isEdited: isEdited,
    );
  }
}

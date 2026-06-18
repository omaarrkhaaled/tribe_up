import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final int id;
  final int groupId;
  final String senderId;
  final String senderName;
  final String? senderProfilePicture;
  final String content;
  final DateTime sentAt;
  final bool isEdited;

  const ChatMessageEntity({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderProfilePicture,
    required this.content,
    required this.sentAt,
    this.isEdited = false,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    senderId,
    senderName,
    senderProfilePicture,
    content,
    sentAt,
    isEdited,
  ];
}

import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final int id;
  final int groupId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String text;
  final DateTime createdAt;
  final bool isEdited;

  const ChatMessageEntity({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.text,
    required this.createdAt,
    this.isEdited = false,
  });

  @override
  List<Object?> get props => [
    id,
    groupId,
    senderId,
    senderName,
    senderAvatar,
    text,
    createdAt,
    isEdited,
  ];
}

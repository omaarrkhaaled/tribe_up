import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_message_model.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_messages_response_entity.dart';

part 'chat_messages_response.g.dart';

@JsonSerializable()
class ChatMessagesResponse {
  @JsonKey(name: 'items')
  final List<ChatMessageModel> items;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'pageSize')
  final int pageSize;
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @JsonKey(name: 'hasMore')
  final bool hasMore;

  const ChatMessagesResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessagesResponseToJson(this);

  ChatMessagesResponseEntity toEntity() {
    return ChatMessagesResponseEntity(
      messages: items.map((e) => e.toEntity()).toList(),
      currentPage: page,
      totalPages: pageSize > 0 ? (totalCount / pageSize).ceil() : 0,
      totalItems: totalCount,
    );
  }
}

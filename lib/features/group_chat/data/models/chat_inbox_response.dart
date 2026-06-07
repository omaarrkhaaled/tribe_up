import 'package:json_annotation/json_annotation.dart';
import 'package:tribe_up/features/group_chat/data/models/chat_inbox_item_model.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_response_entity.dart';

part 'chat_inbox_response.g.dart';

@JsonSerializable()
class ChatInboxResponse {
  @JsonKey(name: 'items')
  final List<ChatInboxItemModel> items;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'pageSize')
  final int pageSize;
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @JsonKey(name: 'hasMore')
  final bool hasMore;

  const ChatInboxResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  factory ChatInboxResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatInboxResponseToJson(this);

  ChatInboxResponseEntity toEntity() {
    return ChatInboxResponseEntity(
      items: items.map((e) => e.toEntity()).toList(),
      currentPage: page,
      totalPages: pageSize > 0 ? (totalCount / pageSize).ceil() : 0,
      totalItems: totalCount,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:tribe_up/core/enums/chat_message_operations.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';

class GroupChatStates extends Equatable {
  final List<ChatMessageEntity> messages;
  final ChatMessageOperations? chatMessageOperation;
  final ChatMessageEntity? selectedMessage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int? currentGroupId;
  final int currentPage;
  final int? editingMessageId;

  const GroupChatStates({
    this.messages = const [],
    this.chatMessageOperation,
    this.selectedMessage,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentGroupId,
    this.currentPage = 1,
    this.editingMessageId,
  });

  GroupChatStates copyWith({
    List<ChatMessageEntity>? messages,
    ChatMessageOperations? chatMessageOperation,
    ChatMessageEntity? selectedMessage,
    bool clearOperation = false,
    bool clearSelectedMessage = false,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentGroupId,
    int? currentPage,
    int? editingMessageId,
    bool clearEditing = false,
  }) {
    return GroupChatStates(
      messages: messages ?? this.messages,
      chatMessageOperation: clearOperation
          ? null
          : chatMessageOperation ?? this.chatMessageOperation,
      selectedMessage: clearSelectedMessage
          ? null
          : selectedMessage ?? this.selectedMessage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentGroupId: currentGroupId ?? this.currentGroupId,
      currentPage: currentPage ?? this.currentPage,
      editingMessageId: clearEditing
          ? null
          : editingMessageId ?? this.editingMessageId,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        chatMessageOperation,
        selectedMessage,
        isLoading,
        isLoadingMore,
        hasMore,
        currentGroupId,
        currentPage,
        editingMessageId,
      ];
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/chat_message_operations.dart';
import 'package:tribe_up/core/services/signalr/group_chat_signalr_service.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_message_entity.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/delete_group_message_use_case.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/edit_group_message_use_case.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/get_group_messages_use_case.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/send_group_message_use_case.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_intents.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_states.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_ui_intents.dart';

@injectable
class GroupChatCubit extends Cubit<GroupChatStates> {
  final StreamController<GroupChatUiIntents> _groupChatStreamController =
      StreamController<GroupChatUiIntents>.broadcast();

  Stream<GroupChatUiIntents> get groupChatStream =>
      _groupChatStreamController.stream;

  final GetGroupMessagesUseCase getGroupMessagesUseCase;
  final SendGroupMessageUseCase sendGroupMessageUseCase;
  final DeleteGroupMessageUseCase deleteGroupMessageUseCase;
  final EditGroupMessageUseCase editGroupMessageUseCase;
  final GroupChatSignalRService signalRService;

  static const int _pageSize = 20;
  bool _isFetching = false;
  int? activeGroupId;

  // SignalR subscriptions
  StreamSubscription<ChatMessageEntity>? _newMessageSub;
  StreamSubscription<ChatMessageEntity>? _editMessageSub;
  StreamSubscription<int>? _deleteMessageSub;

  GroupChatCubit({
    required this.getGroupMessagesUseCase,
    required this.sendGroupMessageUseCase,
    required this.deleteGroupMessageUseCase,
    required this.editGroupMessageUseCase,
    required this.signalRService,
  }) : super(const GroupChatStates());

  void doIntent(GroupChatIntents intent) {
    switch (intent) {
      case GetGroupMessagesIntent(:final groupId):
        _getMessages(groupId: groupId);

      case SendGroupMessageIntent(:final groupId, :final text):
        _sendMessage(groupId: groupId, text: text);

      case DeleteGroupMessageIntent(:final messageId):
        _deleteMessage(messageId: messageId);

      case EditGroupMessageIntent(:final messageId, :final text):
        _editMessage(messageId: messageId, text: text);

      case ShowMessageOptionsIntent(:final message):
        _groupChatStreamController.add(
          ShowMessageOptionsUiIntent(message: message),
        );

      case LoadMoreGroupMessagesIntent(:final groupId):
        _loadMoreMessages(groupId: groupId);

      case StartEditMessageIntent(:final messageId):
        _startEditMessage(messageId);

      case CancelEditMessageIntent():
        _cancelEditMessage();

      case ConnectSignalRIntent(:final groupId):
        _connectSignalR(groupId: groupId);

      case DisconnectSignalRIntent():
        _disconnectSignalR();
    }
  }

  // ── SignalR connection ──────────────────────────────────────────────────────

  Future<void> _connectSignalR({required int groupId}) async {
    // Cancel any existing subscriptions first
    await _cancelSignalRSubscriptions();

    activeGroupId = groupId;
    await signalRService.connect();
    await signalRService.joinGroupChat(groupId);

    // ReceiveGroupMessage — only process messages for the active group.
    // NOTE: the server's SignalR payload may omit groupId (defaults to 0).
    // In that case we trust the message belongs to this chat since the hub
    // routes per-group. We only hard-reject when groupId is explicitly set
    // to a *different* group.
    _newMessageSub = signalRService.onReceiveGroupMessage.listen((message) {
      if (message.groupId != 0 && message.groupId != groupId) return;
      // Avoid duplicates: don't add if already present (e.g. sent by current user via REST)
      if (state.messages.any((m) => m.id == message.id)) return;
      emit(state.copyWith(messages: [message, ...state.messages]));
    });

    // ReceiveMessageEdit
    _editMessageSub = signalRService.onReceiveMessageEdit.listen((edited) {
      if (edited.groupId != 0 && edited.groupId != groupId) return;
      final updatedList = state.messages.map((m) {
        if (m.id == edited.id) {
          return ChatMessageEntity(
            id: m.id,
            groupId: m.groupId,
            senderId: edited.senderId.isNotEmpty ? edited.senderId : m.senderId,
            senderName: edited.senderName.isNotEmpty
                ? edited.senderName
                : m.senderName,
            senderProfilePicture:
                edited.senderProfilePicture ?? m.senderProfilePicture,
            content: edited.content,
            sentAt: edited.sentAt.year > 2000 ? edited.sentAt : m.sentAt,
            isEdited: edited.isEdited,
          );
        }
        return m;
      }).toList();
      emit(state.copyWith(messages: updatedList));
    });

    // ReceiveMessageDeletion
    _deleteMessageSub = signalRService.onReceiveMessageDeletion.listen((
      messageId,
    ) {
      final updatedList = state.messages
          .where((m) => m.id != messageId)
          .toList();
      emit(state.copyWith(messages: updatedList));
    });
  }

  Future<void> _disconnectSignalR() async {
    await _cancelSignalRSubscriptions();
    if (activeGroupId != null) {
      // NOTE: We do not await this so it doesn't block UI disposal,
      // though the service's own intentional disconnect will handle it smoothly.
      signalRService.leaveGroupChat(activeGroupId!);
    }
    activeGroupId = null;
    await signalRService.disconnect();
  }

  Future<void> _cancelSignalRSubscriptions() async {
    await _newMessageSub?.cancel();
    await _editMessageSub?.cancel();
    await _deleteMessageSub?.cancel();
    _newMessageSub = null;
    _editMessageSub = null;
    _deleteMessageSub = null;
  }

  // ── REST operations (unchanged) ─────────────────────────────────────────────

  Future<void> _getMessages({required int groupId}) async {
    emit(state.copyWith(isLoading: true));

    final response = await getGroupMessagesUseCase(groupId, 1, _pageSize);

    switch (response) {
      case SuccessResponse(:final data):
        final messages = data.messages.toList()
          ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
        emit(
          state.copyWith(
            isLoading: false,
            messages: messages,
            hasMore: data.messages.length >= _pageSize,
            currentPage: 1,
            currentGroupId: groupId,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false));
        _groupChatStreamController.add(
          ShowGroupChatErrorIntent(errorMessage: error.message),
        );
    }
  }

  Future<void> _loadMoreMessages({required int groupId}) async {
    if (!state.hasMore || _isFetching) return;
    _isFetching = true;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final response = await getGroupMessagesUseCase(
      groupId,
      nextPage,
      _pageSize,
    );

    switch (response) {
      case SuccessResponse(:final data):
        final newItems = data.messages;
        final allMessages = [...state.messages, ...newItems]
          ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
        emit(
          state.copyWith(
            isLoadingMore: false,
            messages: allMessages,
            currentPage: nextPage,
            hasMore: newItems.length >= _pageSize,
          ),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoadingMore: false));
        _groupChatStreamController.add(
          ShowGroupChatErrorIntent(errorMessage: error.message),
        );
    }
    _isFetching = false;
  }

  Future<void> _sendMessage({
    required int groupId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    emit(state.copyWith(chatMessageOperation: ChatMessageOperations.add));

    final response = await sendGroupMessageUseCase(groupId, text.trim());

    switch (response) {
      case SuccessResponse(:final data):
        final newMessage = data;
        if (state.messages.any((m) => m.id == newMessage.id)) {
          emit(state.copyWith(clearOperation: true));
        } else {
          emit(
            state.copyWith(
              clearOperation: true,
              messages: [newMessage, ...state.messages],
            ),
          );
        }

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _groupChatStreamController.add(
          ShowGroupChatErrorIntent(errorMessage: error.message),
        );
    }
  }

  Future<void> _deleteMessage({required int messageId}) async {
    emit(state.copyWith(chatMessageOperation: ChatMessageOperations.delete));

    final response = await deleteGroupMessageUseCase(messageId);

    switch (response) {
      case SuccessResponse():
        final updatedList = state.messages
            .where((m) => m.id != messageId)
            .toList();
        emit(
          state.copyWith(
            clearOperation: true,
            clearEditing: true,
            messages: updatedList,
          ),
        );

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _groupChatStreamController.add(
          ShowGroupChatErrorIntent(errorMessage: error.message),
        );
    }
  }

  Future<void> _editMessage({
    required int messageId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    emit(state.copyWith(chatMessageOperation: ChatMessageOperations.edit));

    final response = await editGroupMessageUseCase(messageId, text.trim());

    switch (response) {
      case SuccessResponse(:final data):
        final editedMessage = data;
        final updatedList = state.messages.map((message) {
          if (message.id == messageId) {
            return ChatMessageEntity(
              id: message.id,
              groupId: message.groupId,
              senderId: editedMessage.senderId.isNotEmpty
                  ? editedMessage.senderId
                  : message.senderId,
              senderName: editedMessage.senderName.isNotEmpty
                  ? editedMessage.senderName
                  : message.senderName,
              senderProfilePicture:
                  editedMessage.senderProfilePicture ??
                  message.senderProfilePicture,
              content: editedMessage.content,
              sentAt: editedMessage.sentAt.year > 2000
                  ? editedMessage.sentAt
                  : message.sentAt,
              isEdited: editedMessage.isEdited,
            );
          }
          return message;
        }).toList();
        emit(
          state.copyWith(
            clearEditing: true,
            clearOperation: true,
            messages: updatedList,
          ),
        );

      case ErrorResponse(:final error):
        emit(state.copyWith(clearOperation: true));
        _groupChatStreamController.add(
          ShowGroupChatErrorIntent(errorMessage: error.message),
        );
    }
  }

  void _startEditMessage(int messageId) {
    emit(state.copyWith(editingMessageId: messageId));
  }

  void _cancelEditMessage() {
    emit(state.copyWith(clearEditing: true));
  }

  @override
  Future<void> close() async {
    await _cancelSignalRSubscriptions();
    await _groupChatStreamController.close();
    return super.close();
  }
}

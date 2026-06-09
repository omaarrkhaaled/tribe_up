import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/chat_message_operations.dart';
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

  static const int _pageSize = 20;
  bool _isFetching = false;

  GroupChatCubit({
    required this.getGroupMessagesUseCase,
    required this.sendGroupMessageUseCase,
    required this.deleteGroupMessageUseCase,
    required this.editGroupMessageUseCase,
  }) : super(const GroupChatStates());

  void doIntent(GroupChatIntents intent) {
    switch (intent) {
      case GetGroupMessagesIntent(:final groupId):
        _getMessages(groupId: groupId);

      case SendGroupMessageIntent(
          :final groupId,
          :final text,
        ):
        _sendMessage(
          groupId: groupId,
          text: text,
        );

      case DeleteGroupMessageIntent(:final messageId):
        _deleteMessage(messageId: messageId);

      case EditGroupMessageIntent(
          :final messageId,
          :final text,
        ):
        _editMessage(
          messageId: messageId,
          text: text,
        );
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
    }
  }

  Future<void> _getMessages({required int groupId}) async {
    emit(state.copyWith(isLoading: true));

    final response = await getGroupMessagesUseCase(
      groupId,
      1,
      _pageSize,
    );

    switch (response) {
      case SuccessResponse(:final data):
        final messages = data.messages;
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
        emit(
          state.copyWith(
            isLoadingMore: false,
            messages: [...state.messages, ...newItems],
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

    final response = await sendGroupMessageUseCase(
      groupId,
      text.trim(),
    );

    switch (response) {
      case SuccessResponse(:final data):
        final newMessage = data;
        emit(
          state.copyWith(
            clearOperation: true,
            messages: [newMessage, ...state.messages],
          ),
        );

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

    final response = await editGroupMessageUseCase(
      messageId,
      text.trim(),
    );

    switch (response) {
      case SuccessResponse(:final data):
        final editedMessage = data;
        final updatedList = state.messages.map((message) {
          if (message.id == messageId) {
            return editedMessage;
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
  Future<void> close() {
    _groupChatStreamController.close();
    return super.close();
  }
}

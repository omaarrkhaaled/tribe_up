import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/get_chat_inbox_use_case.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_intents.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_states.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_ui_intents.dart';

@injectable
class ChatInboxCubit extends Cubit<ChatInboxStates> {
  final GetChatInboxUseCase getChatInboxUseCase;

  final StreamController<ChatInboxUiIntents> _uiController =
      StreamController<ChatInboxUiIntents>.broadcast();

  Stream<ChatInboxUiIntents> get uiIntents => _uiController.stream;

  ChatInboxCubit({required this.getChatInboxUseCase})
    : super(const ChatInboxStates());

  void doIntent(ChatInboxIntents intent) {
    switch (intent) {
      case LoadChatInboxIntent():
        _loadInbox();
      case LoadMoreChatInboxIntent():
        // The API returns all inbox items in one shot — no pagination needed.
        break;
      case SearchChatInboxIntent(:final query):
        emit(state.copyWith(searchQuery: query));
    }
  }

  Future<void> _loadInbox() async {
    emit(state.copyWith(isLoading: true));

    final response = await getChatInboxUseCase();

    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(isLoading: false, items: data.items, hasMore: false),
        );
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false));
        _uiController.add(ChatInboxErrorUiIntent(message: error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}

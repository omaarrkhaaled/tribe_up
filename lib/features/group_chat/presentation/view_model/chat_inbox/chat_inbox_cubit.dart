import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/services/signalr/group_chat_signalr_service.dart';
import 'package:tribe_up/features/group_chat/domain/entities/chat_inbox_item_entity.dart';
import 'package:tribe_up/features/group_chat/domain/use_cases/get_chat_inbox_use_case.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_intents.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_states.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/chat_inbox/chat_inbox_ui_intents.dart';

@injectable
class ChatInboxCubit extends Cubit<ChatInboxStates> {
  final GetChatInboxUseCase getChatInboxUseCase;
  final GroupChatSignalRService signalRService;

  final StreamController<ChatInboxUiIntents> _uiController =
      StreamController<ChatInboxUiIntents>.broadcast();

  Stream<ChatInboxUiIntents> get uiIntents => _uiController.stream;

  StreamSubscription<void>? _updateInboxSub;

  ChatInboxCubit({
    required this.getChatInboxUseCase,
    required this.signalRService,
  }) : super(const ChatInboxStates()) {
    _subscribeToInboxUpdates();
  }

  /// Subscribes to SignalR `UpdateInbox` events. Whenever the server pushes
  /// this event the inbox list is silently refreshed in the background.
  void _subscribeToInboxUpdates() {
    _updateInboxSub = signalRService.onUpdateInbox.listen((payload) {
      final items = List<ChatInboxItemEntity>.from(state.items);
      final index = items.indexWhere((i) => i.groupId == payload.groupId);
      if (index != -1) {
        final item = items[index];
        items[index] = item.copyWith(
          lastMessageContent: payload.lastMessage,
          lastMessageSentAt: payload.sentAt.toLocal(),
        );
        // Move updated item to the top
        final movedItem = items.removeAt(index);
        items.insert(0, movedItem);
        emit(state.copyWith(items: items));
      } else {
        // If not found, fall back to reload
        _loadInbox(silent: true);
      }
    });
  }

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

  Future<void> _loadInbox({bool silent = false}) async {
    if (!silent) emit(state.copyWith(isLoading: true));

    final response = await getChatInboxUseCase();

    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(isLoading: false, items: data.items, hasMore: false),
        );

        // Ensure SignalR is connected so we can receive UpdateInbox!
        await signalRService.connect();
        for (var item in data.items) {
          if (item.groupId != 0) {
            // Assuming groupId is valid
            await signalRService.joinGroupChat(item.groupId);
          }
        }
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoading: false));
        if (!silent) {
          _uiController.add(ChatInboxErrorUiIntent(message: error.message));
        }
    }
  }

  @override
  Future<void> close() async {
    await _updateInboxSub?.cancel();
    await _uiController.close();
    return super.close();
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/services/signalr/notification_signalr_service.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_entity.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';
import 'package:tribe_up/features/notification/domain/use_cases/get_notifications_use_case.dart';
import 'package:tribe_up/features/notification/domain/use_cases/read_all_notifications_use_case.dart';
import 'package:tribe_up/features/notification/domain/use_cases/read_notification_use_case.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_intents.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_states.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_ui_intents.dart';

@injectable
class NotificationCubit extends Cubit<NotificationStates> {
  final StreamController<NotificationUiIntents> _uiStreamController =
      StreamController<NotificationUiIntents>.broadcast();

  Stream<NotificationUiIntents> get uiIntents => _uiStreamController.stream;

  final GetNotificationsUseCase _getNotificationsUseCase;
  final ReadNotificationUseCase _readNotificationUseCase;
  final ReadAllNotificationsUseCase _readAllNotificationsUseCase;
  final NotificationSignalRService _signalRService;

  static const int _pageSize = 20;
  bool _isFetching = false;
  bool _hasReachedEnd = false;
  int _currentPage = 1;

  StreamSubscription<NotificationEntity>? _notificationSub;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._readNotificationUseCase,
    this._readAllNotificationsUseCase,
    this._signalRService,
  ) : super(
        const NotificationStates(
          data: NotificationResponseEntity(notifications: []),
          isLoading: false,
          errorMessage: null,
        ),
      ) {
    _subscribeToRealTimeNotifications();
  }

  /// Subscribes to the SignalR `notification-received` event.
  /// New notifications are prepended to the list and the unread badge increments.
  void _subscribeToRealTimeNotifications() {
    _notificationSub = _signalRService.onNotificationReceived.listen((n) {
      final current = state.data?.notifications ?? [];
      // Avoid duplicates
      if (n.id != null && current.any((existing) => existing.id == n.id)) {
        return;
      }
      final updated = [n, ...current];
      final currentUnread = state.data?.unreadCount ?? 0;
      emit(
        state.copyWith(
          data:
              state.data?.copyWith(
                notifications: updated,
                unreadCount: currentUnread + 1,
              ) ??
              NotificationResponseEntity(
                notifications: updated,
                unreadCount: 1,
              ),
        ),
      );
    });
  }

  void doIntent(NotificationIntents intent) {
    switch (intent) {
      case GetNotificationsIntent():
        _getNotifications();
      case LoadMoreNotificationsIntent():
        _loadMoreNotifications();
      case ReadNotificationIntent(:final id, :final referenceId, :final type):
        _readNotification(id, referenceId: referenceId, type: type);
      case ReadAllNotificationsIntent():
        _readAllNotifications();
    }
  }

  // Get Notifications

  Future<void> _getNotifications() async {
    _hasReachedEnd = false;
    _currentPage = 1;
    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await _getNotificationsUseCase(
      pageNumber: 1,
      pageSize: _pageSize,
    );

    switch (response) {
      case SuccessResponse():
        emit(
          state.copyWith(
            data: response.data,
            isLoading: false,
            clearError: true,
          ),
        );

      case ErrorResponse():
        emit(
          state.copyWith(
            errorMessage: response.error.message,
            isLoading: false,
          ),
        );
    }
  }

  // Pagination

  Future<void> _loadMoreNotifications() async {
    if (state.isLoadingMore ||
        state.isLoading ||
        _isFetching ||
        _hasReachedEnd) {
      return;
    }

    final currentList = state.data?.notifications ?? [];
    if (currentList.isEmpty) return;

    _isFetching = true;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    final response = await _getNotificationsUseCase(
      pageNumber: nextPage,
      pageSize: _pageSize,
    );

    switch (response) {
      case SuccessResponse():
        final incoming = response.data.notifications ?? [];
        if (incoming.isEmpty) {
          _hasReachedEnd = true;
          emit(state.copyWith(isLoadingMore: false));
          break;
        }
        _currentPage = nextPage;
        emit(
          state.copyWith(
            data: state.data!.copyWith(
              notifications: [...currentList, ...incoming],
              unreadCount: response.data.unreadCount ?? state.data?.unreadCount,
            ),
            isLoadingMore: false,
          ),
        );

      case ErrorResponse():
        emit(state.copyWith(isLoadingMore: false));
        _uiStreamController.add(
          NotificationShowErrorIntent(error: response.error.message),
        );
    }

    _isFetching = false;
  }

  // Read Single Notification — also triggers navigation to the referenced post

  Future<void> _readNotification(
    int id, {
    required int? referenceId,
    required String? type,
  }) async {
    _updateReadStatus(id, isRead: true);

    // Navigate immediately to the referenced post/comments
    if (referenceId != null) {
      final isCommentType = type?.toLowerCase().contains('comment') ?? false;
      if (isCommentType) {
        _uiStreamController.add(NavigateToCommentsIntent(postId: referenceId));
      } else {
        _uiStreamController.add(NavigateToPostIntent(postId: referenceId));
      }
    }

    final response = await _readNotificationUseCase(id: id);

    switch (response) {
      case SuccessResponse():
        final currentUnread = state.data?.unreadCount ?? 0;
        if (currentUnread > 0) {
          emit(
            state.copyWith(
              data: state.data!.copyWith(unreadCount: currentUnread - 1),
            ),
          );
        }

      case ErrorResponse():
        _updateReadStatus(id, isRead: false);
        _uiStreamController.add(
          NotificationShowErrorIntent(error: response.error.message),
        );
    }
  }

  // Read All Notifications — calls the API

  Future<void> _readAllNotifications() async {
    // Optimistically mark all as read in the UI
    final updated = (state.data?.notifications ?? [])
        .map((n) => n.copyWith(isRead: true))
        .toList();

    emit(
      state.copyWith(
        data: state.data!.copyWith(notifications: updated, unreadCount: 0),
      ),
    );

    final response = await _readAllNotificationsUseCase();

    switch (response) {
      case SuccessResponse():
        break; // Already updated UI optimistically
      case ErrorResponse():
        // Roll back on failure
        _uiStreamController.add(
          NotificationShowErrorIntent(error: response.error.message),
        );
        // Re-fetch to restore correct state
        _getNotifications();
    }
  }

  // Helpers

  void _updateReadStatus(int id, {required bool isRead}) {
    final current = state.data?.notifications;
    if (current == null) return;

    final updated = current
        .map((n) => n.id == id ? n.copyWith(isRead: isRead) : n)
        .toList();

    emit(state.copyWith(data: state.data!.copyWith(notifications: updated)));
  }

  @override
  Future<void> close() async {
    await _notificationSub?.cancel();
    await _uiStreamController.close();
    return super.close();
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';
import 'package:tribe_up/features/notification/domain/use_cases/get_notifications_use_case.dart';
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

  static const int _pageSize = 20;
  bool _isFetching = false;
  bool _hasReachedEnd = false;
  int _currentPage = 1;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._readNotificationUseCase,
  ) : super(
        const NotificationStates(
          data: NotificationResponseEntity(notifications: []),
          isLoading: false,
          errorMessage: null,
        ),
      );

  void doIntent(NotificationIntents intent) {
    switch (intent) {
      case GetNotificationsIntent():
        _getNotifications();
      case LoadMoreNotificationsIntent():
        _loadMoreNotifications();
      case ReadNotificationIntent(:final id):
        _readNotification(id);
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

  // Read Single Notification

  Future<void> _readNotification(int id) async {
    _updateReadStatus(id, isRead: true);

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

  // Read All Notifications

  void _readAllNotifications() {
    final updated = (state.data?.notifications ?? [])
        .map((n) => n.copyWith(isRead: true))
        .toList();

    emit(
      state.copyWith(
        data: state.data!.copyWith(notifications: updated, unreadCount: 0),
      ),
    );
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
  Future<void> close() {
    _uiStreamController.close();
    return super.close();
  }
}

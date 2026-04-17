import 'package:tribe_up/config/base_state/base_state.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_response_entity.dart';

class NotificationStates extends BaseState<NotificationResponseEntity> {
  final bool isLoadingMore;

  const NotificationStates({
    required super.data,
    required super.isLoading,
    required super.errorMessage,
    this.isLoadingMore = false,
  });

  NotificationStates copyWith({
    NotificationResponseEntity? data,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingMore,
  }) {
    return NotificationStates(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, errorMessage, isLoadingMore];
}

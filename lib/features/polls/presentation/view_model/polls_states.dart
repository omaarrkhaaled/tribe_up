import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/polls/data/models/poll_models.dart';

class PollsState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isActionLoading;
  final List<Poll> polls;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  const PollsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isActionLoading = false,
    this.polls = const [],
    this.hasMore = false,
    this.page = 1,
    this.errorMessage,
  });

  PollsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isActionLoading,
    List<Poll>? polls,
    bool? hasMore,
    int? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PollsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      polls: polls ?? this.polls,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isActionLoading,
    polls,
    hasMore,
    page,
    errorMessage,
  ];
}

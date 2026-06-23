import 'package:equatable/equatable.dart';
import 'package:tribe_up/features/groups/data/models/response/leaderboard_response.dart';

class LeaderboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<LeaderboardEntry> entries;

  const LeaderboardState({
    this.isLoading = false,
    this.errorMessage,
    this.entries = const [],
  });

  LeaderboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<LeaderboardEntry>? entries,
  }) {
    return LeaderboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, entries];
}

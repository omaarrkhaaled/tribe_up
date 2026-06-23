sealed class LeaderboardIntents {}

class LoadLeaderboardIntent extends LeaderboardIntents {
  final int top;
  LoadLeaderboardIntent({this.top = 20});
}

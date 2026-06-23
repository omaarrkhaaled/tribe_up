class LeaderboardEntry {
  final int? rank;
  final int? groupId;
  final String? groupName;
  final String? groupProfilePicture;
  final int? totalPoints;
  final String? badgeName;
  final String? badgeIcon;

  LeaderboardEntry({
    this.rank,
    this.groupId,
    this.groupName,
    this.groupProfilePicture,
    this.totalPoints,
    this.badgeName,
    this.badgeIcon,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        rank: json['rank'] as int?,
        groupId: json['groupId'] as int?,
        groupName: json['groupName'] as String?,
        groupProfilePicture: json['groupProfilePicture'] as String?,
        totalPoints: json['totalPoints'] as int?,
        badgeName: json['badgeName'] as String?,
        badgeIcon: json['badgeIcon'] as String?,
      );
}

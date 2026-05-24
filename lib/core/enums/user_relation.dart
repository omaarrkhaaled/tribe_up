enum UserRelation {
  none,
  follower,
  member,
  admin,
  owner;

  static UserRelation fromInt(int? value) {
    return switch (value) {
      1 => UserRelation.follower,
      2 => UserRelation.member,
      3 => UserRelation.admin,
      4 => UserRelation.owner,
      _ => UserRelation.none,
    };
  }

  bool get isMemberOrAbove => this == member || this == admin || this == owner;
  bool get isAdmin => this == admin;
  bool get isOwner => this == owner;
}

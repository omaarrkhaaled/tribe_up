sealed class ProfileIntents {}

class GetProfileDetailsIntent extends ProfileIntents {
  final String userName;
  GetProfileDetailsIntent({required this.userName});
}

class GetPersonalPostsIntent extends ProfileIntents {
  final String userName;
  GetPersonalPostsIntent({required this.userName});
}

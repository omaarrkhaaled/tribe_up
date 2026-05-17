class ApiConstants {
  static const String baseUrl = 'http://tribeup.runasp.net/api/';
  //----------------------------Authentication EndPoints------------------------//
  static const String loginEndPoint = 'Authentication/Login';
  static const String refreshEndPoint = 'Authentication/Refresh';
  static const String registerEndPoint = 'Authentication/Register';
  static const String changePassordEndPOint = 'Authentication/Change-Password';
  static const String forgetPasswordEndPoint = 'Authentication/Forgot-Password';
  static const String logoutEndPoint = 'Authentication/Logout';
  //----------------------------posts EndPoints------------------------//
  static const String feedEndPoint = 'Posts/Feed';
  static const String personalFeedEndPoint = 'Posts/PersonalFeed/{userId}';
  static const String createPostEndPoint = 'Posts/CreatePost';
  static const String editPostEndPoint = 'Posts/{postId}/EditPost';
  static const String deletePostEndPoint = 'Posts/{postId}/DeletePost';
  static const String getPostByIdEndPoint = 'Posts/{postId}/GetPostById';
  static const String postToggleLikeEndPoint = 'Posts/{postId}/PostToggleLike';
  static const String postLikesEndPoint = 'Posts/{postId}/Likes';
  static const String groupFeedEndPoint = 'Posts/{groupId}/GroupFeed';
  static const String deniedPostsByGroupIdEndPoint =
      'Posts/{groupId}/DeniedPostsByGroupId';
  static const String changeEntityContentStatusEndPoint =
      'Posts/ChangeEntityContentStatus';

  //----------------------------comments EndPoints------------------------//
  static const String commentsEndPoint = 'Comment/{postId}/Comments';
  static const String addCommentEndPoint = 'Comment/{postId}/AddComment';
  static const String deleteCommentEndPoint =
      'Comment/{commentId}/DeleteComment';
  static const String editCommentEndPoint = 'Comment/{commentId}/EditComment';
  static const String commentToggleLikeEndPoint =
      'Comment/{commentId}/CommentToggleLike';

  static const String notificationsEndPoint = 'Notification';
  static const String notificationReadEndPoint = 'Notification/{id}/read';

  //----------------------------profile EndPoints------------------------//
  static const String myProfileEndPoint = 'Profile/Me';
  static const String userProfileEndPoint = 'Profile/{userName}';
  static const String profileInfoEndPoint = 'Profile/profile-info';
  static const String nameEndPoint = 'Profile/Name';
  static const String avatarEndPoint = 'Profile/Avatar';
  static const String bioEndPoint = 'Profile/Bio';
  static const String deleteBioEndPoint = 'Profile/Bio/Delete';
  static const String phoneEndPoint = 'Profile/Phone';
  static const String deletePhoneEndPoint = 'Profile/Phone/Delete';
  static const String pictureEndPoint = 'Profile/Picture';
  static const String deletePictureEndPoint = 'Profile/Picture/Delete';
  static const String coverEndPoint = 'Profile/Cover';
  static const String deleteCoverEndPoint = 'Profile/Cover/Delete';
  // groups
  static const String groupsBaseUrl = 'http://tribeup.runasp.net/api/Groups/';
  static const String myGroupsEndPoint = 'MyGroups';
  static const String getGroupByIdEndPoint = 'GetGroup/{id}';
  static const String createGroupEndPoint = 'CreateGroup';
  static const String updateGroupEndPoint = 'UpdateGroup/{Id}';
  static const String deleteGroupEndPoint = 'DeleteGroup/{Id}';
  static const String updateGroupPictureEndPoint = 'UpdateGroupPicture/{Id}';
  static const String deleteGroupPictureEndPoint = 'DeleteGroupPicture/{Id}';
  static const String exploreGroupsEndPoint = 'ExploreGroups';
}

class CacheConstants {
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';
  static const String tokenBoxName = 'tokenBox';
  static const String userBoxName = 'userBox';
  static const String currentUserKey = 'currentUser';
  static const String deviceIdBoxName = 'deviceIdBox';
  static const String deviceIdKey = 'deviceId';
  static const String userSummaryKey = 'userSummary';
}

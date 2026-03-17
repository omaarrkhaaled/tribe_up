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
  //----------------------------comments EndPoints------------------------//
  static const String commentsEndPoint = 'Comment/{postId}/Comments';
  static const String addCommentEndPoint = 'Comment/{postId}/AddComment';
  static const String deleteCommentEndPoint =
      'Comment/{commentId}/DeleteComment';
  static const String editCommentEndPoint = 'Comment/{commentId}/EditComment';
  static const String commentToggleLikeEndPoint =
      'Comment/{commentId}/CommentToggleLike';

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
}

class CacheConstants {
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refreshToken';
  static const String tokenBoxName = 'tokenBox';
  static const String userBoxName = 'userBox';
  static const String currentUserKey = 'currentUser';
  static const String deviceIdBoxName = 'deviceIdBox';
  static const String deviceIdKey = 'deviceId';
}

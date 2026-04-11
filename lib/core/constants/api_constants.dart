class ApiConstants {
  static const String baseUrl = 'http://tribeup.runasp.net/api/';
  static const String loginEndPoint = 'Authentication/Login';
  static const String refreshEndPoint = 'Authentication/Refresh';
  static const String registerEndPoint = 'Authentication/Register';
  static const String changePassordEndPOint = 'Authentication/Change-Password';
  static const String forgetPasswordEndPoint = 'Authentication/Forgot-Password';
  static const String logoutEndPoint = 'Authentication/Logout';
  static const String feedEndPoint = 'Posts/Feed';
  static const String commentsEndPoint = 'Comment/{postId}/Comments';
  static const String addCommentEndPoint = 'Comment/{postId}/AddComment';
  static const String deleteCommentEndPoint =
      'Comment/{commentId}/DeleteComment';
  static const String editCommentEndPoint = 'Comment/{commentId}/EditComment';
  static const String commentToggleLikeEndPoint =
      'Comment/{commentId}/CommentToggleLike';

  static const String notificationsEndPoint = 'Notification';
  static const String notificationReadEndPoint = 'Notification/{id}/read';
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

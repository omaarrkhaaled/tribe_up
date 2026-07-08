class ApiConstants {
  static const String baseUrl =
      'https://tribe-up-fab6dsa5bpgqa3cy.uaenorth-01.azurewebsites.net/api/';
  static const String hubBaseUrl =
      'https://tribe-up-fab6dsa5bpgqa3cy.uaenorth-01.azurewebsites.net';
  static const String groupChatHubPath = '/hubs/group-chat';
  static const String notificationsHubPath = '/hubs/notifications';
  //----------------------------Authentication EndPoints------------------------//
  static const String loginEndPoint = 'Authentication/Login';
  static const String refreshEndPoint = 'Authentication/Refresh';
  static const String registerEndPoint = 'Authentication/Register';
  static const String changePassordEndPOint = 'Authentication/Change-Password';
  static const String forgetPasswordEndPoint = 'Authentication/Forgot-Password';
  static const String logoutEndPoint = 'Authentication/Logout';
  //----------------------------posts EndPoints------------------------//
  static const String feedEndPoint = 'Posts/Feed';
  static const String personalFeedEndPoint = 'Posts/PersonalFeed';
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

  //----------------------------Story EndPoints------------------------//
  static const String createStoryEndPoint = 'Story/CreateStory';
  static const String deleteStoryEndPoint = 'Story/DeleteStory/{storyId}';
  static const String getGroupStoriesEndPoint =
      'Story/GetGroupStories/{groupId}';
  static const String getStoryFeedEndPoint = 'Story/GetStoryFeed';
  static const String markAsViewedEndPoint = 'Story/MarkAsViewed/{storyId}';

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
  static const String notificationReadAllEndPoint = 'Notification/read/all';

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
  static const String myGroupsEndPoint = 'Groups/MyGroups';
  static const String getGroupByIdEndPoint = 'Groups/GetGroup/{id}';
  static const String createGroupEndPoint = 'Groups/CreateGroup';
  static const String updateGroupEndPoint = 'Groups/UpdateGroup/{Id}';
  static const String deleteGroupEndPoint = 'Groups/DeleteGroup/{Id}';
  static const String updateGroupPictureEndPoint =
      'Groups/UpdateGroupPicture/{Id}';
  static const String deleteGroupPictureEndPoint =
      'Groups/DeleteGroupPicture/{Id}';
  static const String exploreGroupsEndPoint = 'Groups/ExploreGroups';
  static const String followedGroupsEndPoint = 'Groups/FollowedGroups';

  // Leaderboard
  static const String leaderboardEndPoint = 'Leaderboard';

  // Group Followers
  static const String groupFollowersEndPoint = 'groups/{groupId}/GetFollowers';
  static const String groupToggleFollowEndPoint =
      'groups/{groupId}/ToggleFollow';
  static const String groupDeleteFollowerEndPoint =
      'groups/{groupId}/DeleteFollower/{followerId}';

  // Group Invitations
  static const String groupCreateInvitationsEndPoint =
      'GroupInvitations/CreateInvitations/{groupId}';
  static const String groupInvitationDetailsEndPoint =
      'GroupInvitations/Details/{token}';
  static const String groupAcceptInvitationsEndPoint =
      'GroupInvitations/AcceptInvitations/{token}';
  static const String groupGetActiveInvitationEndPoint =
      'GroupInvitations/GetActiveInvitation/{groupId}';
  static const String groupRevokeInvitationEndPoint =
      'GroupInvitations/RevokeInvitation/{invitationId}';

  // Group Members
  static const String groupMembersEndPoint =
      'GroupMembers/GroupMembers/{groupId}';
  static const String groupLeaveEndPoint = 'GroupMembers/LeaveGroup/{groupId}';
  static const String groupPromoteMemberEndPoint =
      'GroupMembers/Promote/{groupId}/User/{GroupMemberId}';
  static const String groupDemoteMemberEndPoint =
      'GroupMembers/Demote/{groupId}/User/{GroupMemberId}';
  static const String groupKickMemberEndPoint =
      'GroupMembers/Kick/{groupId}/User/{GroupMemberId}';

  // Group Chat
  static const String groupChatGetMessagesEndPoint = 'GroupChat/GetMessages';
  static const String groupChatSendMessageEndPoint =
      'GroupChat/SendMessage/{groupId}';
  static const String groupChatInboxEndPoint = 'GroupChat/ChatInbox';
  static const String groupChatEditMessageEndPoint =
      'GroupChat/{messageId}/EditMessage';
  static const String groupChatDeleteMessageEndPoint =
      'GroupChat/{messageId}/DeleteMessage';

  // Polls EndPoints
  static const String createPollEndPoint = 'Polls/{groupId}/CreatePoll';
  static const String groupPollsEndPoint = 'Polls/{groupId}/GroupPolls';
  static const String getPollByIdEndPoint = 'Polls/{pollId}/GetPollById';
  static const String updatePollEndPoint = 'Polls/{pollId}/UpdatePoll';
  static const String deletePollEndPoint = 'Polls/{pollId}/DeletePoll';
  static const String toggleVoteEndPoint =
      'Polls/{pollId}/Options/{optionId}/ToggleVote';
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
  static const String storiesBoxName = 'storiesBox';
  static const String storyFeedKey = 'storyFeed';
  static const String groupStoriesPrefix = 'groupStories_';
}

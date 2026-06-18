import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:tribe_up/core/enums/settings_tab.dart';
import 'package:tribe_up/features/groups/data/models/response/group_followers_response.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

class TribeSettingsState extends Equatable {
  final SettingsTab currentTab;

  // --- Members ---
  final List<GroupMemberResultDTO> members;
  final int membersPage;
  final bool hasMoreMembers;
  final bool isLoadingMembers;
  final bool isLoadingMoreMembers;

  // --- Followers ---
  final List<GroupFollowerResultDTO> followers;
  final int followersPage;
  final bool hasMoreFollowers;
  final bool isLoadingFollowers;
  final bool isLoadingMoreFollowers;

  // --- General ---
  final bool isSavingGeneral;
  final bool isUpdatingPicture;

  final String? coverPictureUrl;
  final bool coverPictureUrlIsSet;

  final File? localPickedFile;

  // --- Member action in progress ---
  final Set<int> pendingMemberIds;

  final String? errorMessage;

  const TribeSettingsState({
    this.currentTab = SettingsTab.general,
    this.members = const [],
    this.membersPage = 1,
    this.hasMoreMembers = true,
    this.isLoadingMembers = false,
    this.isLoadingMoreMembers = false,
    this.followers = const [],
    this.followersPage = 1,
    this.hasMoreFollowers = true,
    this.isLoadingFollowers = false,
    this.isLoadingMoreFollowers = false,
    this.isSavingGeneral = false,
    this.isUpdatingPicture = false,
    this.coverPictureUrl,
    this.coverPictureUrlIsSet = false,
    this.localPickedFile,
    this.pendingMemberIds = const {},
    this.errorMessage,
  });

  TribeSettingsState copyWith({
    SettingsTab? currentTab,
    List<GroupMemberResultDTO>? members,
    int? membersPage,
    bool? hasMoreMembers,
    bool? isLoadingMembers,
    bool? isLoadingMoreMembers,
    List<GroupFollowerResultDTO>? followers,
    int? followersPage,
    bool? hasMoreFollowers,
    bool? isLoadingFollowers,
    bool? isLoadingMoreFollowers,
    bool? isSavingGeneral,
    bool? isUpdatingPicture,
    Set<int>? pendingMemberIds,
    String? errorMessage,
    bool clearError = false,
    String? coverPictureUrl,
    bool? coverPictureUrlIsSet,
    File? localPickedFile,
    bool clearLocalPickedFile = false,
    bool clearCoverUrl = false,
  }) {
    return TribeSettingsState(
      currentTab: currentTab ?? this.currentTab,
      members: members ?? this.members,
      membersPage: membersPage ?? this.membersPage,
      hasMoreMembers: hasMoreMembers ?? this.hasMoreMembers,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isLoadingMoreMembers: isLoadingMoreMembers ?? this.isLoadingMoreMembers,
      followers: followers ?? this.followers,
      followersPage: followersPage ?? this.followersPage,
      hasMoreFollowers: hasMoreFollowers ?? this.hasMoreFollowers,
      isLoadingFollowers: isLoadingFollowers ?? this.isLoadingFollowers,
      isLoadingMoreFollowers:
          isLoadingMoreFollowers ?? this.isLoadingMoreFollowers,
      isSavingGeneral: isSavingGeneral ?? this.isSavingGeneral,
      isUpdatingPicture: isUpdatingPicture ?? this.isUpdatingPicture,
      coverPictureUrl: clearCoverUrl
          ? null
          : (coverPictureUrl ?? this.coverPictureUrl),
      coverPictureUrlIsSet: coverPictureUrlIsSet ?? this.coverPictureUrlIsSet,
      localPickedFile: clearLocalPickedFile
          ? null
          : (localPickedFile ?? this.localPickedFile),
      pendingMemberIds: pendingMemberIds ?? this.pendingMemberIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    currentTab,
    members,
    membersPage,
    hasMoreMembers,
    isLoadingMembers,
    isLoadingMoreMembers,
    followers,
    followersPage,
    hasMoreFollowers,
    isLoadingFollowers,
    isLoadingMoreFollowers,
    isSavingGeneral,
    isUpdatingPicture,
    coverPictureUrl,
    coverPictureUrlIsSet,
    localPickedFile,
    pendingMemberIds,
    errorMessage,
  ];
}

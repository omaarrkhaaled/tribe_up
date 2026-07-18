import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/settings_tab.dart';
import 'package:tribe_up/features/groups/data/models/request/update_group_request.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_followers/delete_follower_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/delete_group_picture_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/delete_group_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_members/demote_member_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_followers/get_followers_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_members/get_group_members_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_members/kick_member_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/group_members/promote_member_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/update_group_picture_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/groups/update_group_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_ui_intents.dart';

@injectable
class TribeSettingsCubit extends Cubit<TribeSettingsState> {
  final GetGroupMembersUseCase _getMembersUseCase;
  final GetFollowersUseCase _getFollowersUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final UpdateGroupPictureUseCase _updatePictureUseCase;
  final DeleteGroupPictureUseCase _deletePictureUseCase;
  final PromoteMemberUseCase _promoteMemberUseCase;
  final DemoteMemberUseCase _demoteMemberUseCase;
  final KickMemberUseCase _kickMemberUseCase;
  final DeleteFollowerUseCase _deleteFollowerUseCase;
  final DeleteGroupUseCase _deleteGroupUseCase;

  static const int _pageSize = 10;

  final StreamController<TribeSettingsUiIntents> _uiController =
      StreamController.broadcast();
  Stream<TribeSettingsUiIntents> get uiIntents => _uiController.stream;

  TribeSettingsCubit(
    this._getMembersUseCase,
    this._getFollowersUseCase,
    this._updateGroupUseCase,
    this._updatePictureUseCase,
    this._deletePictureUseCase,
    this._promoteMemberUseCase,
    this._demoteMemberUseCase,
    this._kickMemberUseCase,
    this._deleteFollowerUseCase,
    this._deleteGroupUseCase,
  ) : super(const TribeSettingsState());

  void doIntent(TribeSettingsIntents intent) {
    switch (intent) {
      case SwitchSettingsTabIntent(:final tab):
        _switchTab(tab);
      case LoadMembersIntent(:final groupId):
        _loadMembers(groupId, refresh: true);
      case LoadMoreMembersIntent(:final groupId):
        _loadMoreMembers(groupId);
      case LoadFollowersIntent(:final groupId):
        _loadFollowers(groupId, refresh: true);
      case LoadMoreFollowersIntent(:final groupId):
        _loadMoreFollowers(groupId);
      case SaveGeneralSettingsIntent(
        :final groupId,
        :final groupName,
        :final description,
        :final accessibility,
      ):
        _saveGeneral(groupId, groupName, description, accessibility);
      case UpdateTribePictureIntent(:final groupId, :final file):
        _updatePicture(groupId, file);
      case DeleteTribePictureIntent(:final groupId):
        _deletePicture(groupId);
      case PromoteMemberIntent(:final groupId, :final memberId):
        _promoteMember(groupId, memberId);
      case DemoteMemberIntent(:final groupId, :final memberId):
        _demoteMember(groupId, memberId);
      case KickMemberIntent(:final groupId, :final memberId):
        _kickMember(groupId, memberId);
      case DeleteFollowerIntent(:final groupId, :final followerId):
        _deleteFollower(groupId, followerId);
      case DeleteTribeIntent(:final groupId):
        _deleteTribe(groupId);
    }
  }

  void _switchTab(SettingsTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  Future<void> _loadMembers(int groupId, {bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(isLoadingMembers: true, members: [], membersPage: 1));
    }
    final response = await _getMembersUseCase(groupId, 1, _pageSize, null);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            members: data.items ?? [],
            membersPage: 1,
            hasMoreMembers: data.hasMore ?? false,
            isLoadingMembers: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isLoadingMembers: false, errorMessage: error.message),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadMoreMembers(int groupId) async {
    if (state.isLoadingMoreMembers || !state.hasMoreMembers) return;
    emit(state.copyWith(isLoadingMoreMembers: true));
    final nextPage = state.membersPage + 1;
    final response = await _getMembersUseCase(
      groupId,
      nextPage,
      _pageSize,
      null,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            members: [...state.members, ...(data.items ?? [])],
            membersPage: nextPage,
            hasMoreMembers: data.hasMore ?? false,
            isLoadingMoreMembers: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingMoreMembers: false,
            errorMessage: error.message,
          ),
        );
    }
  }

  Future<void> _loadFollowers(int groupId, {bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          isLoadingFollowers: true,
          followers: [],
          followersPage: 1,
        ),
      );
    }
    final response = await _getFollowersUseCase(groupId, 1, _pageSize, null);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            followers: data.items ?? [],
            followersPage: 1,
            hasMoreFollowers: data.hasMore ?? false,
            isLoadingFollowers: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingFollowers: false,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadMoreFollowers(int groupId) async {
    if (state.isLoadingMoreFollowers || !state.hasMoreFollowers) return;
    emit(state.copyWith(isLoadingMoreFollowers: true));
    final nextPage = state.followersPage + 1;
    final response = await _getFollowersUseCase(
      groupId,
      nextPage,
      _pageSize,
      null,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            followers: [...state.followers, ...(data.items ?? [])],
            followersPage: nextPage,
            hasMoreFollowers: data.hasMore ?? false,
            isLoadingMoreFollowers: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingMoreFollowers: false,
            errorMessage: error.message,
          ),
        );
    }
  }

  Future<void> _saveGeneral(
    int groupId,
    String name,
    String description,
    int accessibility,
  ) async {
    emit(state.copyWith(isSavingGeneral: true, clearError: true));
    final request = UpdateGroupRequest(
      groupName: name,
      description: description,
      accessibility: accessibility,
    );
    final response = await _updateGroupUseCase(id: groupId, request: request);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isSavingGeneral: false));
        _uiController.add(const ShowSuccessUiIntent('Settings saved!'));
        _uiController.add(const SettingsSavedUiIntent());
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isSavingGeneral: false, errorMessage: error.message),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _updatePicture(int groupId, File file) async {
    emit(
      state.copyWith(
        isUpdatingPicture: true,
        localPickedFile: file,
        coverPictureUrlIsSet: true,
      ),
    );
    final response = await _updatePictureUseCase(id: groupId, file: file);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isUpdatingPicture: false));
        _uiController.add(const ShowSuccessUiIntent('Picture updated!'));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isUpdatingPicture: false,
            clearLocalPickedFile: true,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _deletePicture(int groupId) async {
    emit(
      state.copyWith(
        isUpdatingPicture: true,
        clearCoverUrl: true,
        clearLocalPickedFile: true,
        coverPictureUrlIsSet: true,
      ),
    );
    _uiController.add(const ShowSuccessUiIntent(UiConstants.pictureRemoved));

    final response = await _deletePictureUseCase(groupId);
    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(isUpdatingPicture: false));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isUpdatingPicture: false, errorMessage: error.message),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _promoteMember(int groupId, int memberId) async {
    final previousMembers = state.members;
    final updatedMembers = state.members.map((m) {
      if (m.id == memberId) {
        return GroupMemberResultDTO(
          id: m.id,
          userId: m.userId,
          userName: m.userName,
          userProfilePicture: m.userProfilePicture,
          role: 'Admin',
          joinedAt: m.joinedAt,
        );
      }
      return m;
    }).toList();

    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds, memberId},
        members: updatedMembers,
      ),
    );

    final response = await _promoteMemberUseCase(groupId, memberId);
    final updatedPending = {...state.pendingMemberIds}..remove(memberId);

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(pendingMemberIds: updatedPending));
        _uiController.add(
          const ShowSuccessUiIntent(UiConstants.memberPromoted),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            members: previousMembers,
            pendingMemberIds: updatedPending,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _demoteMember(int groupId, int memberId) async {
    final previousMembers = state.members;
    final updatedMembers = state.members.map((m) {
      if (m.id == memberId) {
        return GroupMemberResultDTO(
          id: m.id,
          userId: m.userId,
          userName: m.userName,
          userProfilePicture: m.userProfilePicture,
          role: 'Member',
          joinedAt: m.joinedAt,
        );
      }
      return m;
    }).toList();

    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds, memberId},
        members: updatedMembers,
      ),
    );

    final response = await _demoteMemberUseCase(groupId, memberId);
    final updatedPending = {...state.pendingMemberIds}..remove(memberId);

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(pendingMemberIds: updatedPending));
        _uiController.add(const ShowSuccessUiIntent(UiConstants.adminDemoted));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            members: previousMembers,
            pendingMemberIds: updatedPending,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _kickMember(int groupId, int memberId) async {
    final previousMembers = state.members;
    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds, memberId},
        members: state.members.where((m) => m.id != memberId).toList(),
      ),
    );

    final response = await _kickMemberUseCase(groupId, memberId);
    final updatedPending = {...state.pendingMemberIds}..remove(memberId);

    switch (response) {
      case SuccessResponse():
        emit(state.copyWith(pendingMemberIds: updatedPending));
        _uiController.add(const ShowSuccessUiIntent(UiConstants.memberRemoved));
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            members: previousMembers,
            pendingMemberIds: updatedPending,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _deleteFollower(int groupId, String followerId) async {
    final previousFollowers = state.followers;
    emit(
      state.copyWith(
        followers: state.followers
            .where((f) => f.userId != followerId)
            .toList(),
      ),
    );

    final response = await _deleteFollowerUseCase(groupId, followerId);
    switch (response) {
      case SuccessResponse():
        _uiController.add(
          const ShowSuccessUiIntent(UiConstants.followerRemoved),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            followers: previousFollowers,
            errorMessage: error.message,
          ),
        );
        _uiController.add(ShowErrorUiIntent(error.message));
    }
  }

  // ---------------------------------------------------------------------------
  // Delete tribe
  // ---------------------------------------------------------------------------

  Future<void> _deleteTribe(int groupId) async {
    if (!isClosed) emit(state.copyWith(isSavingGeneral: true));
    final response = await _deleteGroupUseCase(groupId);

    if (isClosed) {
      return; // Prevent "Cannot emit new states after calling close"
    }

    if (response is SuccessResponse) {
      emit(state.copyWith(isSavingGeneral: false));
      _uiController.add(const TribeDeletedUiIntent());
    } else if (response is ErrorResponse) {
      // If delete fails, inform user and optionally refresh list
      emit(
        state.copyWith(
          isSavingGeneral: false,
          errorMessage: response.error.message,
        ),
      );
      _uiController.add(ShowErrorUiIntent(response.error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}

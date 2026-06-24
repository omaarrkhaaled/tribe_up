import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/explore_groups_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/followed_groups_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/leave_group_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/my_groups_use_case.dart';
import 'package:tribe_up/features/groups/domain/use_cases/toggle_follow_use_case.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_ui_intents.dart';

@injectable
class TribesListCubit extends Cubit<TribesState> {
  final MyGroupsUseCase _myGroupsUseCase;
  final ExploreGroupsUseCase _exploreGroupsUseCase;
  final LeaveGroupUseCase _leaveGroupUseCase;
  final ToggleFollowUseCase _toggleFollowUseCase;
  final FollowedGroupsUseCase _followedGroupsUseCase;

  static const int _pageSize = 10;

  final StreamController<TribesUiIntents> _uiIntentController =
      StreamController.broadcast();
  Stream<TribesUiIntents> get uiIntents => _uiIntentController.stream;

  TribesListCubit(
    this._myGroupsUseCase,
    this._exploreGroupsUseCase,
    this._leaveGroupUseCase,
    this._toggleFollowUseCase,
    this._followedGroupsUseCase,
  ) : super(const TribesState());

  void doIntent(TribesIntents intent) {
    switch (intent) {
      case LoadJoinedTribesIntent():
        _loadJoined(refresh: true);
      case LoadDiscoverTribesIntent():
        _loadDiscover(refresh: true);
      case LoadFollowingTribesIntent():
        _loadFollowing(refresh: true);
      case SwitchTribesTabIntent(:final tab):
        _switchTab(tab);
      case SearchTribesIntent(:final query):
        _search(query);
      case LoadMoreTribesIntent():
        _loadMore();
      case ToggleFollowTribeIntent(:final groupId):
        _toggleFollow(groupId);
      case LeaveTribeIntent(:final groupId):
        _leaveGroup(groupId);
      case ViewTribeIntent(:final group):
        _uiIntentController.add(NavigateToTribeProfileUiIntent(group));
      case OpenCreateTribeIntent():
        _uiIntentController.add(const ShowCreateTribeSheetUiIntent());
    }
  }

  Future<void> _loadJoined({bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(isLoadingJoined: true, clearError: true));
    }
    final response = await _myGroupsUseCase(1, _pageSize);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            joinedTribes: data.items ?? [],
            joinedPage: 1,
            hasMoreJoined: data.hasMore ?? false,
            isLoadingJoined: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isLoadingJoined: false, errorMessage: error.message),
        );
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadDiscover({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          isLoadingDiscover: true,
          discoverPage: 1,
          clearError: true,
        ),
      );
    }
    final response = await _exploreGroupsUseCase(
      1,
      _pageSize,
      state.searchQuery.isEmpty ? null : state.searchQuery,
    );
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            discoverTribes: data.items ?? [],
            discoverPage: 1,
            hasMoreDiscover: data.hasMore ?? false,
            isLoadingDiscover: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(isLoadingDiscover: false, errorMessage: error.message),
        );
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _loadFollowing({bool refresh = false}) async {
    if (refresh) {
      emit(
        state.copyWith(
          isLoadingFollowing: true,
          followingPage: 1,
          clearError: true,
        ),
      );
    }
    final response = await _followedGroupsUseCase(1, _pageSize);
    switch (response) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            followingTribes: data.items ?? [],
            followingPage: 1,
            hasMoreFollowing: data.hasMore ?? false,
            isLoadingFollowing: false,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingFollowing: false,
            errorMessage: error.message,
          ),
        );
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  void _switchTab(TribesTab tab) {
    emit(state.copyWith(currentTab: tab));
    if (tab == TribesTab.joined && state.joinedTribes.isEmpty) {
      _loadJoined(refresh: true);
    } else if (tab == TribesTab.discover && state.discoverTribes.isEmpty) {
      _loadDiscover(refresh: true);
    } else if (tab == TribesTab.following && state.followingTribes.isEmpty) {
      _loadFollowing(refresh: true);
    }
  }

  Future<void> _search(String query) async {
    emit(
      state.copyWith(searchQuery: query, discoverTribes: [], discoverPage: 1),
    );
    _loadDiscover(refresh: true);
  }

  Future<void> _loadMore() async {
    if (state.isLoadingMore) return;

    if (state.currentTab == TribesTab.joined) {
      if (!state.hasMoreJoined) return;
      emit(state.copyWith(isLoadingMore: true));
      final nextPage = state.joinedPage + 1;
      final response = await _myGroupsUseCase(nextPage, _pageSize);
      switch (response) {
        case SuccessResponse(:final data):
          emit(
            state.copyWith(
              joinedTribes: [...state.joinedTribes, ...(data.items ?? [])],
              joinedPage: nextPage,
              hasMoreJoined: data.hasMore ?? false,
              isLoadingMore: false,
            ),
          );
        case ErrorResponse(:final error):
          emit(
            state.copyWith(isLoadingMore: false, errorMessage: error.message),
          );
      }
    } else if (state.currentTab == TribesTab.following) {
      if (!state.hasMoreFollowing) return;
      emit(state.copyWith(isLoadingMore: true));
      final nextPage = state.followingPage + 1;
      final response = await _followedGroupsUseCase(nextPage, _pageSize);
      switch (response) {
        case SuccessResponse(:final data):
          emit(
            state.copyWith(
              followingTribes: [
                ...state.followingTribes,
                ...(data.items ?? []),
              ],
              followingPage: nextPage,
              hasMoreFollowing: data.hasMore ?? false,
              isLoadingMore: false,
            ),
          );
        case ErrorResponse(:final error):
          emit(
            state.copyWith(isLoadingMore: false, errorMessage: error.message),
          );
      }
    } else {
      if (!state.hasMoreDiscover) return;
      emit(state.copyWith(isLoadingMore: true));
      final nextPage = state.discoverPage + 1;
      final response = await _exploreGroupsUseCase(
        nextPage,
        _pageSize,
        state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      switch (response) {
        case SuccessResponse(:final data):
          emit(
            state.copyWith(
              discoverTribes: [...state.discoverTribes, ...(data.items ?? [])],
              discoverPage: nextPage,
              hasMoreDiscover: data.hasMore ?? false,
              isLoadingMore: false,
            ),
          );
        case ErrorResponse(:final error):
          emit(
            state.copyWith(isLoadingMore: false, errorMessage: error.message),
          );
      }
    }
  }

  Future<void> _leaveGroup(int groupId) async {
    final previousList = [...state.joinedTribes];
    emit(
      state.copyWith(
        joinedTribes: state.joinedTribes.where((g) => g.id != groupId).toList(),
        pendingActionIds: {...state.pendingActionIds, groupId},
      ),
    );

    final response = await _leaveGroupUseCase(groupId);
    switch (response) {
      case SuccessResponse():
        emit(
          state.copyWith(
            pendingActionIds: {...state.pendingActionIds}..remove(groupId),
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            joinedTribes: previousList,
            pendingActionIds: {...state.pendingActionIds}..remove(groupId),
            errorMessage: error.message,
          ),
        );
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  Future<void> _toggleFollow(int groupId) async {
    final pending = {...state.pendingActionIds, groupId};
    emit(state.copyWith(pendingActionIds: pending));

    final response = await _toggleFollowUseCase(groupId);
    final updated = {...state.pendingActionIds}..remove(groupId);

    switch (response) {
      case SuccessResponse(:final data):
        final isNowFollowing = data.currentRelation == 1; // follower relation
        Group? targetGroup;

        final updatedDiscover = state.discoverTribes.map((g) {
          if (g.id == groupId) {
            final updatedGroup = Group(
              id: g.id,
              groupName: g.groupName,
              description: g.description,
              groupProfilePicture: g.groupProfilePicture,
              createdAt: g.createdAt,
              accessibility: g.accessibility,
              userRelation: data.currentRelation,
              membersCount: g.membersCount,
            );
            targetGroup ??= updatedGroup;
            return updatedGroup;
          }
          return g;
        }).toList();

        List<Group> updatedFollowing = List.from(state.followingTribes);

        if (targetGroup == null) {
          final idx = updatedFollowing.indexWhere((g) => g.id == groupId);
          if (idx != -1) {
            final g = updatedFollowing[idx];
            targetGroup = Group(
              id: g.id,
              groupName: g.groupName,
              description: g.description,
              groupProfilePicture: g.groupProfilePicture,
              createdAt: g.createdAt,
              accessibility: g.accessibility,
              userRelation: data.currentRelation,
              membersCount: g.membersCount,
            );
          }
        }

        if (isNowFollowing) {
          if (targetGroup != null &&
              !updatedFollowing.any((g) => g.id == groupId)) {
            updatedFollowing.insert(0, targetGroup!);
          }
        } else {
          updatedFollowing.removeWhere((g) => g.id == groupId);
        }

        emit(
          state.copyWith(
            discoverTribes: updatedDiscover,
            followingTribes: updatedFollowing,
            pendingActionIds: updated,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            pendingActionIds: updated,
            errorMessage: error.message,
          ),
        );
        _uiIntentController.add(ShowErrorUiIntent(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiIntentController.close();
    return super.close();
  }
}

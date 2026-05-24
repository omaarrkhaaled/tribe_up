import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/use_cases/explore_groups_use_case.dart';
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

  static const int _pageSize = 10;

  final StreamController<TribesUiIntents> _uiIntentController =
      StreamController.broadcast();
  Stream<TribesUiIntents> get uiIntents => _uiIntentController.stream;

  TribesListCubit(
    this._myGroupsUseCase,
    this._exploreGroupsUseCase,
    this._leaveGroupUseCase,
    this._toggleFollowUseCase,
  ) : super(const TribesState());

  void doIntent(TribesIntents intent) {
    switch (intent) {
      case LoadJoinedTribesIntent():
        _loadJoined(refresh: true);
      case LoadDiscoverTribesIntent():
        _loadDiscover(refresh: true);
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

  void _switchTab(TribesTab tab) {
    emit(state.copyWith(currentTab: tab));
    if (tab == TribesTab.joined && state.joinedTribes.isEmpty) {
      _loadJoined(refresh: true);
    } else if (tab == TribesTab.discover && state.discoverTribes.isEmpty) {
      _loadDiscover(refresh: true);
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
        final updatedList = state.discoverTribes.map((g) {
          if (g.id == groupId) {
            return Group(
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
          return g;
        }).toList();
        emit(
          state.copyWith(
            discoverTribes: updatedList,
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

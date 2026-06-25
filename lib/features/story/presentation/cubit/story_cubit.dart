import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/story/domain/use_cases/get_story_feed_use_case.dart';
import 'package:tribe_up/features/story/domain/use_cases/get_group_stories_use_case.dart';
import 'package:tribe_up/features/story/domain/use_cases/mark_as_viewed_use_case.dart';
import 'package:tribe_up/features/story/domain/use_cases/delete_story_use_case.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_states.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';

@injectable
class StoryCubit extends Cubit<StoryState> {
  final GetStoryFeedUseCase _getStoryFeedUseCase;
  final GetGroupStoriesUseCase _getGroupStoriesUseCase;
  final MarkAsViewedUseCase _markAsViewedUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;

  StoryCubit(
    this._getStoryFeedUseCase,
    this._getGroupStoriesUseCase,
    this._markAsViewedUseCase,
    this._deleteStoryUseCase,
  ) : super(const StoryState());

  Future<void> loadStoryFeed() async {
    emit(state.copyWith(isLoadingFeed: true, clearError: true));
    final response = await _getStoryFeedUseCase(pageNumber: 1, pageSize: 50);
    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(isLoadingFeed: false, storyFeedItems: data));
      case ErrorResponse(:final error):
        emit(state.copyWith(isLoadingFeed: false, errorMessage: error.message));
    }
  }

  Future<void> loadGroupStories(int groupId) async {
    final Map<int, bool> nextLoading = Map.from(state.isLoadingGroupStories)
      ..[groupId] = true;
    emit(state.copyWith(isLoadingGroupStories: nextLoading, clearError: true));

    final response = await _getGroupStoriesUseCase(groupId: groupId);
    final Map<int, bool> doneLoading = Map.from(state.isLoadingGroupStories)
      ..remove(groupId);

    switch (response) {
      case SuccessResponse(:final data):
        final Map<int, List<StoryEntity>> updatedGroupStories = Map.from(
          state.groupStories,
        )..[groupId] = data;
        emit(
          state.copyWith(
            isLoadingGroupStories: doneLoading,
            groupStories: updatedGroupStories,
          ),
        );
      case ErrorResponse(:final error):
        emit(
          state.copyWith(
            isLoadingGroupStories: doneLoading,
            errorMessage: error.message,
          ),
        );
    }
  }

  Future<void> markStoryAsViewed(int groupId, int storyId) async {
    final stories = state.groupStories[groupId];
    if (stories == null) return;

    final updatedStories = stories.map((s) {
      if (s.id != storyId) return s;
      return StoryEntity(
        id: s.id,
        caption: s.caption,
        mediaURL: s.mediaURL,
        createdAt: s.createdAt,
        expiresAt: s.expiresAt,
        viewsCount: s.viewsCount,
        creatorId: s.creatorId,
        creatorUserName: s.creatorUserName,
        groupProfilePicture: s.groupProfilePicture,
        isViewedByCurrentUser: true,
      );
    }).toList();

    final Map<int, List<StoryEntity>> updatedGroupStories = Map.from(
      state.groupStories,
    )..[groupId] = updatedStories;

    final hasUnseenCached = updatedStories.any((s) => !s.isViewedByCurrentUser);

    final updatedFeedItems = state.storyFeedItems.map((item) {
      if (item.groupId != groupId) return item;
      return StoryFeedItemEntity(
        groupId: item.groupId,
        groupName: item.groupName,
        groupProfilePicture: item.groupProfilePicture,
        hasUnseenStories: hasUnseenCached,
        latestStoryDate: item.latestStoryDate,
      );
    }).toList();

    emit(
      state.copyWith(
        groupStories: updatedGroupStories,
        storyFeedItems: updatedFeedItems,
      ),
    );

    await _markAsViewedUseCase(storyId: storyId);
  }

  Future<bool> deleteStory(int groupId, int storyId) async {
    emit(state.copyWith(clearError: true));
    final response = await _deleteStoryUseCase(storyId: storyId);
    switch (response) {
      case SuccessResponse():
        final stories = state.groupStories[groupId];
        if (stories != null) {
          final updatedStories = stories.where((s) => s.id != storyId).toList();
          final Map<int, List<StoryEntity>> updatedGroupStories = Map.from(
            state.groupStories,
          )..[groupId] = updatedStories;

          List<StoryFeedItemEntity> updatedFeedItems = state.storyFeedItems;
          if (updatedStories.isEmpty) {
            updatedFeedItems = state.storyFeedItems
                .where((item) => item.groupId != groupId)
                .toList();
          } else {
            final hasUnseen = updatedStories.any(
              (s) => !s.isViewedByCurrentUser,
            );
            updatedFeedItems = state.storyFeedItems.map((item) {
              if (item.groupId != groupId) return item;
              return StoryFeedItemEntity(
                groupId: item.groupId,
                groupName: item.groupName,
                groupProfilePicture: item.groupProfilePicture,
                hasUnseenStories: hasUnseen,
                latestStoryDate: item.latestStoryDate,
              );
            }).toList();
          }

          emit(
            state.copyWith(
              groupStories: updatedGroupStories,
              storyFeedItems: updatedFeedItems,
            ),
          );
        }
        return true;
      case ErrorResponse(:final error):
        emit(state.copyWith(errorMessage: error.message));
        return false;
    }
  }
}

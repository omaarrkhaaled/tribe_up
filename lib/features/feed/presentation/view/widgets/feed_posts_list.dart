import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/feed_create_post_trigger.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/post_card.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_cubit.dart';
import 'package:tribe_up/features/story/presentation/widgets/stories_bar.dart';

class FeedPostsList extends StatelessWidget {
  final FeedStates state;
  final String? currentUserProfilePicture;
  final ScrollController scrollController;

  const FeedPostsList({
    super.key,
    required this.state,
    required this.scrollController,
    this.currentUserProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (!state.isLoading && state.errorMessage != null) {
      return Center(
        child: Text(
          'Error: ${state.errorMessage}',
          style: textTheme.bodyMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FeedCubit>().doIntent(const RefreshFeedIntent());
        // Wait briefly for the UI to update to loading state
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Skeletonizer(
        enabled: state.isLoading,
        effect: const PulseEffect(),
        child: ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),
          // +2 for the StoriesBar and the create-post trigger at top
          itemCount: (state.isLoading ? 5 : state.posts.length) + 2,
          itemBuilder: (context, index) {
            // First item is always the StoriesBar
            if (index == 0) {
              return BlocProvider<StoryCubit>(
                create: (_) => getIt<StoryCubit>(),
                child: StoriesBar(
                  currentUserProfilePicture: currentUserProfilePicture,
                  joinedGroups: state.joinedGroups,
                ),
              );
            }
            // Second item is always the create-post trigger
            if (index == 1) {
              return FeedCreatePostTrigger(
                state: state,
                userProfilePicture: currentUserProfilePicture,
              );
            }
            final postIndex = index - 2;
            final post = state.isLoading
                ? PostEntity.getDummyPost()
                : state.posts[postIndex];
            return PostCard(
              post: post,
              currentUserProfilePicture: currentUserProfilePicture,
              isTogglingLike: state.togglingLikePostIds.contains(post.postId),
              isDeleting: state.deletingPostIds.contains(post.postId),
              isEditing: state.editingPostIds.contains(post.postId),
              onToggleLike: () {
                context.read<FeedCubit>().doIntent(
                  ToggleLikeIntent(post.postId),
                );
              },
              onDelete: () {
                context.read<FeedCubit>().doIntent(
                  DeletePostIntent(post.postId),
                );
              },
              onEditSubmit: (caption, newMediaFiles, deleteMediaIds) {
                context.read<FeedCubit>().doIntent(
                  EditPostIntent(
                    postId: post.postId,
                    caption: caption,
                    newMediaFiles: newMediaFiles,
                    deleteMediaIds: deleteMediaIds,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

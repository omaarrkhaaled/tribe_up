import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/post_card.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile/profile_cubit.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile/profile_intents.dart';
import 'package:tribe_up/features/profile/presentation/view_model/profile/profile_states.dart';

class PersonalPosts extends StatelessWidget {
  const PersonalPosts({super.key, required this.state});

  final ProfileStates state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingPosts) {
      return Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
          highlightColor: ColorManager.white.withValues(alpha: 0.6),
          duration: const Duration(milliseconds: 1200),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.circle(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Bone.text(words: 2),
                        const SizedBox(height: 4),
                        const Bone.text(words: 10),
                        const SizedBox(height: 8),
                        const Bone.square(size: 150),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    if (state.posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.post_add, size: 64, color: ColorManager.lightGrey),
              const SizedBox(height: 16),
              Text(
                UiConstants.noPostsYet,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: ColorManager.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return PostCard(
          post: post,
          currentUserProfilePicture: state.profile?.isOwnProfile == true
              ? state.profile?.profilePicture
              : null,
          isTogglingLike: state.togglingLikePostIds.contains(post.postId),
          isDeleting: state.deletingPostIds.contains(post.postId),
          isEditing: state.editingPostIds.contains(post.postId),
          onToggleLike: () {
            context.read<ProfileCubit>().doIntent(
              ToggleLikeIntent(post.postId),
            );
          },
          onDelete: () {
            context.read<ProfileCubit>().doIntent(
              DeletePostIntent(post.postId),
            );
          },
          onEditSubmit: (caption, newMediaFiles, deleteMediaIds) {
            context.read<ProfileCubit>().doIntent(
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
    );
  }
}

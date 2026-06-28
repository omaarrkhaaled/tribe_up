import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/post_card.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/action_button.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/cover_placeholder.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/create_post_trigger.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_profile/tribe_profile_states.dart';

class TribeProfileView extends StatefulWidget {
  final Group tribe;
  final TribeProfileState state;
  final TribeProfileCubit cubit;
  final String? userProfilePicture;
  final bool didChangeTribe;

  const TribeProfileView({
    super.key,
    required this.tribe,
    required this.state,
    required this.cubit,
    this.userProfilePicture,
    required this.didChangeTribe,
  });

  @override
  State<TribeProfileView> createState() => TribeProfileViewState();
}

class TribeProfileViewState extends State<TribeProfileView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.cubit.doIntent(LoadMoreTribePostsIntent(widget.tribe.id!));
    }
  }

  late TextTheme textTheme;
  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final relation = widget.state.userRelation;
    final tribe = widget.tribe;
    final state = widget.state;
    final cubit = widget.cubit;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, widget.didChangeTribe);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorManager.black),
            onPressed: () => Navigator.pop(context, widget.didChangeTribe),
          ),
          title: Text(tribe.groupName ?? ''),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ColorManager.primary.withValues(alpha: 0.05),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child:
                          tribe.groupProfilePicture != null &&
                              tribe.groupProfilePicture!.isNotEmpty &&
                              tribe.groupProfilePicture!.trim().isNotEmpty &&
                              tribe.groupProfilePicture != 'null' &&
                              tribe.groupProfilePicture != 'undefined' &&
                              tribe.groupProfilePicture!.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: tribe.groupProfilePicture!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => CoverPlaceholder(),
                            )
                          : CoverPlaceholder(),
                    ),
                    if (relation.isAdmin || relation.isOwner)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () =>
                              cubit.doIntent(OpenTribeSettingsIntent(tribe)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: ColorManager.black.withValues(alpha: 0.7),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.settings_outlined,
                              color: ColorManager.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  tribe.groupName ?? '',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tribe.description ?? '',
                  style: textTheme.titleSmall?.copyWith(
                    fontSize: 15,
                    color: ColorManager.black.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Skeletonizer(
                  enabled: tribe.membersCount == null && state.isLoadingPosts,
                  child: Row(
                    children: [
                      Text(
                        _formatCount(tribe.membersCount),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Invite button (admin only)
                      if (relation.isAdmin || relation.isOwner) ...[
                        ElevatedButton.icon(
                          onPressed: () =>
                              cubit.doIntent(const OpenInviteIntent()),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(UiConstants.invite),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            foregroundColor: ColorManager.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      ActionButton(
                        state: state,
                        cubit: cubit,
                        relation: relation,
                        tribe: tribe,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: ColorManager.lightGrey.withValues(alpha: 0.3)),

                if (relation.isMemberOrAbove) ...[
                  const SizedBox(height: 16),
                  CreatePostTrigger(
                    tribe: tribe,
                    cubit: cubit,
                    userProfilePicture: widget.userProfilePicture,
                  ),
                ],

                if (!relation.isMemberOrAbove && !state.isLoadingPosts) ...[
                  SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 56,
                          color: ColorManager.lightGrey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          UiConstants.joinTribeToSeePosts,
                          style: textTheme.bodyLarge?.copyWith(
                            color: ColorManager.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 16),
                  if (state.isLoadingPosts && state.posts.isEmpty) ...[
                    Skeletonizer(
                      enabled: true,
                      effect: const PulseEffect(),
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => PostCard(post: PostEntity.getDummyPost()),
                        ),
                      ),
                    ),
                  ] else if (state.posts.isEmpty) ...[
                    SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 56,
                            color: ColorManager.lightGrey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            UiConstants.noPostsYetBeTheFirstToPost,
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostCard(
                          post: post,
                          currentUserProfilePicture: widget.userProfilePicture,
                          isTogglingLike: state.togglingLikePostIds.contains(
                            post.postId,
                          ),
                          isDeleting: state.deletingPostIds.contains(
                            post.postId,
                          ),
                          isEditing: state.editingPostIds.contains(post.postId),
                          onToggleLike: () {
                            cubit.doIntent(ToggleLikePostIntent(post.postId));
                          },
                          onDelete: () {
                            cubit.doIntent(DeletePostIntent(post.postId));
                          },
                          onEditSubmit:
                              (caption, newMediaFiles, deleteMediaIds) {
                                cubit.doIntent(
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
                    if (state.isLoadingPosts)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                  ],
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int? count) {
    return UiConstants.membersCount(count ?? 0);
  }
}

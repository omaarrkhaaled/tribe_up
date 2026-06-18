import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/comments/presentation/view/widgets/comments_bottom_sheet.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/cubit/post_detail_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/post_detail_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/post_detail_ui_intents.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  final bool showComments;

  const PostDetailScreen({
    super.key,
    required this.postId,
    this.showComments = false,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final PostDetailCubit _cubit;
  late final StreamSubscription<PostDetailUiIntents> _uiSubscription;
  bool _commentsShown = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PostDetailCubit>();
    _cubit.loadPostDetail(widget.postId);
    _uiSubscription = _cubit.uiIntents.listen(_handleUiIntent);
  }

  void _handleUiIntent(PostDetailUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case PostDetailShowErrorIntent(:final error):
        UIUtils.showPremiumMessage(
          context,
          error,
          backgroundColor: ColorManager.red,
          icon: Icons.error_outline_rounded,
        );
      case PostDetailDeleteSuccessIntent():
        UIUtils.showPremiumMessage(
          context,
          UiConstants.postDeletedSuccessfully,
          backgroundColor: ColorManager.primary,
        );
        GoRouter.of(context).pop(true);
      case PostDetailEditSuccessIntent():
        UIUtils.showPremiumMessage(
          context,
          UiConstants.postUpdatedSuccessfully,
          backgroundColor: ColorManager.primary,
        );
    }
  }

  void _openCommentsSheet(BuildContext context, int postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.transparent,
      builder: (_) => CommentsBottomSheet(postId: postId),
    );
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<PostDetailCubit, PostDetailStates>(
        listener: (context, state) {
          if (state.data != null && widget.showComments && !_commentsShown) {
            _commentsShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _openCommentsSheet(context, state.data!.postId);
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(UiConstants.post),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
          body: BlocBuilder<PostDetailCubit, PostDetailStates>(
            builder: (context, state) {
              if (state.isLoading) {
                return Skeletonizer(
                  enabled: true,
                  effect: ShimmerEffect(
                    baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
                    highlightColor: ColorManager.white.withValues(alpha: 0.6),
                    duration: const Duration(milliseconds: 1200),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [PostCard(post: PostEntity.getDummyPost())],
                    ),
                  ),
                );
              }

              if (state.errorMessage != null && state.data == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: ColorManager.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(color: ColorManager.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _cubit.loadPostDetail(widget.postId),
                        child: Text(UiConstants.retry),
                      ),
                    ],
                  ),
                );
              }

              final post = state.data;
              if (post == null) {
                return Center(child: Text(UiConstants.postNotFound));
              }

              return RefreshIndicator(
                color: ColorManager.primary,
                onRefresh: () => _cubit.loadPostDetail(widget.postId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      PostCard(
                        post: post,
                        isTogglingLike: state.isTogglingLike,
                        isDeleting: state.isDeleting,
                        isEditing: state.isEditing,
                        onToggleLike: () => _cubit.toggleLike(post.postId),
                        onDelete: () => _cubit.deletePost(post.postId),
                        onEditSubmit: (caption, newMediaFiles, deleteMediaIds) {
                          _cubit.editPost(
                            postId: post.postId,
                            caption: caption,
                            newMediaFiles: newMediaFiles,
                            deleteMediaIds: deleteMediaIds,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

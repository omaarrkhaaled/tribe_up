import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';
import 'package:tribe_up/features/comments/presentation/view/widgets/add_comment_widget.dart';
import 'package:tribe_up/features/comments/presentation/view/widgets/comment_card.dart';
import 'package:tribe_up/features/comments/presentation/view/widgets/comment_actions_sheet.dart';
import 'package:tribe_up/features/comments/presentation/view/widgets/empty_comments_widget.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_cubit.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_states.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_ui_intents.dart';

class CommentsBottomSheet extends StatefulWidget {
  final int postId;
  final String? userProfilePicture;
  const CommentsBottomSheet({
    super.key,
    required this.postId,
    this.userProfilePicture,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  late final CommentsCubit _commentsCubit;
  StreamSubscription<CommentsUiIntents>? _streamSubscription;
  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _commentsCubit = getIt<CommentsCubit>();
    if (_commentsCubit.state.currentPostId != widget.postId ||
        _commentsCubit.state.comments.isEmpty) {
      _commentsCubit.doIntent(GetCommentsIntent(postId: widget.postId));
    }

    _streamSubscription = _commentsCubit.commentsStream.listen((event) {
      if (!mounted) return;
      final innerContext = _bodyKey.currentContext;
      if (!innerContext!.mounted) return;
      switch (event) {
        case ShowCommentOptionsUiIntent(:final comment):
          showCommentActions(innerContext, comment);
        case ShowCommentErrorIntent(:final errorMessage):
          UIUtils.showPremiumMessage(
            innerContext,
            errorMessage,
            backgroundColor: ColorManager.red,
          );
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _commentsCubit,
      child: Builder(
        key: _bodyKey,
        builder: (innerContext) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.75,
              ),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 55,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorManager.grey.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      UiConstants.comments,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: ColorManager.lightGrey,
                      thickness: .5,
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: BlocBuilder<CommentsCubit, CommentsStates>(
                        builder: (context, state) {
                          return Skeletonizer(
                            enabled: state.isLoading,
                            child: RefreshIndicator(
                              onRefresh: () async => _commentsCubit.doIntent(
                                GetCommentsIntent(postId: widget.postId),
                              ),
                              child: state.comments.isEmpty && !state.isLoading
                                  ? const EmptyCommentsWidget()
                                  : ListView.separated(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: state.isLoading
                                          ? 5
                                          : state.comments.length +
                                                (state.isLoadingMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        // Show spinner as the last extra item
                                        if (state.isLoadingMore &&
                                            index == state.comments.length) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: ColorManager.primary,
                                              ),
                                            ),
                                          );
                                        }
                                        // Trigger load more near the end
                                        if (index >=
                                                state.comments.length - 2 &&
                                            state.hasMore &&
                                            !state.isLoading &&
                                            !state.isLoadingMore) {
                                          _commentsCubit.doIntent(
                                            LoadMoreCommentsIntent(
                                              postId: widget.postId,
                                            ),
                                          );
                                        }
                                        final comment = state.isLoading
                                            ? CommentItemEntity.getDummyCommentItem()
                                            : state.comments[index];
                                        return CommentCard(
                                          key: ValueKey(comment.id ?? index),
                                          comment: comment,
                                        );
                                      },
                                      separatorBuilder: (_, __) => Divider(
                                        thickness: .5,
                                        color: ColorManager.lightGrey,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    AddCommentWidget(
                      postId: widget.postId,
                      cubit: _commentsCubit,
                      userProfilePicture: widget.userProfilePicture,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showCommentActions(BuildContext context, CommentItemEntity comment) {
    final cubit = context.read<CommentsCubit>();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) =>
          CommentActionsSheet(comment: comment, cubit: cubit),
    );
  }
}

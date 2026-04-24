import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/date_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/comment_operations.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_cubit.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_states.dart';

class CommentCard extends StatefulWidget {
  final CommentItemEntity comment;
  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsStates>(
      buildWhen: (prev, curr) {
        final prevComment = prev.comments.firstWhereOrNull(
          (c) => c.id == widget.comment.id,
        );
        final currComment = curr.comments.firstWhereOrNull(
          (c) => c.id == widget.comment.id,
        );
        return prevComment != currComment ||
            prev.editingCommentId != curr.editingCommentId ||
            prev.commentOperation != curr.commentOperation;
      },
      builder: (context, state) {
        final comment = state.comments.firstWhere(
          (c) => c.id == widget.comment.id,
          orElse: () => widget.comment,
        );

        final isEditing = state.editingCommentId == comment.id;

        if (!isEditing && _editController.text != comment.content) {
          _editController.text = comment.content ?? '';
        }
        return GestureDetector(
          onLongPressStart: (details) {
            if (comment.isAuthor ?? false) {
              context.read<CommentsCubit>().doIntent(
                ShowCommentOptionsIntent(comment: comment),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              dense: true,
              leading: Column(
                children: [
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoutesConstants.profile,
                        extra: comment.username,
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: comment.profilePicture ?? '',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 20,
                      ),
                      placeholder: (_, __) => const CircleAvatar(radius: 20),
                      errorWidget: (_, __, ___) => const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                comment.username ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: isEditing
                  ? _buildEditField(context, comment, state)
                  : _buildNormalContent(context, comment),
              trailing: isEditing
                  ? null
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => context.read<CommentsCubit>().doIntent(
                            LikeCommentIntent(commentId: comment.id!),
                          ),
                          child: (comment.isLikedByCurrentUser ?? false)
                              ? Icon(Icons.favorite, color: ColorManager.red)
                              : const Icon(Icons.favorite_border),
                        ),
                        const SizedBox(height: 5),
                        Text('${comment.likesCount ?? 0}'),
                      ],
                    ),
              isThreeLine: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField(
    BuildContext context,
    CommentItemEntity comment,
    CommentsStates state,
  ) {
    final isSaving = state.commentOperation == CommentOperations.edit;

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _editController,
              autofocus: true,
              maxLines: null,
              cursorColor: ColorManager.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: UiConstants.editComment,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorManager.grey,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: ColorManager.grey.withValues(alpha: .2),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: ColorManager.black, width: 1),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => context.read<CommentsCubit>().doIntent(
                    const CancelEditCommentIntent(),
                  ),
                  child: Icon(Icons.close, size: 18, color: ColorManager.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          isSaving
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: Padding(padding: EdgeInsets.all(6)),
                )
              : GestureDetector(
                  onTap: () {
                    if (_editController.text.trim().isEmpty) return;
                    context.read<CommentsCubit>().doIntent(
                      EditCommentIntent(
                        commentId: comment.id!,
                        content: _editController.text.trim(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorManager.grey.withValues(alpha: .2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: ColorManager.black,
                      size: 22,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context, CommentItemEntity comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.content ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateConstants.formatDate(comment.createdAt ?? ''),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorManager.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

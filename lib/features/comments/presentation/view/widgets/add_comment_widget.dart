import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/comment_operations.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_cubit.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_states.dart';

class AddCommentWidget extends StatefulWidget {
  final int postId;
  final CommentsCubit cubit;
  const AddCommentWidget({
    super.key,
    required this.postId,
    required this.cubit,
  });

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    widget.cubit.doIntent(
      AddCommentIntent(postId: widget.postId, content: _controller.text.trim()),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsStates>(
      builder: (context, state) {
        final profilePic = state.comments
            .where((comment) => comment.postId == widget.postId)
            .firstOrNull
            ?.profilePicture;

        return Container(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: ColorManager.white,
            border: Border(
              top: BorderSide(color: ColorManager.grey.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            children: [
              if (profilePic != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: profilePic,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundImage: imageProvider,
                    ),

                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: UiConstants.addAComment,
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
                      borderSide: BorderSide(
                        color: ColorManager.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              state.commentOperation == CommentOperations.add
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: ColorManager.primary,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorManager.grey.withValues(alpha: .2),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: _submit,
                        child: Icon(
                          Icons.send_rounded,
                          color: ColorManager.black,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

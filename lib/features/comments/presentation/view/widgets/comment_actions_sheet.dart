import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_cubit.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';

class CommentActionsSheet extends StatelessWidget {
  final CommentItemEntity comment;
  final CommentsCubit cubit;

  const CommentActionsSheet({
    super.key,
    required this.comment,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: ColorManager.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorManager.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit_outlined, color: ColorManager.white),
            title: Text(
              UiConstants.edit,
              style: TextStyle(color: ColorManager.white),
            ),
            onTap: () {
              Navigator.pop(context);
              cubit.doIntent(StartEditCommentIntent(commentId: comment.id!));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: ColorManager.red),
            title: Text(
              UiConstants.delete,
              style: TextStyle(color: ColorManager.red),
            ),
            onTap: () {
              Navigator.pop(context);
              cubit.doIntent(DeleteCommentIntent(commentId: comment.id!));
            },
          ),
        ],
      ),
    );
  }
}

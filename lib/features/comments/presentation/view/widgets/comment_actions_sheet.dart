import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/comments/domain/entities/comment_item_entity.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_cubit.dart';
import 'package:tribe_up/features/comments/presentation/view_model/comments_intents.dart';

class CommentActionsSheet extends StatefulWidget {
  final CommentItemEntity comment;
  final CommentsCubit cubit;

  const CommentActionsSheet({
    super.key,
    required this.comment,
    required this.cubit,
  });

  @override
  State<CommentActionsSheet> createState() => _CommentActionsSheetState();
}

class _CommentActionsSheetState extends State<CommentActionsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: ColorManager.black.withValues(alpha: 0.45),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionsCard(
                          comment: widget.comment,
                          cubit: widget.cubit,
                          onClose: _close,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final CommentItemEntity comment;
  final CommentsCubit cubit;
  final VoidCallback onClose;

  const _ActionsCard({
    required this.comment,
    required this.cubit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorManager.white.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _ActionTile(
              icon: Icons.edit_rounded,
              label: 'Edit comment',
              iconColor: ColorManager.white,
              labelColor: ColorManager.white,
              onTap: () {
                HapticFeedback.selectionClick();
                onClose();
                cubit.doIntent(StartEditCommentIntent(commentId: comment.id!));
              },
            ),
            Divider(
              height: 1,
              color: ColorManager.white.withValues(alpha: 0.1),
            ),
            _ActionTile(
              icon: Icons.delete_rounded,
              label: 'Delete comment',
              iconColor: ColorManager.red,
              labelColor: ColorManager.red,
              onTap: () {
                HapticFeedback.heavyImpact();
                onClose();
                cubit.doIntent(DeleteCommentIntent(commentId: comment.id!));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _pressed
            ? ColorManager.white.withValues(alpha: 0.08)
            : ColorManager.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(widget.icon, color: widget.iconColor, size: 22),
            const SizedBox(width: 14),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: widget.labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

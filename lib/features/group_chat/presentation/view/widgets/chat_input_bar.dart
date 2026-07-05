import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isEditing,
    required this.onSend,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.isEditing
                        ? Colors.amber.withValues(alpha: 0.6)
                        : ColorManager.lightGrey.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorManager.black,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.isEditing
                        ? 'Edit message...'
                        : 'Type msg...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorManager.lightGrey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedScale(
              scale: _hasText ? 1.0 : 0.85,
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              child: GestureDetector(
                onTap: _hasText ? widget.onSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasText
                        ? ColorManager.primary
                        : ColorManager.lightGrey.withValues(alpha: 0.4),
                    boxShadow: _hasText
                        ? [
                            BoxShadow(
                              color: ColorManager.primary.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    widget.isEditing ? Icons.check_rounded : Icons.send_rounded,
                    color: _hasText ? Colors.white : ColorManager.lightGrey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

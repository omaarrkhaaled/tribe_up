import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_edit_banner.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_input_bar.dart';
import 'package:tribe_up/features/group_chat/presentation/view/widgets/chat_messages_list.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_cubit.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_intents.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_states.dart';
import 'package:tribe_up/features/group_chat/presentation/view_model/group_chat_ui_intents.dart';

class GroupChatScreen extends StatelessWidget {
  final int groupId;
  final String groupName;
  final String? groupPicture;
  final String? currentUserId;

  const GroupChatScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupPicture,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupChatCubit>(
      create: (_) =>
          getIt<GroupChatCubit>()
            ..doIntent(GetGroupMessagesIntent(groupId: groupId)),
      child: GroupChatScreenContent(
        groupId: groupId,
        groupName: groupName,
        groupPicture: groupPicture,
        currentUserId: currentUserId,
      ),
    );
  }
}

class GroupChatScreenContent extends StatefulWidget {
  final int groupId;
  final String groupName;
  final String? groupPicture;
  final String? currentUserId;

  const GroupChatScreenContent({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupPicture,
    this.currentUserId,
  });

  @override
  State<GroupChatScreenContent> createState() => _GroupChatScreenContentState();
}

class _GroupChatScreenContentState extends State<GroupChatScreenContent> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<GroupChatUiIntents>? _uiIntentSub;
  String? _resolvedUserId;

  @override
  void initState() {
    super.initState();
    _resolvedUserId = widget.currentUserId;
    if (_resolvedUserId == null) {
      _fetchUserId();
    }
    final cubit = context.read<GroupChatCubit>();
    _uiIntentSub = cubit.groupChatStream.listen(_handleUiIntent);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchUserId() async {
    final userSummary = await getIt<LoginLocalDataSource>().getUserSummary();
    if (mounted) {
      setState(() {
        _resolvedUserId = userSummary?.id;
      });
    }
  }

  void _handleUiIntent(GroupChatUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case ShowMessageOptionsUiIntent(:final message):
        _showMessageOptions(message);
      case ShowGroupChatErrorIntent(:final errorMessage):
        UIUtils.showPremiumMessage(
          context,
          errorMessage,
          backgroundColor: ColorManager.red,
        );
      case ShowGroupChatLoadingIntent():
        break;
    }
  }

  void _showMessageOptions(dynamic message) {
    final cubit = context.read<GroupChatCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MessageOptionsSheet(
        onEdit: () {
          cubit.doIntent(StartEditMessageIntent(messageId: message.id));
          _messageController.text = message.content;
        },
        onDelete: () {
          cubit.doIntent(DeleteGroupMessageIntent(messageId: message.id));
        },
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final cubit = context.read<GroupChatCubit>();
      final state = cubit.state;
      if (state.hasMore && !state.isLoadingMore) {
        cubit.doIntent(LoadMoreGroupMessagesIntent(groupId: widget.groupId));
      }
    }
  }

  void _onSend() {
    final cubit = context.read<GroupChatCubit>();
    final state = cubit.state;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (state.editingMessageId != null) {
      cubit.doIntent(
        EditGroupMessageIntent(messageId: state.editingMessageId!, text: text),
      );
    } else {
      cubit.doIntent(
        SendGroupMessageIntent(groupId: widget.groupId, text: text),
      );
    }
    _messageController.clear();
  }

  void _onCancelEdit() {
    context.read<GroupChatCubit>().doIntent(const CancelEditMessageIntent());
    _messageController.clear();
  }

  @override
  void dispose() {
    _uiIntentSub?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupChatCubit, GroupChatStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F4FA),
          appBar: ChatAppBar(
            groupName: widget.groupName,
            groupPicture: widget.groupPicture,
          ),
          body: Column(
            children: [
              Expanded(
                child: ChatMessagesList(
                  state: state,
                  currentUserId: _resolvedUserId,
                  scrollController: _scrollController,
                  onMessageLongPress: (message) {
                    if (message.senderId == _resolvedUserId) {
                      context.read<GroupChatCubit>().doIntent(
                        ShowMessageOptionsIntent(message: message),
                      );
                    }
                  },
                ),
              ),
              if (state.editingMessageId != null)
                ChatEditBanner(onCancel: _onCancelEdit),
              ChatInputBar(
                controller: _messageController,
                isEditing: state.editingMessageId != null,
                onSend: _onSend,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageOptionsSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MessageOptionsSheet({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColorManager.lightGrey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          _OptionTile(
            icon: Icons.edit_outlined,
            label: 'Edit Message',
            color: ColorManager.primary,
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          Divider(
            height: 1,
            color: ColorManager.lightGrey.withValues(alpha: 0.3),
          ),
          _OptionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Message',
            color: ColorManager.red,
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

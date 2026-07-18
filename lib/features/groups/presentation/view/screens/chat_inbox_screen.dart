import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/chat_inbox_list.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_states.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_ui_intents.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatInboxCubit>(
      create: (_) =>
          getIt<ChatInboxCubit>()..doIntent(const LoadChatInboxIntent()),
      child: const _ChatInboxContent(),
    );
  }
}

class _ChatInboxContent extends StatefulWidget {
  const _ChatInboxContent();

  @override
  State<_ChatInboxContent> createState() => _ChatInboxContentState();
}

class _ChatInboxContentState extends State<_ChatInboxContent> {
  StreamSubscription<ChatInboxUiIntents>? _uiIntentSub;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatInboxCubit>();
    _uiIntentSub = cubit.uiIntents.listen(_handleUiIntent);
  }

  void _handleUiIntent(ChatInboxUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case ChatInboxErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
    }
  }

  @override
  void dispose() {
    _uiIntentSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInboxCubit, ChatInboxStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            backgroundColor: ColorManager.white,
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  UiConstants.chats,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.black,
                  ),
                ),
                const SizedBox(height: 4),
                Divider(),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ChatInboxList(
                    state: state,
                    onLoadMore: () {
                      context.read<ChatInboxCubit>().doIntent(
                        const LoadMoreChatInboxIntent(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

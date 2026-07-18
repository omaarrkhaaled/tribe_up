import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/chat_inbox_empty.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/chat_inbox_item_card.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/chat_inbox_skelton.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/chat_inbox/chat_inbox_states.dart';

class ChatInboxList extends StatefulWidget {
  final ChatInboxStates state;
  final VoidCallback onLoadMore;

  const ChatInboxList({
    super.key,
    required this.state,
    required this.onLoadMore,
  });

  @override
  State<ChatInboxList> createState() => _ChatInboxListState();
}

class _ChatInboxListState extends State<ChatInboxList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading) {
      return ChatInboxSkeleton();
    }

    final items = widget.state.filteredItems;

    if (items.isEmpty) {
      return ChatInboxEmpty();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChatInboxCubit>().doIntent(const LoadChatInboxIntent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length + (widget.state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => Divider(
          color: ColorManager.lightGrey.withValues(alpha: 0.25),
          height: 1,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          return ChatInboxItemCard(item: items[index]);
        },
      ),
    );
  }
}

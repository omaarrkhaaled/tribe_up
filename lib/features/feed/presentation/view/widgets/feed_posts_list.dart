import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/post_card.dart';

class FeedPostsList extends StatefulWidget {
  final FeedStates state;
  final ScrollController scrollController;

  const FeedPostsList({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  State<FeedPostsList> createState() => _FeedPostsListState();
}

class _FeedPostsListState extends State<FeedPostsList> {
  @override
  Widget build(BuildContext context) {
    if (!widget.state.isLoading && widget.state.errorMessage != null) {
      return Center(child: Text('Error: ${widget.state.errorMessage}'));
    }

    if (!widget.state.isLoading && widget.state.posts.isEmpty) {
      return const Center(child: Text('No posts yet'));
    }

    return Skeletonizer(
      enabled: widget.state.isLoading,
      effect: const PulseEffect(),
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top,
        ),
        itemCount: widget.state.isLoading ? 5 : widget.state.posts.length,
        itemBuilder: (context, index) {
          final post = widget.state.isLoading
              ? PostEntity.getDummyPost()
              : widget.state.posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }
}

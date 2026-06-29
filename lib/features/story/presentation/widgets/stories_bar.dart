import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_cubit.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_states.dart';
import 'package:tribe_up/features/story/presentation/screens/story_viewer_screen.dart';
import 'package:tribe_up/features/feed/presentation/widgets/create_post_sheet.dart';

class StoriesBar extends StatefulWidget {
  final String? currentUserProfilePicture;
  final List<Group> joinedGroups;

  const StoriesBar({
    super.key,
    this.currentUserProfilePicture,
    required this.joinedGroups,
  });

  @override
  State<StoriesBar> createState() => _StoriesBarState();
}

class _StoriesBarState extends State<StoriesBar> {
  @override
  void initState() {
    super.initState();
    // Load the story feed when the bar is initialized
    context.read<StoryCubit>().loadStoryFeed();
  }

  void _openCreateStorySheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatePostSheet(
        groups: widget.joinedGroups,
        startAsPost: false, // Pre-select Story tab
      ),
    );
    if (result != null) {
      // Refresh the story feed after creating a story
      if (mounted) {
        context.read<StoryCubit>().loadStoryFeed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final feedItems = state.storyFeedItems;

        return Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.white,
            border: Border(
              bottom: BorderSide(
                color: ColorManager.lightGrey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: feedItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: state.isLoadingFeed ? null : _openCreateStorySheet,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.lightGrey.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: ColorManager.lightGrey
                                    .withValues(alpha: 0.2),
                                backgroundImage:
                                    (widget.currentUserProfilePicture != null &&
                                        widget.currentUserProfilePicture!
                                            .startsWith('http'))
                                    ? CachedNetworkImageProvider(
                                        widget.currentUserProfilePicture!,
                                      )
                                    : null,
                                child:
                                    (widget.currentUserProfilePicture == null ||
                                        !widget.currentUserProfilePicture!
                                            .startsWith('http'))
                                    ? Icon(
                                        Icons.person,
                                        color: ColorManager.grey,
                                        size: 30,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: state.isLoadingFeed
                                      ? ColorManager.lightGrey
                                      : ColorManager.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorManager.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          UiConstants.yourStory,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final item = feedItems[index - 1];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (routeCtx) => BlocProvider.value(
                        value: context.read<StoryCubit>(),
                        child: StoryViewerScreen(
                          allFeedItems: feedItems,
                          initialGroupIndex: index - 1,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: item.hasUnseenStories
                              ? const LinearGradient(
                                  colors: [
                                    Colors.amber,
                                    Colors.deepOrange,
                                    Colors.purple,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                )
                              : null,
                          border: !item.hasUnseenStories
                              ? Border.all(
                                  color: ColorManager.lightGrey.withValues(
                                    alpha: 0.6,
                                  ),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.white,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: ColorManager.lightGrey.withValues(
                              alpha: 0.2,
                            ),
                            backgroundImage:
                                (item.groupProfilePicture != null &&
                                    item.groupProfilePicture!.startsWith(
                                      'http',
                                    ))
                                ? CachedNetworkImageProvider(
                                    item.groupProfilePicture!,
                                  )
                                : null,
                            child:
                                (item.groupProfilePicture == null ||
                                    !item.groupProfilePicture!.startsWith(
                                      'http',
                                    ))
                                ? Icon(
                                    Icons.groups,
                                    color: ColorManager.grey,
                                    size: 24,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 70,
                        child: Text(
                          item.groupName ?? 'Tribe',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: item.hasUnseenStories
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: ColorManager.black,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

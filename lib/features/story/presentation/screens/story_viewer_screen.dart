import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tribe_up/config/di/di.dart';

import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_cubit.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_states.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_header.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_media_content.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_progress_bars.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_caption.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_delete_dialog.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_empty_view.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_loading_view.dart';
import 'package:tribe_up/features/story/presentation/widgets/story_overlays.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryFeedItemEntity> allFeedItems;

  final int initialGroupIndex;

  const StoryViewerScreen({
    super.key,
    required this.allFeedItems,
    required this.initialGroupIndex,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late int _currentGroupIndex;

  int _currentStoryIndex = 0;
  bool _isGroupLoaded = false;
  bool _isDeleting = false;
  double? _lastTapPositionX;
  List<StoryEntity> _stories = [];
  String? _currentUserId;
  String? _currentUserName;

  bool _hasStartedCurrentStory = false;
  bool _isUserHolding = false;

  StoryFeedItemEntity get _currentFeedItem =>
      widget.allFeedItems[_currentGroupIndex];
  int get _currentGroupId => _currentFeedItem.groupId;
  String get _currentGroupName => _currentFeedItem.groupName ?? 'Tribe';

  @override
  void initState() {
    super.initState();
    _currentGroupIndex = widget.initialGroupIndex;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _loadGroup(_currentGroupIndex);
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userSummary = await getIt<LoginLocalDataSource>().getUserSummary();
    if (mounted && userSummary != null) {
      setState(() {
        _currentUserId = userSummary.id;
        _currentUserName = userSummary.userName;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadGroup(int groupIndex) {
    setState(() {
      _isGroupLoaded = false;
      _stories = [];
      _currentStoryIndex = 0;
    });
    _animationController.stop();
    _animationController.reset();
    context.read<StoryCubit>().loadGroupStories(
      widget.allFeedItems[groupIndex].groupId,
    );
  }

  void _startStory() {
    if (_stories.isEmpty) return;
    _animationController.stop();
    _animationController.reset();
    _hasStartedCurrentStory = false;
    _isUserHolding = false;

    // Mark current story as viewed
    final currentStory = _stories[_currentStoryIndex];
    context.read<StoryCubit>().markStoryAsViewed(
      _currentGroupId,
      currentStory.id,
    );

    if (currentStory.mediaURL == null) {
      _hasStartedCurrentStory = true;
      _animationController.forward();
    }
  }

  void _nextStory() {
    if (_currentStoryIndex < _stories.length - 1) {
      // More stories in the same tribe
      setState(() => _currentStoryIndex++);
      _startStory();
    } else {
      // No more stories in this tribe → try the next tribe
      _advanceToNextGroup();
    }
  }

  void _advanceToNextGroup() {
    final nextGroupIndex = _currentGroupIndex + 1;
    if (nextGroupIndex < widget.allFeedItems.length) {
      // There IS a next tribe
      setState(() => _currentGroupIndex = nextGroupIndex);
      _loadGroup(nextGroupIndex);
    } else {
      // We've watched all tribes
      if (mounted) Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _startStory();
    } else {
      // Already on the first story, restart it
      _startStory();
    }
  }

  void _pauseStory() {
    _isUserHolding = true;
    _animationController.stop();
  }

  void _resumeStory() {
    _isUserHolding = false;
    if (_hasStartedCurrentStory) {
      _animationController.forward();
    }
  }

  bool _isOwner(StoryEntity story) {
    if (_currentUserId == null && _currentUserName == null) return false;

    final isIdMatch =
        story.creatorId != null &&
        _currentUserId != null &&
        story.creatorId == _currentUserId;

    final isUsernameMatch =
        story.creatorUserName != null &&
        _currentUserName != null &&
        story.creatorUserName!.toLowerCase() == _currentUserName!.toLowerCase();

    return isIdMatch || isUsernameMatch;
  }

  void _confirmDelete(StoryEntity story) {
    _pauseStory();
    StoryDeleteDialog.show(
      context: context,
      onCancel: _resumeStory,
      onConfirm: () => _performDelete(story),
    );
  }

  void _performDelete(StoryEntity story) async {
    if (!mounted) return;
    setState(() => _isDeleting = true);
    _pauseStory();
    EasyLoading.show(status: 'Deleting story...');

    final success = await context.read<StoryCubit>().deleteStory(
      _currentGroupId,
      story.id,
    );

    EasyLoading.dismiss();

    if (!mounted) return;

    if (success) {
      setState(() => _isDeleting = false);
    } else {
      setState(() => _isDeleting = false);
      _resumeStory();
      final errorMsg =
          context.read<StoryCubit>().state.errorMessage ??
          'Failed to delete story';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<StoryCubit, StoryState>(
        listener: (context, state) {
          if (_isDeleting) return;

          final groupStories = state.groupStories[_currentGroupId];
          if (groupStories != null) {
            if (!_isGroupLoaded || groupStories.length != _stories.length) {
              setState(() {
                _stories = groupStories;
                _isGroupLoaded = true;
                if (_currentStoryIndex >= _stories.length) {
                  _currentStoryIndex = _stories.isNotEmpty
                      ? _stories.length - 1
                      : 0;
                }
              });
              if (_stories.isNotEmpty) {
                _startStory();
              } else {
                _advanceToNextGroup();
              }
            }
          }
        },
        builder: (context, state) {
          final isLoading =
              state.isLoadingGroupStories[_currentGroupId] ?? false;

          if (isLoading || !_isGroupLoaded) {
            return StoryLoadingView(groupName: _currentGroupName);
          }

          if (_stories.isEmpty) {
            return const StoryEmptyView();
          }

          final story = _stories[_currentStoryIndex];

          return GestureDetector(
            onTapDown: (details) {
              _lastTapPositionX = details.globalPosition.dx;
            },
            onTap: () {
              final screenWidth = MediaQuery.of(context).size.width;
              final dx = _lastTapPositionX ?? screenWidth;
              if (dx < screenWidth * 0.3) {
                _previousStory();
              } else {
                _nextStory();
              }
            },
            onLongPressStart: (_) => _pauseStory(),
            onLongPressEnd: (_) => _resumeStory(),
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 10) {
                Navigator.pop(context);
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                StoryMediaContent(
                  story: story,
                  hasStartedCurrentStory: _hasStartedCurrentStory,
                  onMediaLoaded: () {
                    _hasStartedCurrentStory = true;
                    if (!_isUserHolding) {
                      _animationController.forward();
                    }
                  },
                ),

                StoryOverlays(
                  showBottomOverlay:
                      story.mediaURL != null &&
                      story.caption != null &&
                      story.caption!.isNotEmpty,
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StoryProgressBars(
                        animationController: _animationController,
                        storyCount: _stories.length,
                        currentStoryIndex: _currentStoryIndex,
                      ),
                      const SizedBox(height: 12),
                      StoryHeader(
                        story: story,
                        currentGroupName: _currentGroupName,
                        isOwner: _isOwner(story),
                        onDeleteTap: () => _confirmDelete(story),
                        onCloseTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                if (story.mediaURL != null &&
                    story.caption != null &&
                    story.caption!.isNotEmpty)
                  StoryCaption(caption: story.caption!),
              ],
            ),
          );
        },
      ),
    );
  }
}

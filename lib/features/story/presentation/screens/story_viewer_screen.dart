import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';
import 'package:tribe_up/features/story/domain/entities/story_feed_item_entity.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_cubit.dart';
import 'package:tribe_up/features/story/presentation/cubit/story_states.dart';

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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Story',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this story? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              _resumeStory();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              _performDelete(story);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ColorManager.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading $_currentGroupName stories...',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (_stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No stories found in this Tribe.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ],
              ),
            );
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
                // ── Media Content ──
                story.mediaURL != null
                    ? CachedNetworkImage(
                        imageUrl: story.mediaURL!,
                        fit: BoxFit.contain,
                        imageBuilder: (context, imageProvider) {
                          if (!_hasStartedCurrentStory) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted && !_hasStartedCurrentStory) {
                                _hasStartedCurrentStory = true;
                                if (!_isUserHolding) {
                                  _animationController.forward();
                                }
                              }
                            });
                          }
                          return Image(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          );
                        },
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black54,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              story.caption ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                // ── Gradient Shadow overlays ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                if (story.mediaURL != null &&
                    story.caption != null &&
                    story.caption!.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                // ── Top Bar: Progress Bars + Header info ──
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Animated Progress Bars ──
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, _) {
                          return Row(
                            children: List.generate(_stories.length, (index) {
                              double progressValue;
                              if (index < _currentStoryIndex) {
                                progressValue = 1.0;
                              } else if (index == _currentStoryIndex) {
                                progressValue = _animationController.value;
                              } else {
                                progressValue = 0.0;
                              }
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: progressValue,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                      minHeight: 3,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // ── Header: Group details + Close button ──
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                (story.groupProfilePicture != null &&
                                    story.groupProfilePicture!.startsWith(
                                      'http',
                                    ))
                                ? CachedNetworkImageProvider(
                                    story.groupProfilePicture!,
                                  )
                                : null,
                            child:
                                (story.groupProfilePicture == null ||
                                    !story.groupProfilePicture!.startsWith(
                                      'http',
                                    ))
                                ? const Icon(
                                    Icons.groups,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentGroupName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (story.creatorUserName != null)
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                            userName:
                                                story.creatorUserName ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'by @${story.creatorUserName}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_isOwner(story))
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 26,
                              ),
                              onPressed: () => _confirmDelete(story),
                            ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Bottom Caption Overlay ──
                if (story.mediaURL != null &&
                    story.caption != null &&
                    story.caption!.isNotEmpty)
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                    left: 20,
                    right: 20,
                    child: Text(
                      story.caption!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/features/story/domain/entities/story_entity.dart';

class StoryMediaContent extends StatefulWidget {
  final StoryEntity story;
  final bool hasStartedCurrentStory;
  final VoidCallback onMediaLoaded;

  const StoryMediaContent({
    super.key,
    required this.story,
    required this.hasStartedCurrentStory,
    required this.onMediaLoaded,
  });

  @override
  State<StoryMediaContent> createState() => _StoryMediaContentState();
}

class _StoryMediaContentState extends State<StoryMediaContent> {
  @override
  Widget build(BuildContext context) {
    if (widget.story.mediaURL != null) {
      return CachedNetworkImage(
        imageUrl: widget.story.mediaURL!,
        fit: BoxFit.contain,
        imageBuilder: (context, imageProvider) {
          if (!widget.hasStartedCurrentStory) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !widget.hasStartedCurrentStory) {
                widget.onMediaLoaded();
              }
            });
          }
          return Image(image: imageProvider, fit: BoxFit.contain);
        },
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: Colors.white, size: 40),
        ),
      );
    } else {
      return Container(
        color: Colors.black54,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              widget.story.caption ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}

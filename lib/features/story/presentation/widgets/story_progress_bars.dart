import 'package:flutter/material.dart';

class StoryProgressBars extends StatelessWidget {
  final AnimationController animationController;
  final int storyCount;
  final int currentStoryIndex;

  const StoryProgressBars({
    super.key,
    required this.animationController,
    required this.storyCount,
    required this.currentStoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Row(
          children: List.generate(storyCount, (index) {
            double progressValue;
            if (index < currentStoryIndex) {
              progressValue = 1.0;
            } else if (index == currentStoryIndex) {
              progressValue = animationController.value;
            } else {
              progressValue = 0.0;
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
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
    );
  }
}

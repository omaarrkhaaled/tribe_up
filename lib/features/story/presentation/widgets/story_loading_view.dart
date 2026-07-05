import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class StoryLoadingView extends StatelessWidget {
  final String groupName;

  const StoryLoadingView({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorManager.primary),
          const SizedBox(height: 16),
          Text(
            'Loading $groupName stories...',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

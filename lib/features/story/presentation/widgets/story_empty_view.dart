import 'package:flutter/material.dart';
import '../../../../core/constants/ui_constants.dart';

class StoryEmptyView extends StatelessWidget {
  const StoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            UiConstants.noStoriesFoundInThisTribe,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(UiConstants.back),
          ),
        ],
      ),
    );
  }
}

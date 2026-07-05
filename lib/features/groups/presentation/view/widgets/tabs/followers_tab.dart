import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribe_follower_tile.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_states.dart';

class FollowersTab extends StatelessWidget {
  final TribeSettingsState state;
  final int groupId;
  final TribeSettingsCubit cubit;
  final ScrollController scrollController;

  const FollowersTab({
    super.key,
    required this.state,
    required this.groupId,
    required this.cubit,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingFollowers) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }
    if (state.followers.isEmpty) {
      return Center(
        child: Text(
          UiConstants.noFollowersYet,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: ColorManager.grey),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 100) {
          cubit.doIntent(LoadMoreFollowersIntent(groupId));
        }
        return false;
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount:
            state.followers.length + (state.isLoadingMoreFollowers ? 1 : 0),
        separatorBuilder: (_, __) =>
            Divider(color: ColorManager.lightGrey.withValues(alpha: 0.3)),
        itemBuilder: (_, index) {
          if (index >= state.followers.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            );
          }
          final follower = state.followers[index];
          return TribeFollowerTile(
            follower: follower,
            isAdmin: true,
            onRemove: () =>
                cubit.doIntent(DeleteFollowerIntent(groupId, follower.userId!)),
          );
        },
      ),
    );
  }
}

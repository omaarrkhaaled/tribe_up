import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/dialogs/confirm_leave_dialog.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/dialogs/confirm_unfollow_dialog.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribe_card.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribes_list/tribes_states.dart';

class TribesList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final TribesState state;
  final TribesListCubit cubit;
  TribesList({super.key, required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isJoined = state.currentTab == TribesTab.joined;
    final isFollowing = state.currentTab == TribesTab.following;
    final isLoading = isJoined
        ? state.isLoadingJoined
        : isFollowing
        ? state.isLoadingFollowing
        : state.isLoadingDiscover;
    final items = isJoined
        ? state.joinedTribes
        : isFollowing
        ? state.followingTribes
        : state.discoverTribes;

    if (isLoading && items.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_2_outlined,
              size: 64,
              color: ColorManager.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isJoined
                  ? UiConstants.youHaveNotJoinedAnyTribesYet
                  : isFollowing
                  ? 'You are not following any tribes yet.'
                  : UiConstants.noTribesFound,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorManager.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: ColorManager.primary,
      onRefresh: () async {
        if (isJoined) {
          cubit.doIntent(const LoadJoinedTribesIntent());
        } else if (isFollowing) {
          cubit.doIntent(const LoadFollowingTribesIntent());
        } else {
          cubit.doIntent(const LoadDiscoverTribesIntent());
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (_, index) {
          if (index >= items.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          final group = items[index];
          final relation = UserRelation.fromInt(group.userRelation);
          final isUserFollowing = relation == UserRelation.follower;

          return TribeCard(
            group: group,
            currentTab: state.currentTab,
            isPending: state.pendingActionIds.contains(group.id),
            onView: () {
              cubit.doIntent(ViewTribeIntent(group));
            },
            onAction: () {
              if (isJoined) {
                showDialog(
                  context: context,
                  builder: (dialogContext) => ConfirmLeaveDialog(
                    tribeName: group.groupName ?? '',
                    onConfirm: () =>
                        cubit.doIntent(LeaveTribeIntent(group.id!)),
                  ),
                );
              } else if (isUserFollowing) {
                showDialog(
                  context: context,
                  builder: (dialogContext) => ConfirmUnfollowDialog(
                    tribeName: group.groupName ?? 'Unknown',
                    onConfirm: () =>
                        cubit.doIntent(ToggleFollowTribeIntent(group.id!)),
                  ),
                );
              } else {
                cubit.doIntent(ToggleFollowTribeIntent(group.id!));
              }
            },
          );
        },
      ),
    );
  }
}

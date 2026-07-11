import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/features/groups/presentation/view/widgets/tribe_member_tile.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_intents.dart';
import 'package:tribe_up/features/groups/presentation/view_model/tribe_settings/tribe_settings_states.dart';

class MembersTab extends StatelessWidget {
  final TribeSettingsState state;
  final int groupId;
  final TribeSettingsCubit cubit;
  final bool isOwner;
  final ScrollController scrollController;

  const MembersTab({
    super.key,
    required this.state,
    required this.groupId,
    required this.cubit,
    required this.isOwner,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMembers) {
      return Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      );
    }
    if (state.members.isEmpty) {
      return Center(
        child: Text(
          UiConstants.noMembersFound,
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
          cubit.doIntent(LoadMoreMembersIntent(groupId));
        }
        return false;
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.members.length + (state.isLoadingMoreMembers ? 1 : 0),
        separatorBuilder: (_, __) =>
            Divider(color: ColorManager.lightGrey.withValues(alpha: 0.3)),
        itemBuilder: (_, index) {
          if (index >= state.members.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(color: ColorManager.primary),
              ),
            );
          }
          final member = state.members[index];
          return TribeMemberTile(
            member: member,
            viewerIsOwner: isOwner,
            isPending: state.pendingMemberIds.contains(member.id),
            onPromote: () =>
                cubit.doIntent(PromoteMemberIntent(groupId, member.id!)),
            onDemote: () =>
                cubit.doIntent(DemoteMemberIntent(groupId, member.id!)),
            onKick: () => cubit.doIntent(KickMemberIntent(groupId, member.id!)),
          );
        },
      ),
    );
  }
}

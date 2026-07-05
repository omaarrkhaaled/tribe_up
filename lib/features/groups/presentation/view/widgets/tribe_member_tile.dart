import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/data/models/response/group_members_response.dart';

class TribeMemberTile extends StatelessWidget {
  final GroupMemberResultDTO member;

  final bool viewerIsOwner;

  final bool isPending;
  final VoidCallback? onPromote;
  final VoidCallback? onDemote;
  final VoidCallback? onKick;

  const TribeMemberTile({
    super.key,
    required this.member,
    required this.viewerIsOwner,
    required this.isPending,
    this.onPromote,
    this.onDemote,
    this.onKick,
  });

  @override
  Widget build(BuildContext context) {
    final roleRaw = member.role?.toLowerCase() ?? '';
    final isAdminRole = roleRaw == 'admin';
    final isOwnerRole = roleRaw == 'owner';

    final actions = _buildActions(isAdminRole, isOwnerRole);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: member.userProfilePicture != null
            ? CachedNetworkImageProvider(member.userProfilePicture!)
            : null,
        backgroundColor: ColorManager.primary.withValues(alpha: 0.15),
        child: member.userProfilePicture == null
            ? Icon(Icons.person, color: ColorManager.primary, size: 22)
            : null,
      ),
      title: Text(
        member.userName ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: ColorManager.black,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isOwnerRole
                  ? Colors.amber.withValues(alpha: 0.15)
                  : isAdminRole
                  ? ColorManager.primary.withValues(alpha: 0.1)
                  : ColorManager.lightGrey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              member.role ?? UiConstants.member,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isOwnerRole
                    ? Colors.amber.shade700
                    : isAdminRole
                    ? ColorManager.primary
                    : ColorManager.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      trailing: actions.isEmpty
          ? null
          : isPending
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorManager.primary,
              ),
            )
          : PopupMenuButton<_MemberAction>(
              icon: Icon(Icons.more_horiz, color: ColorManager.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (action) {
                switch (action) {
                  case _MemberAction.promote:
                    onPromote?.call();
                  case _MemberAction.demote:
                    onDemote?.call();
                  case _MemberAction.kick:
                    onKick?.call();
                }
              },
              itemBuilder: (_) => actions
                  .map((action) => _buildMenuItem(context, action))
                  .toList(),
            ),
    );
  }

  List<_MemberAction> _buildActions(bool isAdminRole, bool isOwnerRole) {
    if (isOwnerRole) return [];
    if (viewerIsOwner) {
      if (isAdminRole) {
        return [_MemberAction.demote, _MemberAction.kick];
      } else {
        return [_MemberAction.promote, _MemberAction.kick];
      }
    } else {
      if (isAdminRole) {
        return [];
      } else {
        return [_MemberAction.promote, _MemberAction.kick];
      }
    }
  }

  PopupMenuItem<_MemberAction> _buildMenuItem(
    BuildContext context,
    _MemberAction action,
  ) {
    final textTheme = Theme.of(context).textTheme;
    switch (action) {
      case _MemberAction.promote:
        return PopupMenuItem(
          value: _MemberAction.promote,
          child: Row(
            children: [
              Icon(Icons.arrow_upward, size: 18, color: ColorManager.primary),
              const SizedBox(width: 8),
              Text(UiConstants.promoteToAdmin, style: textTheme.bodyMedium),
            ],
          ),
        );
      case _MemberAction.demote:
        return PopupMenuItem(
          value: _MemberAction.demote,
          child: Row(
            children: [
              Icon(Icons.arrow_downward, size: 18, color: ColorManager.grey),
              const SizedBox(width: 8),
              Text(UiConstants.demoteToMember, style: textTheme.bodyMedium),
            ],
          ),
        );
      case _MemberAction.kick:
        return PopupMenuItem(
          value: _MemberAction.kick,
          child: Row(
            children: [
              Icon(Icons.person_remove, size: 18, color: ColorManager.red),
              const SizedBox(width: 8),
              Text(
                UiConstants.remove,
                style: textTheme.bodyMedium?.copyWith(color: ColorManager.red),
              ),
            ],
          ),
        );
    }
  }
}

enum _MemberAction { promote, demote, kick }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/tribes_tab.dart';
import 'package:tribe_up/core/enums/user_relation.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';

class TribeCard extends StatelessWidget {
  final Group group;
  final TribesTab currentTab;
  final bool isPending;
  final VoidCallback onView;
  final VoidCallback onAction;

  const TribeCard({
    super.key,
    required this.group,
    required this.currentTab,
    required this.isPending,
    required this.onView,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final relation = UserRelation.fromInt(group.userRelation);
    final isFollowing = relation == UserRelation.follower;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: ColorManager.lightGrey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: group.groupProfilePicture != null
                ? CachedNetworkImage(
                    imageUrl: group.groupProfilePicture!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _imagePlaceholder(),
                    errorWidget: (_, __, ___) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupName ?? '',
                  style: textTheme.titleLarge?.copyWith(
                    color: ColorManager.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: ColorManager.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCount(group.membersCount),
                      style: textTheme.bodyMedium?.copyWith(
                        color: ColorManager.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (group.description != null && group.description!.isNotEmpty)
                  Text(
                    group.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorManager.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onView,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorManager.primary,
                          side: BorderSide(color: ColorManager.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          UiConstants.view,
                          style: textTheme.titleMedium?.copyWith(
                            color: ColorManager.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(context, relation, isFollowing),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    UserRelation relation,
    bool isFollowing,
  ) {
    if (isPending) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: ColorManager.primary,
          ),
        ),
      );
    }

    if (currentTab == TribesTab.joined) {
      // Leave button (red outline)
      return OutlinedButton(
        onPressed: onAction,
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorManager.red,
          side: BorderSide(color: ColorManager.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: const Text(
          'Leave',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    // Discover tab — Follow / Following toggle
    final label = isFollowing ? 'Following' : 'Follow';
    return ElevatedButton(
      onPressed: onAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing
            ? ColorManager.lightGrey
            : ColorManager.primary,
        foregroundColor: ColorManager.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 140.h,
      width: double.infinity,
      color: ColorManager.primary.withValues(alpha: 0.15),
      child: Icon(
        Icons.groups_2_outlined,
        size: 48,
        color: ColorManager.primary.withValues(alpha: 0.4),
      ),
    );
  }

  String _formatCount(int? count) {
    if (count == null) return '0 members';
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K members';
    }
    return '$count members';
  }
}

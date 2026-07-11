import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/groups/data/models/response/leaderboard_response.dart';

class LeaderboardEntryRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int index;

  const LeaderboardEntryRow({
    super.key,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final rank = entry.rank ?? (index + 1);
    final groupName = entry.groupName ?? 'Unknown';
    final score = entry.totalPoints ?? 0;
    final picture = entry.groupProfilePicture;

    Color? backgroundColor;
    Color rankTextColor = Colors.white;

    if (rank == 1) {
      backgroundColor = const Color(0xFFFFF7C4);
      rankTextColor = const Color(0xFFFFC107);
    } else if (rank == 2) {
      backgroundColor = const Color.fromARGB(255, 239, 221, 221);
      rankTextColor = const Color.fromARGB(255, 239, 216, 216);
    } else if (rank == 3) {
      backgroundColor = const Color(0xFFF6DACB);
      rankTextColor = const Color(0xFFE5733C);
    }

    return Container(
      color: backgroundColor ?? Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: textTheme.titleMedium?.copyWith(
                  color: rankTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 40,
              height: 40,
              child: picture != null
                  ? CachedNetworkImage(
                      imageUrl: picture,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          _buildAvatarPlaceholder(groupName, textTheme),
                    )
                  : _buildAvatarPlaceholder(groupName, textTheme),
            ),
          ),
          const SizedBox(width: 16),

          // Group Name
          Expanded(
            child: Text(
              groupName,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: ColorManager.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ColorManager.black,
                ),
              ),
              Text(
                UiConstants.points,
                style: textTheme.labelSmall?.copyWith(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Icon(Icons.bolt, color: ColorManager.amber, size: 24),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name, TextTheme textTheme) {
    return Container(
      color: ColorManager.primary.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: textTheme.titleMedium?.copyWith(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

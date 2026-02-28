import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/features/feed/domain/entities/post_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/video_player_widget.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  post.groupProfilePicture,
                ),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.groupName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'from @${post.username}',
                      style: textTheme.titleSmall?.copyWith(
                        color: ColorManager.grey,

                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
          const SizedBox(height: 12),

          if (post.media.isNotEmpty)
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: post.media.length,
                itemBuilder: (context, index) {
                  final postMedia = post.media[index];
                  if (postMedia.mediaType == 'Image') {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: postMedia.mediaURL,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Container(
                          height: 250,
                          width: double.infinity,
                          color: ColorManager.lightGrey.withValues(alpha: .2),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 40,
                            color: ColorManager.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  if (postMedia.mediaType == 'Video') {
                    return VideoPlayerWidget(url: postMedia.mediaURL);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

          const SizedBox(height: 12),

          if (post.caption != null && post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                post.caption!,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          Row(
            children: [
              Icon(
                post.isLikedByCurrentUser
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: post.isLikedByCurrentUser
                    ? Colors.red
                    : ColorManager.black,
                size: 26,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.likesCount}',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.add_comment_outlined, size: 24),
              const SizedBox(width: 8),
              Text(
                '${post.commentCount}',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.link, size: 26),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            _formatDate(post.createdAt),
            style: textTheme.titleSmall?.copyWith(
              color: ColorManager.grey,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: ColorManager.grey, thickness: .3, height: 1),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;

    final timeStr = _formatTime(date);
    final monthStr = _getMonthName(date.month);
    return '$timeStr • $monthStr ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final minuteStr = date.minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

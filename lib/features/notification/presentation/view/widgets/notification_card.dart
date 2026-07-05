import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  @override
  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead ?? false;
    final hasValidActorPicture =
        notification.actorPicture != null &&
        notification.actorPicture!.isNotEmpty &&
        notification.actorPicture != 'null' &&
        notification.actorPicture!.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 80,
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: isRead
              ? ColorManager.white
              : ColorManager.notificationUnreadBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
          border: isRead
              ? null
              : Border.all(
                  color: const Color.fromARGB(255, 27, 11, 99),
                  width: 1,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: ColorManager.white,
                        backgroundImage: hasValidActorPicture
                            ? CachedNetworkImageProvider(
                                notification.actorPicture!,
                              )
                            : null,
                        child: hasValidActorPicture
                            ? null
                            : Icon(
                                Icons.person,
                                color: ColorManager.primary,
                                size: 24,
                              ),
                      ),
                      if (!isRead)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notification.message != null) ...[
                          const SizedBox(height: 5),
                          Builder(
                            builder: (context) {
                              final parts = notification.message!.split(' ');
                              final user = parts.first;
                              final rest = parts
                                  .sublist(1, parts.length - 1)
                                  .join(' ');
                              final last = parts.last;
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$user ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                    ),
                                    TextSpan(
                                      text: rest,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: ColorManager.black,
                                            fontWeight: isRead
                                                ? FontWeight.w400
                                                : FontWeight.bold,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' $last',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: ColorManager.black,
                                            fontWeight: isRead
                                                ? FontWeight.w700
                                                : FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                        if (notification.createdAt != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            _formatDate(notification.createdAt!),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 13,
                                  color: ColorManager.grey,
                                  fontWeight: isRead
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
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

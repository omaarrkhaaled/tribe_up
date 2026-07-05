import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/notification/domain/entities/notification_entity.dart';

/// A Facebook-style in-app notification banner that slides down from the top,
/// then auto-dismisses after 4 seconds, or can be swiped away.
class InAppNotificationBanner extends StatefulWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const InAppNotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.onTap,
  });

  @override
  State<InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<InAppNotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto-dismiss after 4 seconds
    _autoDismissTimer = Timer(const Duration(seconds: 4), _dismiss);
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    _autoDismissTimer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;
    final hasPicture =
        notification.actorPicture != null &&
        notification.actorPicture!.trim().isNotEmpty &&
        notification.actorPicture != 'null' &&
        notification.actorPicture!.startsWith('http');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: ValueKey(notification.id ?? DateTime.now().toString()),
          direction: DismissDirection.up,
          onDismissed: (_) => widget.onDismiss(),
          child: GestureDetector(
            onTap: () {
              _dismiss();
              widget.onTap?.call();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      // Avatar — same approach as notification_card.dart
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: ColorManager.primary.withValues(
                          alpha: 0.1,
                        ),
                        backgroundImage: hasPicture
                            ? CachedNetworkImageProvider(
                                notification.actorPicture!.trim(),
                              )
                            : null,
                        child: hasPicture
                            ? null
                            : Icon(
                                Icons.person,
                                color: ColorManager.primary,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (notification.title != null &&
                                notification.title!.isNotEmpty)
                              Text(
                                notification.title!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (notification.message != null &&
                                notification.message!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      (notification.title != null &&
                                          notification.title!.isNotEmpty)
                                      ? 2
                                      : 0,
                                ),
                                child: Text(
                                  notification.message!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColorManager.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Dismiss button
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: ColorManager.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InAppNotificationOverlay extends StatefulWidget {
  final Stream<NotificationEntity> notificationStream;
  final Widget child;
  final void Function(NotificationEntity)? onNotificationTap;

  const InAppNotificationOverlay({
    super.key,
    required this.notificationStream,
    required this.child,
    this.onNotificationTap,
  });

  @override
  State<InAppNotificationOverlay> createState() =>
      _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState extends State<InAppNotificationOverlay> {
  StreamSubscription<NotificationEntity>? _sub;
  // Queue up to 3 banners
  final List<NotificationEntity> _queue = [];

  @override
  void initState() {
    super.initState();
    _sub = widget.notificationStream.listen(_onNewNotification);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onNewNotification(NotificationEntity n) {
    if (!mounted) return;
    setState(() {
      if (_queue.length >= 3) _queue.removeAt(0);
      _queue.add(n);
    });
  }

  void _dismiss(NotificationEntity n) {
    if (!mounted) return;
    setState(() => _queue.remove(n));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_queue.isNotEmpty)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _queue.map((n) {
                  return InAppNotificationBanner(
                    key: ValueKey(n.id ?? n.hashCode),
                    notification: n,
                    onDismiss: () => _dismiss(n),
                    onTap: () {
                      widget.onNotificationTap?.call(n);
                      _dismiss(n);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

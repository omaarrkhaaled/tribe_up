import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/services/signalr/notification_signalr_service.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/notification/presentation/view/widgets/notification_card.dart';
import 'package:tribe_up/features/notification/presentation/view/widgets/notification_skeleton_card.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_cubit.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_intents.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_states.dart';
import 'package:tribe_up/features/notification/presentation/view_model/notification_ui_intents.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationCubit _cubit;
  late final StreamSubscription<NotificationUiIntents> _uiSubscription;
  final ScrollController _scrollController = ScrollController();

  static const int _skeletonCount = 7;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationCubit>();

    _uiSubscription = _cubit.uiIntents.listen(_handleUiIntent);

    _cubit.doIntent(const GetNotificationsIntent());

    _scrollController.addListener(_onScroll);

    // Connect the notifications SignalR hub so real-time notifications flow in
    getIt<NotificationSignalRService>().connect();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _cubit.doIntent(const LoadMoreNotificationsIntent());
    }
  }

  void _handleUiIntent(NotificationUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case NotificationShowErrorIntent(:final error):
        UIUtils.showPremiumMessage(
          context,
          error,
          backgroundColor: ColorManager.red,
          icon: Icons.error_outline_rounded,
        );

      case NavigateToPostIntent(:final postId):
        GoRouter.of(context).push(
          AppRoutesConstants.postDetail,
          extra: {'postId': postId, 'showComments': false},
        );

      case NavigateToCommentsIntent(:final postId):
        GoRouter.of(context).push(
          AppRoutesConstants.postDetail,
          extra: {'postId': postId, 'showComments': true},
        );
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(UiConstants.notifications),
          actions: [
            Tooltip(
              message: UiConstants.markAllAsRead,
              child: IconButton(
                onPressed: () =>
                    _cubit.doIntent(const ReadAllNotificationsIntent()),
                icon: Icon(
                  Icons.done_all_rounded,
                  color: ColorManager.primary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, NotificationStates>(
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                enabled: true,
                effect: ShimmerEffect(
                  baseColor: ColorManager.lightGrey.withValues(alpha: 0.15),
                  highlightColor: ColorManager.white.withValues(alpha: 0.6),
                  duration: const Duration(milliseconds: 1200),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _skeletonCount,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (_, __) => const NotificationSkeletonCard(),
                ),
              );
            }

            if (state.errorMessage != null &&
                (state.data?.notifications?.isEmpty ?? true)) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: ColorManager.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: ColorManager.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          _cubit.doIntent(const GetNotificationsIntent()),
                      child: Text(UiConstants.retry),
                    ),
                  ],
                ),
              );
            }

            final notifications = state.data?.notifications ?? [];
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: ColorManager.black,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      UiConstants.noNotifications,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.black,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: ColorManager.primary,
              onRefresh: () async =>
                  _cubit.doIntent(const GetNotificationsIntent()),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: notifications.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == notifications.length) {
                    return Skeletonizer(
                      enabled: true,
                      effect: ShimmerEffect(
                        baseColor: ColorManager.lightGrey.withValues(
                          alpha: 0.15,
                        ),
                        highlightColor: ColorManager.white.withValues(
                          alpha: 0.6,
                        ),
                        duration: const Duration(milliseconds: 1200),
                      ),
                      child: const NotificationSkeletonCard(),
                    );
                  }

                  final notification = notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: notification.id != null
                        ? () => _cubit.doIntent(
                            ReadNotificationIntent(
                              id: notification.id!,
                              referenceId: notification.referenceId,
                              type: notification.type,
                            ),
                          )
                        : null,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

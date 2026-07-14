import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/data/data_sources/local/login_local_data_source.dart';
import 'package:tribe_up/features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_ui_intents.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/chat_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/groups_screen.dart';
import 'package:tribe_up/features/notification/presentation/view/screens/notification_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/app_bar_feed.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/feed_nav_bar.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/feed_posts_list.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/menu_drawer.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/sliding_drawer_wrapper.dart';
import 'package:tribe_up/core/services/signalr/notification_signalr_service.dart';
import 'package:tribe_up/core/widgets/in_app_notification_banner.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:go_router/go_router.dart';

class FeedScreen extends StatelessWidget {
  final UserSummaryEntity? userSummary;

  const FeedScreen({super.key, this.userSummary});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>(create: (_) => getIt<FeedCubit>()),
        BlocProvider<LogoutCubit>(create: (_) => getIt<LogoutCubit>()),
      ],
      child: FeedScreenContent(userSummary: userSummary),
    );
  }
}

class FeedScreenContent extends StatefulWidget {
  final UserSummaryEntity? userSummary;

  const FeedScreenContent({super.key, this.userSummary});

  @override
  State<FeedScreenContent> createState() => _FeedScreenContentState();
}

class _FeedScreenContentState extends State<FeedScreenContent> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<SlidingDrawerWrapperState> _drawerKey =
      GlobalKey<SlidingDrawerWrapperState>();
  bool _isAppBarVisible = true;
  double _lastScrollOffset = 0;
  StreamSubscription<FeedUiIntents>? _uiIntentSub;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<FeedCubit>();
    if (widget.userSummary == null) {
      cubit.doIntent(const LoadUserSummaryIntent());
    }
    cubit.doIntent(const LoadFeedIntent());

    _uiIntentSub = cubit.uiIntents.listen(_handleUiIntent);
    _scrollController.addListener(_onScroll);
  }

  void _handleUiIntent(FeedUiIntents intent) {
    if (!mounted) return;
    switch (intent) {
      case ShowSuccessUiIntent(:final message):
        UIUtils.showPremiumMessage(context, message);
      case ShowErrorUiIntent(:final message):
        UIUtils.showPremiumMessage(
          context,
          message,
          backgroundColor: ColorManager.red,
        );
      case ShowDeletePostDialogUiIntent():
      case ShowLoadingUiIntent():
      case NavigateToDetailUiIntent():
        break;
    }
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if ((offset - _lastScrollOffset).abs() > 5) {
      if (offset > _lastScrollOffset && offset > 50) {
        if (_isAppBarVisible) setState(() => _isAppBarVisible = false);
      } else if (offset < _lastScrollOffset) {
        if (!_isAppBarVisible) setState(() => _isAppBarVisible = true);
      }
      _lastScrollOffset = offset;
    }
  }

  @override
  void dispose() {
    _uiIntentSub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppNotificationOverlay(
      notificationStream:
          getIt<NotificationSignalRService>().onNotificationReceived,
      onNotificationTap: (notification) {
        final referenceId = notification.referenceId;
        final type = notification.type?.toLowerCase() ?? '';
        if (referenceId != null) {
          final showComments = type.contains('comment');
          context.pushNamed(
            AppRoutesConstants.postDetail,
            extra: {'postId': referenceId, 'showComments': showComments},
          );
        }
      },
      child: BlocBuilder<FeedCubit, FeedStates>(
        builder: (context, state) {
          return SlidingDrawerWrapper(
            key: _drawerKey,
            drawer: MenuDrawer(
              localDataSource: getIt<LoginLocalDataSource>(),
              userSummary: state.userSummary ?? widget.userSummary,
              onProfilePopped: () => context.read<FeedCubit>().doIntent(
                const LoadUserSummaryIntent(),
              ),
              onClose: () => _drawerKey.currentState?.close(),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  _buildCurrentScreen(state.currentTab, state),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    top:
                        (_isAppBarVisible &&
                            state.currentTab == FeedNavTab.feed)
                        ? 0
                        : -(kToolbarHeight +
                              MediaQuery.of(context).padding.top),
                    left: 0,
                    right: 0,
                    child: FeedAppBar(
                      userSummary: state.userSummary ?? widget.userSummary,
                      onMenuTap: () {
                        final drawerState = _drawerKey.currentState;
                        if (drawerState == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Drawer state is null!"),
                            ),
                          );
                        } else {
                          drawerState.toggle();
                        }
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: FeedNavBar(
                currentTab: state.currentTab,
                onTabSelected: (tab) {
                  context.read<FeedCubit>().doIntent(SelectTabIntent(tab));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentScreen(FeedNavTab tab, FeedStates state) {
    return switch (tab) {
      FeedNavTab.feed => FeedPostsList(
        state: state,
        scrollController: _scrollController,
        currentUserProfilePicture:
            (state.userSummary ?? widget.userSummary)?.profilePicture,
      ),
      FeedNavTab.groups => const GroupsScreen(),
      FeedNavTab.notifications => const NotificationsScreen(),
      FeedNavTab.chat => const ChatScreen(),
    };
  }
}

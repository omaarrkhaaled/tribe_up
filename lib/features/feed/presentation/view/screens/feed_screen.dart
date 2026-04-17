import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_states.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/chat_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/groups_screen.dart';
import 'package:tribe_up/features/notification/presentation/view/screens/notification_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/search_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/app_bar_feed.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/feed_nav_bar.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/feed_posts_list.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/menu_drawer.dart';

class FeedScreen extends StatelessWidget {
  final UserSummaryEntity? userSummary;

  const FeedScreen({super.key, this.userSummary});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>(create: (context) => getIt<FeedCubit>()),
        BlocProvider<LogoutCubit>(create: (context) => getIt<LogoutCubit>()),
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
  bool _isAppBarVisible = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().doIntent(const LoadFeedIntent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentScrollOffset = _scrollController.offset;
    // Only trigger if scrolled more than 5 pixels to avoid jitter
    if ((currentScrollOffset - _lastScrollOffset).abs() > 5) {
      if (currentScrollOffset > _lastScrollOffset && currentScrollOffset > 50) {
        // Scrolling down & past threshold - hide app bar
        if (_isAppBarVisible) {
          setState(() => _isAppBarVisible = false);
        }
      } else if (currentScrollOffset < _lastScrollOffset) {
        // Scrolling up - show app bar
        if (!_isAppBarVisible) {
          setState(() => _isAppBarVisible = true);
        }
      }
      _lastScrollOffset = currentScrollOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedStates>(
      builder: (context, state) {
        return Scaffold(
          drawer: MenuDrawer(userSummary: widget.userSummary),
          body: Stack(
            children: [
              _buildCurrentScreen(state.currentTab, state),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                top: (_isAppBarVisible && state.currentTab == FeedNavTab.feed)
                    ? 0
                    : -(kToolbarHeight + MediaQuery.of(context).padding.top),
                left: 0,
                right: 0,
                child: FeedAppBar(userSummary: widget.userSummary),
              ),
            ],
          ),
          bottomNavigationBar: FeedNavBar(
            currentTab: state.currentTab,
            onTabSelected: (tab) {
              context.read<FeedCubit>().doIntent(SelectTabIntent(tab));
            },
          ),
        );
      },
    );
  }

  Widget _buildCurrentScreen(FeedNavTab tab, FeedStates state) {
    return switch (tab) {
      FeedNavTab.feed => FeedPostsList(
        state: state,
        scrollController: _scrollController,
        currentUserProfilePicture: widget.userSummary?.profilePicture,
      ),
      FeedNavTab.search => const SearchScreen(),
      FeedNavTab.groups => const GroupsScreen(),
      FeedNavTab.notifications => const NotificationsScreen(),
      FeedNavTab.chat => const ChatScreen(),
    };
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_cubit.dart';
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
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/feed/presentation/view/widgets/menu_drawer.dart';

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
  bool _isAppBarVisible = true;
  double _lastScrollOffset = 0;
  UserSummaryEntity? _userSummary;
  StreamSubscription<FeedUiIntents>? _uiIntentSub;

  @override
  void initState() {
    super.initState();
    _userSummary = widget.userSummary;
    if (_userSummary == null) _loadUserSummary();

    final cubit = context.read<FeedCubit>();
    cubit.doIntent(const LoadFeedIntent());

    _uiIntentSub = cubit.uiIntents.listen(_handleUiIntent);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadUserSummary() async {
    final model = await getIt<LoginLocalDataSource>().getUserSummary();
    if (model != null && mounted) {
      setState(() => _userSummary = model.toEntity());
    }
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
    return BlocBuilder<FeedCubit, FeedStates>(
      builder: (context, state) {
        return Scaffold(
          drawer: MenuDrawer(
            localDataSource: getIt<LoginLocalDataSource>(),
            userSummary: _userSummary,
          ),
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
                child: FeedAppBar(userSummary: _userSummary),
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
        currentUserProfilePicture: _userSummary?.profilePicture,
      ),
      FeedNavTab.groups => const GroupsScreen(),
      FeedNavTab.notifications => const NotificationsScreen(),
      FeedNavTab.chat => const ChatScreen(),
    };
  }
}

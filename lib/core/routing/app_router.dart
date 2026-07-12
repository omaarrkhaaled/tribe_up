import 'package:go_router/go_router.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/bloc/auth/auth_cubit.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/features/auth/presentation/screens/change_password/change_password_screen.dart';
import 'package:tribe_up/features/auth/presentation/screens/forget_password/forget_pasword_screen.dart';
import 'package:tribe_up/features/auth/presentation/screens/sign_up/verify_email_screen.dart';
import 'package:tribe_up/features/auth/presentation/screens/login/login_screen.dart';
import 'package:tribe_up/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/feed_screen.dart';
import 'package:tribe_up/features/edit_profile/presentation/view/screens/edit_profile_screen.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/screens/tribe_profile_screen.dart';
import 'package:tribe_up/features/notification/presentation/view/screens/notification_screen.dart';
import 'package:tribe_up/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:tribe_up/features/group_chat/presentation/view/screens/group_chat_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/post_detail_screen.dart';
import 'package:tribe_up/features/settings/presentation/view/screens/settings_screen.dart';
import 'package:tribe_up/features/groups/presentation/view/screens/leaderboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_cubit.dart';
import 'package:tribe_up/features/groups/presentation/view_model/leaderboard/leaderboard_intents.dart';
import 'package:tribe_up/features/polls/presentation/view/screens/polls_groups_screen.dart';
import 'package:tribe_up/features/polls/presentation/view/screens/group_polls_screen.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutesConstants.login,
    refreshListenable: getIt<AuthCubit>(),
    redirect: (context, state) {
      final authStatus = getIt<AuthCubit>().state.status;
      final isLogin = state.matchedLocation == AppRoutesConstants.login;

      if (authStatus == AuthStatus.authenticated && isLogin) {
        return AppRoutesConstants.feed;
      }
      if (authStatus == AuthStatus.unauthenticated && !isLogin) {
        // If they need to be logged in but are not, redirect to login
        // But only if it's a protected route. For now, assume all routes except login/signup are protected
        if (state.matchedLocation != AppRoutesConstants.signUp &&
            state.matchedLocation != AppRoutesConstants.forgetPassword) {
          return AppRoutesConstants.login;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutesConstants.signUp,
        name: AppRoutesConstants.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.feed,
        name: AppRoutesConstants.feed,
        builder: (context, state) => FeedScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.login,
        name: AppRoutesConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.changePassword,
        name: AppRoutesConstants.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.forgetPassword,
        name: AppRoutesConstants.forgetPassword,
        builder: (context, state) => const ForgetPaswordScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.verifyEmail,
        name: AppRoutesConstants.verifyEmail,
        builder: (context, state) =>
            VerifyEmailScreen(email: state.extra as String),
      ),
      GoRoute(
        path: AppRoutesConstants.editProfile,
        name: AppRoutesConstants.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.profile,
        name: AppRoutesConstants.profile,
        builder: (context, state) =>
            ProfileScreen(userName: state.extra as String?),
      ),
      GoRoute(
        path: AppRoutesConstants.tribeProfile,
        name: AppRoutesConstants.tribeProfile,
        builder: (context, state) =>
            TribeProfileScreen(group: state.extra as Group?),
      ),
      GoRoute(
        path: AppRoutesConstants.groupChat,
        name: AppRoutesConstants.groupChat,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return GroupChatScreen(
            groupId: extra['groupId'] as int,
            groupName: extra['groupName'] as String,
            groupPicture: extra['groupPicture'] as String?,
            currentUserId: extra['currentUserId'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutesConstants.postDetail,
        name: AppRoutesConstants.postDetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PostDetailScreen(
            postId: extra['postId'] as int,
            showComments: extra['showComments'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: AppRoutesConstants.settings,
        name: AppRoutesConstants.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.leaderboard,
        name: AppRoutesConstants.leaderboard,
        builder: (context, state) => BlocProvider(
          create: (_) =>
              getIt<LeaderboardCubit>()..doIntent(LoadLeaderboardIntent()),
          child: const LeaderboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutesConstants.notifications,
        name: AppRoutesConstants.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.pollsGroups,
        name: AppRoutesConstants.pollsGroups,
        builder: (context, state) => const PollsGroupsScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.groupPolls,
        name: AppRoutesConstants.groupPolls,
        builder: (context, state) =>
            GroupPollsScreen(group: state.extra as Group),
      ),
    ],
  );
}

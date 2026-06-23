import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/network/device_id_manager.dart';
import 'package:tribe_up/features/auth/change_password/presentation/screens/change_password_screen.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/view/forget_pasword_screen.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/view/verify_email_screen.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/login/domain/use_cases/refresh_token_use_case.dart';
import 'package:tribe_up/features/auth/login/presentation/view/screens/login_screen.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/screens/sign_up_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/feed_screen.dart';
import 'package:tribe_up/features/edit_profile/presentation/view/screens/edit_profile_screen.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/presentation/view/screens/tribe_profile_screen.dart';
import 'package:tribe_up/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:tribe_up/features/group_chat/presentation/view/screens/group_chat_screen.dart';
import 'package:tribe_up/features/feed/presentation/view/screens/post_detail_screen.dart';
import 'package:tribe_up/features/settings/presentation/view/screens/settings_screen.dart';
import 'package:tribe_up/features/groups/presentation/view/screens/leaderboard_screen.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutesConstants.login,
    redirect: (context, state) async {
      if (state.matchedLocation != AppRoutesConstants.login) return null;
      final localDataSource = getIt<LoginLocalDataSource>();
      final String? accessToken = await localDataSource.getAccessToken();
      if (accessToken == null) return null;
      if (!JwtDecoder.isExpired(accessToken)) {
        return AppRoutesConstants.feed;
      }
      final String? refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken == null) return AppRoutesConstants.login;
      final deviceId = getIt<DeviceIdManager>().deviceId;
      final result = await getIt<RefreshTokenUseCase>().call(
        refreshToken: refreshToken,
        deviceId: deviceId,
      );
      return switch (result) {
        SuccessResponse() => AppRoutesConstants.feed,
        ErrorResponse() => AppRoutesConstants.login,
      };
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
        builder: (context, state) => const LeaderboardScreen(),
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/features/auth/change_password/presentation/screens/change_password_screen.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/view/forget_pasword_screen.dart';
import 'package:tribe_up/features/auth/forget_password/presentation/view/verify_email_screen.dart';
import 'package:tribe_up/features/auth/login/presentation/view/screens/login_screen.dart';
import 'package:tribe_up/features/auth/sign_up/presentation/view/screens/sign_up_screen.dart';
import 'package:tribe_up/feed_screen.dart';
import 'package:tribe_up/splash_screen.dart';
import 'package:tribe_up/welcome_screen.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutesConstants.welcome,
    routes: [
      GoRoute(
        path: AppRoutesConstants.splash,
        name: AppRoutesConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.welcome,
        name: AppRoutesConstants.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.signUp,
        name: AppRoutesConstants.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutesConstants.feed,
        name: AppRoutesConstants.feed,
        builder: (context, state) => const FeedScreen(),
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
    ],
  );
}

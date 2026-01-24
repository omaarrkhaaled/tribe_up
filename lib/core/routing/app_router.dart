import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
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
    ],
  );
}

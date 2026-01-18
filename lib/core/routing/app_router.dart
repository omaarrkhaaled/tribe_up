import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
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
    ],
  );
}

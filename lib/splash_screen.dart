import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tribe_up/core/resources/assets_managar.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _lottieController;
  late final AnimationController _gradientController;
  late final AnimationController _fadeController;

  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _gradientController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(ColorManager.purpleDark, ColorManager.purpleMain,
                      _gradientController.value)!,
                  ColorManager.purpleSoft,
                ],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Lottie.asset(
                  AnimationAssets.welcomeAnimation,
                  controller: _lottieController,
                  repeat: false,
                  onLoaded: (composition) {
                    _lottieController.duration = composition.duration;
                    _lottieController.forward().whenComplete(() {
                      _fadeController.forward().whenComplete(_goNext);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

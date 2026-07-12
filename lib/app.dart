import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tribe_up/core/routing/app_router.dart';
import 'package:tribe_up/core/utils/app_theme.dart';

class TribeUpApp extends StatelessWidget {
  const TribeUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      builder: EasyLoading.init(),
    );
  }
}

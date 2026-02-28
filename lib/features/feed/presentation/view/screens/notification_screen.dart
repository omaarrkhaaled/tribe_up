import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoutesConstants.changePassword);
        },
        child: const Text('Go to Change Password'),
      ),
    );
  }
}

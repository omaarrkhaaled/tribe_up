import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.pushNamed(AppRoutesConstants.editProfile);
        },
        child: const Text('go To Edit Profile'),
      ),
    );
  }
}

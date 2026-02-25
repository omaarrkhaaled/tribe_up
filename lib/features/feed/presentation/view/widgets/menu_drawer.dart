import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_cubit.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_intents.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_ui_intents.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late StreamSubscription _logoutSubscription;
  @override
  void initState() {
    super.initState();
    _logoutSubscription = context.read<LogoutCubit>().uiIntents.listen((
      intent,
    ) {
      if (!mounted) return;
      switch (intent) {
        case ShowLoadingIntents():
          UIUtils.showDotLottieLoadingOverlay(context);
        case ShowErrorIntents():
          UIUtils.showPremiumMessage(
            context,
            intent.message,
            backgroundColor: ColorManager.red,
          );
        case NavigateToLoginIntent():
          context.go(AppRoutesConstants.login);
      }
    });
  }

  @override
  void dispose() {
    _logoutSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: ColorManager.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  UiConstants.back,
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(radius: 24, child: const Icon(Icons.person)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alex Johnson',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '@alexj',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.user,
            title: UiConstants.profile,
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.bell,
            title: UiConstants.notification,
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.magnifyingGlass,
            title: UiConstants.search,
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.gear,
            title: UiConstants.setting,
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.users,
            title: UiConstants.myTribes,
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.paperPlane,
            title: UiConstants.chat,
            onTap: () {},
          ),

          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.rightFromBracket,
            title: UiConstants.logout,
            onTap: () {
              UIUtils.showPremiumDialog(
                context: context,
                message: UiConstants.areYouSureYouWantToLogout,
                posAction: () {
                  context.read<LogoutCubit>().doIntent(LogoutIntent());
                },
                negAction: () {
                  Navigator.pop(context);
                },
                posActionName: UiConstants.yes,
                negActionName: UiConstants.no,
              );
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null, size: 21),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

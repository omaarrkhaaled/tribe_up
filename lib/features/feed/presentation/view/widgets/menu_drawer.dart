import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:tribe_up/core/utils/ui_utils.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_local_data_source.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_cubit.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_intents.dart';
import 'package:tribe_up/features/auth/logout/presentation/logout_ui_intents.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:tribe_up/features/feed/presentation/cubit/feed_intents.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MenuDrawer extends StatefulWidget {
  final LoginLocalDataSource localDataSource;
  final UserSummaryEntity? userSummary;
  final VoidCallback? onProfilePopped;

  const MenuDrawer({
    super.key,
    required this.localDataSource,
    this.userSummary,
    this.onProfilePopped,
  });

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late StreamSubscription _logoutSubscription;
  late Future<UserSummaryEntity?> _userSummaryFuture;

  @override
  void initState() {
    super.initState();
    if (widget.userSummary != null) {
      _userSummaryFuture = Future.value(widget.userSummary);
    } else {
      _userSummaryFuture = widget.localDataSource.getUserSummary().then(
        (model) => model?.toEntity(),
      );
    }
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

  void _navigateAndClose(void Function(GoRouter) action) {
    final router = GoRouter.of(context);
    Navigator.pop(context);
    action(router);
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
          FutureBuilder<UserSummaryEntity?>(
            future: _userSummaryFuture,
            builder: (context, snapshot) {
              final user = snapshot.data;
              return InkWell(
                onTap: () {
                  _navigateAndClose((router) {
                    router
                        .pushNamed(
                          AppRoutesConstants.profile,
                          extra: user?.userName,
                        )
                        .then((_) => widget.onProfilePopped?.call());
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: user?.profilePicture != null
                              ? CachedNetworkImage(
                                  imageUrl: user!.profilePicture!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        FontAwesomeIcons.solidUser,
                                        size: 20,
                                      ),
                                )
                              : const Icon(FontAwesomeIcons.solidUser),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Alex Johnson',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user?.userName != null
                                  ? '@${user!.userName}'
                                  : 'loading...',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.solidUser,
            title: UiConstants.profile,
            onTap: () => _navigateAndClose(
              (router) => router
                  .pushNamed(AppRoutesConstants.profile)
                  .then((_) => widget.onProfilePopped?.call()),
            ),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.solidBell,
            title: UiConstants.notification,
            onTap: () => _navigateAndClose((_) {
              context.read<FeedCubit>().doIntent(
                SelectTabIntent(FeedNavTab.notifications),
              );
            }),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.trophy,
            title: 'Leaderboard',
            onTap: () => _navigateAndClose(
              (router) => router.pushNamed(AppRoutesConstants.leaderboard),
            ),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.gear,
            title: UiConstants.setting,
            onTap: () => _navigateAndClose(
              (router) => router.pushNamed(AppRoutesConstants.settings),
            ),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.users,
            title: UiConstants.myTribes,
            onTap: () => _navigateAndClose((_) {
              context.read<FeedCubit>().doIntent(
                SelectTabIntent(FeedNavTab.groups),
              );
            }),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.solidPaperPlane,
            title: UiConstants.chat,
            onTap: () => _navigateAndClose((_) {
              context.read<FeedCubit>().doIntent(
                SelectTabIntent(FeedNavTab.chat),
              );
            }),
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

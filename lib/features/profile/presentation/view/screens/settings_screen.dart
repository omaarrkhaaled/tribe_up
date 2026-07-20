import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tribe_up/core/constants/app_routes_constants.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/resources/color_manager.dart';
import 'package:tribe_up/features/profile/presentation/view/widgets/setting_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UiConstants.setting)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildSectionTitle(context, 'Account'),
            _buildCard(context, [
              SettingRow(
                icon: Icons.person_outline_rounded,
                title: UiConstants.editProfile,
                onTap: () => context.pushNamed(AppRoutesConstants.editProfile),
              ),
              _buildDivider(),
              SettingRow(
                icon: Icons.lock_outline_rounded,
                title: UiConstants.changePassword,
                onTap: () =>
                    context.pushNamed(AppRoutesConstants.changePassword),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle(context, UiConstants.preferences),
            _buildCard(context, [
              SettingRow(
                icon: Icons.notifications_outlined,
                title: UiConstants.notification,
                onTap: () {
                  context.pushNamed(AppRoutesConstants.notifications);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: ColorManager.grey,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 66,
      color: ColorManager.lightGrey.withValues(alpha: 0.2),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/settings_tab.dart';
import 'package:tribe_up/core/resources/color_manager.dart';

class SettingTabBar extends StatelessWidget {
  final SettingsTab currentTab;
  final ValueChanged<SettingsTab> onTabSelected;

  const SettingTabBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorManager.lightGrey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: SettingsTab.values
            .map(
              (tab) => Expanded(
                child: GestureDetector(
                  onTap: () => onTabSelected(tab),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: currentTab == tab
                          ? ColorManager.white
                          : ColorManager.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: currentTab == tab
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      _label(tab),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: currentTab == tab
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: currentTab == tab
                            ? ColorManager.black
                            : ColorManager.grey,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  String _label(SettingsTab tab) {
    return switch (tab) {
      SettingsTab.general => UiConstants.general,
      SettingsTab.members => UiConstants.members,
      SettingsTab.followers => UiConstants.followers,
    };
  }
}

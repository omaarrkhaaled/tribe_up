import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';
import 'package:tribe_up/core/enums/feed_nav_tab.dart';
import 'package:tribe_up/core/resources/color_managar.dart';

class FeedNavBar extends StatelessWidget {
  final FeedNavTab currentTab;
  final Function(FeedNavTab) onTabSelected;

  const FeedNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorManager.white,
      currentIndex: currentTab.index,
      selectedItemColor: ColorManager.black,
      unselectedItemColor: ColorManager.lightGrey,
      iconSize: 22,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) => onTabSelected(FeedNavTab.values[index]),
      items: [
        _buildNavItem(
          icon: FontAwesomeIcons.house,
          activeIcon: FontAwesomeIcons.solidHouse,
          label: UiConstants.feed,
        ),
        _buildNavItem(
          icon: FontAwesomeIcons.users,
          activeIcon: FontAwesomeIcons.users,
          label: UiConstants.groups,
        ),
        _buildNavItem(
          icon: FontAwesomeIcons.bell,
          activeIcon: FontAwesomeIcons.solidBell,
          label: UiConstants.notifications,
        ),
        _buildNavItem(
          icon: FontAwesomeIcons.paperPlane,
          activeIcon: FontAwesomeIcons.solidPaperPlane,
          label: UiConstants.chat,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: FaIcon(icon),
      label: label,
      activeIcon: FaIcon(activeIcon),
    );
  }
}

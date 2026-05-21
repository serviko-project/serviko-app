import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

// Bottom Navigation Tab
class NavTab {
  final dynamic icon;
  final String label;

  const NavTab({required this.icon, required this.label});
}

// Bottom Navigation Shell
class AppBottomNavShell extends StatelessWidget {
  const AppBottomNavShell({
    super.key,
    required this.navigationShell,
    required this.tabs,
  });

  final StatefulNavigationShell navigationShell;
  final List<NavTab> tabs;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textHint,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              iconSize: 26,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: tabs
                  .map((tab) => _buildNavItem(tab.icon, tab.label))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Build each BottomNavigationBarItem
  BottomNavigationBarItem _buildNavItem(dynamic icon, String label) {
    final isInbox = label == 'Inbox';
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.sm),
        child: _buildIconWithBadge(icon, AppColors.textHint, isInbox),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.sm),
        child: _buildIconWithBadge(icon, AppColors.primary, isInbox),
      ),
      label: label,
    );
  }

  // Build icon with unread badge if inbox tab
  Widget _buildIconWithBadge(dynamic icon, Color color, bool isInbox) {
    final iconWidget = HugeIcon(
      icon: icon,
      color: color,
      size: 26,
      strokeWidth: 1.5,
    );

    if (!isInbox) {
      return iconWidget;
    }

    return ValueListenableBuilder<int>(
      valueListenable: ZIMKit().getTotalUnreadMessageCount(),
      builder: (context, count, child) {
        if (count == 0) return iconWidget;
        final badgeText = count > 99 ? '99+' : '$count';
        return Stack(
          clipBehavior: Clip.none,
          children: [
            iconWidget,

            // Unread badge
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.background, width: 1.5),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

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
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: HugeIcon(
          icon: icon,
          color: AppColors.textHint,
          size: 26,
          strokeWidth: 1.5,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: HugeIcon(
          icon: icon,
          color: AppColors.primary,
          size: 26,
          strokeWidth: 1.5,
        ),
      ),
      label: label,
    );
  }
}

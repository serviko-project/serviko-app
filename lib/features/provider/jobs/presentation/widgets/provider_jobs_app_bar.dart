import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class ProviderJobsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> statuses;

  const ProviderJobsAppBar({
    super.key,
    required this.tabController,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "My Jobs",
        style: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        tabs: statuses.map((s) => Tab(text: s.toUpperCase())).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}

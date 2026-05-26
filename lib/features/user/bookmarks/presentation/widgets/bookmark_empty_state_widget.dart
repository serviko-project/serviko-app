import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class BookmarksEmptyState extends StatelessWidget {
  const BookmarksEmptyState({super.key, this.categoryName});

  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppAssets.notFoundAnimation,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'No Bookmarks Found..!!',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                categoryName != null
                    ? 'No bookmarked services found in the category "$categoryName".'
                    : "You haven't added any services to your bookmarks yet.",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

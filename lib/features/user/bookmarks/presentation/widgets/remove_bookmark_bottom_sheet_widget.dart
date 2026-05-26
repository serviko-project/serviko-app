import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Reusable bottom sheet widget for confirming bookmark removal
class RemoveBookmarkBottomSheetWidget extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onRemoveConfirm;

  const RemoveBookmarkBottomSheetWidget({
    super.key,
    required this.service,
    required this.onRemoveConfirm,
  });

  static void show(
    BuildContext context, {
    required ServiceEntity service,
    required VoidCallback onRemoveConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) => RemoveBookmarkBottomSheetWidget(
        service: service,
        onRemoveConfirm: onRemoveConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Confirmation Text
            Text(
              'Remove from Bookmark ?',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),

            // Service Card Preview
            ServiceCard(
              bannerImage: service.bannerImage,
              categoryIcon: service.categoryIcon,
              providerName: service.providerName,
              categoryName: service.categoryName,
              price: service.basePricePerHour,
              rating: service.rating,
              reviews: service.reviewsCount,
              isBookmarked: true,
              onBookmarkTap: null,
            ),
            const SizedBox(height: AppSizes.lg),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: AppColors.primary.withAlpha(25),
                    textColor: AppColors.primary,
                    borderRadius: AppSizes.radiusXl,
                    height: 48,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: CustomButton(
                    text: 'Yes, Remove',
                    onPressed: () {
                      onRemoveConfirm();
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.background,
                    borderRadius: AppSizes.radiusXl,
                    height: 48,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

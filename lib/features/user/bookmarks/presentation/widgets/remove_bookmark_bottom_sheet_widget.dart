import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';

// Reusable bottom sheet widget for confirming bookmark removal
class RemoveBookmarkBottomSheetWidget extends StatelessWidget {
  const RemoveBookmarkBottomSheetWidget({super.key});

  static void show(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) => RemoveBookmarkBottomSheetWidget(),
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
              imageUrl:
                  "https://imgs.search.brave.com/UveizRxweFrraMwnNtB7kFdENT_6dhwB5FpySUMnm3I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wbHVz/LnVuc3BsYXNoLmNv/bS9wcmVtaXVtX3Bo/b3RvLTE2NjEzMzM0/NDU5NDEtOTUzMTcz/OWU1NGUwP2ZtPWpw/ZyZxPTYwJnc9MzAw/MCZhdXRvPWZvcm1h/dCZmaXQ9Y3JvcCZp/eGxpYj1yYi00LjEu/MCZpeGlkPU0zd3hN/akEzZkRCOE1IeHpa/V0Z5WTJoOE9YeDhj/bVZ3WVdseUpUSXdj/MlZ5ZG1salpYeGxi/bnd3Zkh3d2ZIeDhN/QT09",
              providerName: 'Provider Name',
              categories: const ['Category 1', 'Category 2'],
              price: 100,
              rating: 4.5,
              reviews: 100,
              isBookmarked: true,
              onBookmarkTap: null,
            ),
            const SizedBox(height: AppSizes.lg),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary.withAlpha(25),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes, Remove',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

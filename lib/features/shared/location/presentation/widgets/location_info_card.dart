import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Displays address with loading state and re-center action
class LocationInfoCard extends StatelessWidget {
  final String? address;
  final bool isLoading;
  final VoidCallback? onRecenter;

  const LocationInfoCard({
    super.key,
    this.address,
    this.isLoading = false,
    this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withAlpha(150)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary.withAlpha(200),
                    ),
                  )
                : Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primary.withAlpha(200),
                    size: 20,
                  ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading ? 'Detecting Location...' : 'Selected Location',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (!isLoading)
                  Text(
                    address ?? 'Tap on the map to pick a location',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onRecenter != null && !isLoading)
            IconButton(
              onPressed: onRecenter,
              icon: const Icon(Icons.gps_fixed_rounded),
              color: AppColors.primary,
              tooltip: 'Re-center to GPS',
              iconSize: 20,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

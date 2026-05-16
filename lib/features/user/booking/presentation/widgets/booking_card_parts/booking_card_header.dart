import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/enums/booking_status.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../booking_status_tag.dart';

class BookingCardHeader extends StatelessWidget {
  final String? providerImage;
  final String? providerName;
  final String? categoryName;
  final BookingStatus status;

  const BookingCardHeader({
    super.key,
    this.providerImage,
    this.providerName,
    this.categoryName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Provider Image
        Skeleton.replace(
          width: 48,
          height: 48,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              image: providerImage != null
                  ? DecorationImage(
                      image: NetworkImage(providerImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: providerImage == null
                ? const HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    color: AppColors.textSecondary,
                    size: 24,
                  )
                : null,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        // Provider Name and Category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                providerName ?? 'Unknown Provider',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                categoryName ?? 'Service',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        BookingStatusTag(status: status),
      ],
    );
  }
}

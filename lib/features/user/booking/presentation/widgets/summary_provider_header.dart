import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_request_payload.dart';

class SummaryProviderHeader extends StatelessWidget {
  final BookingRequestPayload payload;

  const SummaryProviderHeader({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              image: payload.initData.providerImage != null
                  ? DecorationImage(
                      image: NetworkImage(payload.initData.providerImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: payload.initData.providerImage == null
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payload.initData.providerName, style: AppTextStyles.h3),
                Text(
                  payload.initData.categoryName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

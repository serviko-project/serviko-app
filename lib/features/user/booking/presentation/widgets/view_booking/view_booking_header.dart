import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

class ViewBookingHeader extends StatelessWidget {
  final BookingEntity booking;

  const ViewBookingHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            image: booking.providerImage != null
                ? DecorationImage(
                    image: NetworkImage(booking.providerImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: booking.providerImage == null
              ? const HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: AppColors.textSecondary,
                )
              : null,
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.providerName ?? 'Unknown Provider',
                style: AppTextStyles.h3,
              ),
              Text(
                booking.categoryName ?? 'Service',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedChat01,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

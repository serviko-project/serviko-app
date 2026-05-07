import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';

// Bottom bar with Message and Book Now buttons
class ServiceBottomBar extends StatelessWidget {
  final VoidCallback? onMessageTap;
  final VoidCallback? onBookNowTap;

  const ServiceBottomBar({super.key, this.onMessageTap, this.onBookNowTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.screenPadding,
        right: AppSizes.screenPadding,
        top: AppSizes.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message button
          Expanded(
            child: CustomButton(
              text: 'Message',
              isOutlined: true,
              onPressed: onMessageTap,
            ),
          ),
          const SizedBox(width: AppSizes.md),

          // Book Now button
          Expanded(
            child: CustomButton(text: 'Book Now', onPressed: onBookNowTap),
          ),
        ],
      ),
    );
  }
}

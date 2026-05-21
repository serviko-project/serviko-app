import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/provider_chat_button.dart';

// Bottom bar with Service Name,Price, Message and Book Now buttons
class ServiceBottomBar extends StatelessWidget {
  final String serviceName;
  final double price;
  final String providerId;
  final String? providerFirebaseUid;
  final String? providerName;
  final String? providerImage;
  final VoidCallback? onBookNowTap;

  const ServiceBottomBar({
    super.key,
    required this.serviceName,
    required this.price,
    required this.providerId,
    this.providerFirebaseUid,
    this.providerName,
    this.providerImage,
    this.onBookNowTap,
  });

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
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLg),
          topRight: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      child: Row(
        children: [
          // Price Info
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹${price.toStringAsFixed(0)}',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: ' / hr',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),

          // Message button
          ProviderChatButton(
            providerId: providerId,
            providerFirebaseUid: providerFirebaseUid,
            providerName: providerName,
            providerImage: providerImage,
            categoryName: serviceName,
          ),
          const SizedBox(width: AppSizes.sm),

          // Book Now button
          Expanded(
            flex: 3,
            child: CustomButton(text: 'Book Now', onPressed: onBookNowTap),
          ),
        ],
      ),
    );
  }
}

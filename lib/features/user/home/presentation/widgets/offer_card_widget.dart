import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/promo_card_painter.dart';

class OfferCardWidget extends StatelessWidget {
  final PromoCode promo;
  final int index;

  static const double cardHeight = 165;

  const OfferCardWidget({super.key, required this.promo, required this.index});

  @override
  Widget build(BuildContext context) {
    final indexMod = index % AppColors.themeColors.length;
    final backgroundColor = AppColors.cardBackgrounds[indexMod];
    final borderColor = AppColors.cardBorders[indexMod];
    final accentColor = AppColors.themeColors[indexMod];

    final isPercentage = promo.discountType == 'percentage';
    final discountStr = isPercentage
        ? '${promo.discountValue.toInt()}%'
        : '₹${promo.discountValue.toInt()}';

    return GestureDetector(
      onTap: () {
        if (promo.serviceId != null && promo.serviceId!.isNotEmpty) {
          context.pushNamed(AppRouter.serviceDetails, extra: promo.serviceId);
        }
      },
      child: Container(
        height: cardHeight,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.xs,
          vertical: 6.0,
        ),
        // Custom painted card with dashed border
        child: CustomPaint(
          painter: PromoCardPainter(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            dashColor: accentColor.withValues(alpha: 0.28),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
            child: Row(
              children: [
                // Info block
                Expanded(
                  flex: 13,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Discount Badge & Promo Code
                      Row(
                        children: [
                          Text(
                            discountStr,
                            style: AppTextStyles.h1.copyWith(
                              color: accentColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),

                          // Promo Code Container
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.09),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Text(
                                promo.code,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Provider Name
                      Text(
                        promo.providerName ?? "Today's Special!",
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Description
                      Text(
                        promo.description ??
                            'Get a premium discount, valid for a limited time.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.lg),

                // Circular Avatar
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.09),
                    ),
                    padding: const EdgeInsets.all(AppSizes.xs),
                    child:
                        promo.providerImageUrl != null &&
                            promo.providerImageUrl!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: promo.providerImageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                    color: accentColor,
                                    strokeWidth: 2,
                                  ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.discount,
                                color: accentColor,
                                size: 28,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.percent_rounded,
                            color: accentColor,
                            size: 28,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

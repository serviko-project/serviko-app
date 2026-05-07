import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

// Service Banner
class ServiceCoverImage extends StatelessWidget {
  final VoidCallback? onBookmarkTap;
  final int serviceIndex;

  const ServiceCoverImage({
    super.key,
    this.onBookmarkTap,
    required this.serviceIndex,
  });

  static const double _bannerHeight = 280;
  static const double _avatarRadius = 45;
  static const double totalHeight = _bannerHeight + _avatarRadius + 8;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner
          Container(
            width: double.infinity,
            height: _bannerHeight,
            decoration: const BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.radiusXl),
                bottomRight: Radius.circular(AppSizes.radiusXl),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image_rounded,
                size: 64,
                color: AppColors.textHint,
              ),
            ),
          ),

          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.radiusXl),
                  bottomRight: Radius.circular(AppSizes.radiusXl),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withAlpha(80), Colors.transparent],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSizes.sm,
            left: AppSizes.md,
            child: _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),

          // Bookmark button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSizes.sm,
            right: AppSizes.md,
            child: _CircleButton(
              icon: Icons.bookmark_border_rounded,
              onTap: onBookmarkTap,
            ),
          ),

          // Provider avatar
          Positioned(
            bottom: 0,
            left: AppSizes.screenPadding,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: _avatarRadius,
                backgroundColor: AppColors.primary.withAlpha(20),
                child: Text(
                  'P${serviceIndex + 1}',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(220),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}

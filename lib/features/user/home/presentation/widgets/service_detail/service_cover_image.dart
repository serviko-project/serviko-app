import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Service Banner
class ServiceCoverImage extends StatelessWidget {
  final VoidCallback? onBookmarkTap;
  final String? imageUrl;
  final String categoryIcon;
  final String? providerImage;
  final bool isLoading;

  const ServiceCoverImage({
    super.key,
    this.onBookmarkTap,
    this.imageUrl,
    this.categoryIcon = 'category_rounded',
    this.providerImage,
    this.isLoading = false,
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
            clipBehavior: Clip.antiAlias,

            // Service Banner Image
            child: isLoading
                ? _buildFallbackBanner(isNeutral: true)
                : imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildFallbackBanner(isNeutral: true),
                    fadeInDuration: const Duration(milliseconds: 500),
                    errorWidget: (context, url, error) =>
                        _buildFallbackBanner(),
                  )
                : _buildFallbackBanner(),
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
                backgroundImage:
                    providerImage != null && providerImage!.isNotEmpty
                    ? CachedNetworkImageProvider(providerImage!)
                    : null,
                child: providerImage == null || providerImage!.isEmpty
                    ? const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 50,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackBanner({bool isNeutral = false}) {
    final Color baseColor = isNeutral
        ? AppColors.shimmerBase
        : _getCategoryColor(categoryIcon);

    return Container(
      decoration: BoxDecoration(
        gradient: isNeutral
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor,
                  baseColor.withAlpha(200),
                  baseColor.withAlpha(150),
                ],
              ),
        color: isNeutral ? AppColors.shimmerBase : null,
      ),
      child: Stack(
        children: [
          // Background large icon
          Positioned(
            right: -30,
            bottom: -30,
            child: Opacity(
              opacity: isNeutral ? 0.05 : 0.15,
              child: Icon(
                IconMapper.fromName(categoryIcon),
                size: 240,
                color: isNeutral ? AppColors.textHint : Colors.white,
              ),
            ),
          ),

          // Central icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                color: isNeutral
                    ? AppColors.background.withAlpha(100)
                    : Colors.white.withAlpha(40),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isNeutral
                      ? AppColors.border.withAlpha(150)
                      : Colors.white.withAlpha(60),
                  width: 2,
                ),
              ),
              child: Icon(
                IconMapper.fromName(categoryIcon),
                size: 56,
                color: isNeutral ? AppColors.textHint : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String iconName) {
    final int hash = iconName.codeUnits.fold(0, (prev, element) {
      return prev + element;
    });
    return AppColors.categoryPalette[hash % AppColors.categoryPalette.length];
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

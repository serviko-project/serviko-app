import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';

class ServiceCardImage extends StatelessWidget {
  final String? bannerImage;
  final String categoryIcon;
  final bool isLoading;

  const ServiceCardImage({
    super.key,
    this.bannerImage,
    required this.categoryIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: isLoading
          ? _buildShimmer()
          : bannerImage != null && bannerImage!.isNotEmpty
          ? _buildNetworkImage()
          : _buildPlaceholder(),
    );
  }

  // Build shimmer effect while loading the image
  Widget _buildShimmer() {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.shimmerBase,
      child: Center(
        child: Icon(
          IconMapper.fromName(categoryIcon),
          color: Colors.white.withAlpha(100),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: bannerImage!,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildShimmer(),
      fadeInDuration: const Duration(milliseconds: 400),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );
  }

  // Placeholder widget when no banner image is available
  Widget _buildPlaceholder() {
    final Color baseColor = _getCategoryColor(categoryIcon);
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            baseColor.withAlpha(200),
            baseColor.withAlpha(150),
          ],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(60), width: 1.5),
          ),
          child: Icon(
            IconMapper.fromName(categoryIcon),
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Generate a color
  Color _getCategoryColor(String iconName) {
    final int hash = iconName.codeUnits.fold(0, (prev, element) {
      return prev + element;
    });
    return AppColors.categoryPalette[hash % AppColors.categoryPalette.length];
  }
}

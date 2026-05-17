import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';

// Reusable category grid item
class CategoryItemWidget extends StatelessWidget {
  final int index;
  final String? title;
  final String? icon;
  final VoidCallback? onTap;

  const CategoryItemWidget({
    super.key,
    required this.index,
    this.title,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColorIndex = index % AppColors.categoryPalette.length;
    final baseColor = AppColors.categoryPalette[baseColorIndex];
    final bgColor = baseColor.withAlpha(30);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                IconMapper.fromName(icon ?? 'category_rounded'),
                color: baseColor,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            title ?? 'Category ${index + 1}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

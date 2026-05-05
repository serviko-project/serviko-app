import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:serviko_app/core/widgets/section_header.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: SectionHeader(title: 'Categories', onSeeAllTap: () {}),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

        // Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          sliver: SliverGrid.builder(
            itemCount: 7,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppSizes.sm,
              mainAxisSpacing: AppSizes.md,
            ),
            itemBuilder: (context, index) {
              return _buildCategoryItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(int index) {
    // Generate colors dynamically
    final baseColorIndex = index % AppColors.categoryPalette.length;
    final baseColor = AppColors.categoryPalette[baseColorIndex];
    final bgColor = baseColor.withAlpha(30);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Center(
            child: Icon(
              IconMapper.fromName('category_rounded'),
              color: baseColor,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          'Category ${index + 1}',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';

class SearchResultHeader extends StatelessWidget {
  final String query;
  final int totalFound;

  const SearchResultHeader({
    super.key,
    required this.query,
    required this.totalFound,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Results for ',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: '"$query"',
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            '$totalFound found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

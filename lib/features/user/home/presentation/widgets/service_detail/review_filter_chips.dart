import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_reviews_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_reviews_state.dart';

class ReviewFilterChips extends StatelessWidget {
  const ReviewFilterChips({super.key, required this.providerId});

  final String providerId;
  static const List<int?> _ratingFilters = [null, 5, 4, 3, 2, 1];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceReviewsCubit, ServiceReviewsState>(
      buildWhen: (prev, curr) => prev.selectedRating != curr.selectedRating,
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _ratingFilters.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (context, index) {
              final rating = _ratingFilters[index];
              final isSelected = state.selectedRating == rating;
              final label = rating == null ? 'All' : '$rating';

              return GestureDetector(
                onTap: () => context.read<ServiceReviewsCubit>().selectRating(
                  providerId,
                  rating,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rating != null) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

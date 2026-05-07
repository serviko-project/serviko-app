import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_detail_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_detail_state.dart';
import 'review_card.dart';

// Reviews section with filter chips and review list
class ServiceReviewsSection extends StatelessWidget {
  const ServiceReviewsSection({super.key});

  static const List<int?> _ratingFilters = [null, 5, 4, 3, 2];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text('4.8 (100 reviews)', style: AppTextStyles.h3),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Filter chips
          BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
            buildWhen: (prev, curr) =>
                prev.selectedRating != curr.selectedRating,
            builder: (context, state) {
              return SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _ratingFilters.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSizes.sm),
                  itemBuilder: (context, index) {
                    final rating = _ratingFilters[index];
                    final isSelected = state.selectedRating == rating;
                    final label = rating == null ? 'All' : '$rating';

                    return GestureDetector(
                      onTap: () => context
                          .read<ServiceDetailCubit>()
                          .selectRating(rating),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusFull,
                          ),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
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
          ),

          // Review cards list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => ReviewCard(index: index),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/filter_state.dart';
import 'filter_choice_chip.dart';
import '../../domain/models/filter_enums.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusXl),
              topRight: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.xl,
                children: [
                  _buildHandleBar(),

                  Center(
                    child: Text(
                      'Filter Options',
                      style: AppTextStyles.h2.copyWith(letterSpacing: 0.5),
                    ),
                  ),

                  _buildCategorySection(context, state),

                  _buildPriceSection(context, state),

                  _buildRatingSection(context, state),

                  _buildExperienceSection(context, state),

                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: state.availableCategories.map((category) {
              return FilterChoiceChip(
                label: category,
                isSelected: state.category == category,
                onSelected: (selected) {
                  if (selected) {
                    context.read<FilterCubit>().setCategory(category);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price', style: AppTextStyles.h3),
            Text(
              '₹${state.priceRange.start.round()} - ₹${state.priceRange.end.round()}',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        RangeSlider(
          values: state.priceRange,
          min: 0,
          max: 500,
          divisions: 500,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.shimmerBase,
          labels: RangeLabels(
            '₹${state.priceRange.start.round()}',
            '₹${state.priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            context.read<FilterCubit>().setPriceRange(values);
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rating', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: RatingFilter.values.map((rating) {
              return FilterChoiceChip(
                label: rating.displayName,
                isSelected: state.rating == rating,
                showStar: true,
                onSelected: (selected) {
                  if (selected) {
                    context.read<FilterCubit>().setRating(rating);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Years of Experience', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ExperienceFilter.values.map((experience) {
              return FilterChoiceChip(
                label: experience.displayName,
                isSelected: state.experience == experience,
                onSelected: (selected) {
                  if (selected) {
                    context.read<FilterCubit>().setExperience(experience);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.read<FilterCubit>().reset();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.primary.withAlpha(20),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
            ),
            child: Text(
              'Reset',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: CustomButton(text: 'Filter', onPressed: () => context.pop()),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/filter_state.dart';
import 'filter_choice_chip.dart';
import 'rating_experience_sections.dart';

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

                  RatingSection(state: state),

                  ExperienceSection(state: state),

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
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoryState is CategoryLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.read<FilterCubit>().setAvailableCategories(
                    categoryState.categories,
                  );
                }
              });

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChoiceChip(
                      label: 'All',
                      isSelected: state.categoryId == null,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<FilterCubit>().setCategoryId(null);
                        }
                      },
                    ),
                    ...categoryState.categories.map((category) {
                      return FilterChoiceChip(
                        label: category.title,
                        isSelected: state.categoryId == category.id,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<FilterCubit>().setCategoryId(
                              category.id,
                            );
                          }
                        },
                      );
                    }),
                  ],
                ),
              );
            }

            return const Text('Failed to load categories');
          },
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
            if (!state.isLoadingPriceRange)
              Text(
                '₹${state.priceRange.start.round()}/hr - ₹${state.priceRange.end.round()}/hr',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        if (state.isLoadingPriceRange)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
            child: Center(
              child: LinearProgressIndicator(color: AppColors.primary),
            ),
          )
        else
          RangeSlider(
            values: state.priceRange,
            min: state.minPrice,
            max: state.maxPrice,
            divisions: (state.maxPrice - state.minPrice).round() > 0
                ? (state.maxPrice - state.minPrice).round()
                : 1,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.shimmerBase,
            labels: RangeLabels(
              '₹${state.priceRange.start.round()}/hr',
              '₹${state.priceRange.end.round()}/hr',
            ),
            onChanged: (RangeValues values) {
              context.read<FilterCubit>().setPriceRange(values);
            },
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Reset',
            isOutlined: true,
            height: 43,
            onPressed: () => context.read<FilterCubit>().reset(),
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: CustomButton(
            text: 'Filter',
            height: 44,
            onPressed: () => context.pop(),
          ),
        ),
      ],
    );
  }
}

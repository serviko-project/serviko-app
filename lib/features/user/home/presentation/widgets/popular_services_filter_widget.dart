import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/category/domain/entities/category_entity.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/popular_services_filter_cubit.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/popular_services_cubit.dart';

// Popular services filter widget using Category
class PopularServicesFilterWidget extends StatelessWidget {
  const PopularServicesFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          return BlocListener<PopularServicesFilterCubit, String?>(
            listener: (context, categoryId) {
              context.read<PopularServicesCubit>().fetchPopularServices(
                categoryId: categoryId,
              );
            },
            child: BlocBuilder<PopularServicesFilterCubit, String?>(
              builder: (context, selectedCategoryId) {
                final List<CategoryEntity?> categories = [null];
                if (categoryState is CategoryLoaded) {
                  categories.addAll(categoryState.categories);
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category?.id == selectedCategoryId;
                    final label = category?.title ?? 'All';

                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.sm),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            final controller = context
                                .read<PopularServicesFilterCubit>();
                            controller.updateFilter(category?.id);
                          }
                        },
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXl,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: 10,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

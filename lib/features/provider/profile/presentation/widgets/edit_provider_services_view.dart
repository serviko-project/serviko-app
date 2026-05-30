import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/category_chip.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/price_input_tile.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_services_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_services_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';

class EditProviderServicesView extends StatelessWidget {
  const EditProviderServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProviderServicesCubit, EditProviderServicesState>(
      listener: (context, state) {
        if (state.status == EditProviderServicesStatus.success &&
            state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<ProviderProfileCubit>().fetchProviderProfile();
          Navigator.of(context).pop();
        } else if (state.status == EditProviderServicesStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<EditProviderServicesCubit>().clearError();
        }
      },
      child: BlocBuilder<EditProviderServicesCubit, EditProviderServicesState>(
        builder: (context, state) {
          if (state.status == EditProviderServicesStatus.loading ||
              state.status == EditProviderServicesStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<EditProviderServicesCubit>();
          final selectedCategories = state.categories
              .where((c) => state.selectedServices.contains(c.id))
              .toList();

          final isUpdating =
              state.status == EditProviderServicesStatus.updating;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  children: [
                    Text(
                      'Select Services',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Choose the categories of services you provide.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    Wrap(
                      spacing: AppSizes.md,
                      runSpacing: AppSizes.md,
                      children: state.categories.map((category) {
                        final isSelected = state.selectedServices.contains(
                          category.id,
                        );
                        return CategoryChip(
                          label: category.title,
                          icon: IconMapper.fromName(category.icon),
                          isSelected: isSelected,
                          onTap: () => cubit.toggleService(category.id),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSizes.xl * 1.5),
                    const Divider(color: AppColors.divider, thickness: 1.5),
                    const SizedBox(height: AppSizes.xl),

                    Text(
                      'Set Rates',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Specify your base hourly rate for each selected service.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Empty state when no categories are selected
                    if (selectedCategories.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.xl * 2,
                          horizontal: AppSizes.xl,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 40,
                              color: AppColors.textSecondary.withAlpha(120),
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              'No services selected yet',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedCategories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSizes.md),
                        itemBuilder: (context, index) {
                          final category = selectedCategories[index];
                          final currentPrice =
                              state.categoryPrices[category.id];
                          final hasError =
                              state.showPriceValidation &&
                              (currentPrice == null || currentPrice <= 0);

                          return PriceInputTile(
                            key: ValueKey(category.id),
                            categoryId: category.id,
                            categoryTitle: category.title,
                            categoryIcon: IconMapper.fromName(category.icon),
                            currentPrice: currentPrice,
                            hasError: hasError,
                            onPriceChanged: (price) =>
                                cubit.setPrice(category.id, price),
                          );
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: CustomButton(
                  text: 'Save Services',
                  onPressed: isUpdating ? () {} : () => cubit.saveServices(),
                  isLoading: isUpdating,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

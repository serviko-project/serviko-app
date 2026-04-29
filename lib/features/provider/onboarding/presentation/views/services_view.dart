import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/service_card.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProviderOnboardingCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSizes.lg),

          // Top Information Banner
          const InfoBanner(
            text:
                'Select the services you are qualified to provide. You can update these later.',
          ),
          const SizedBox(height: AppSizes.xl),

          // Dynamic Selection Count Header
          BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Categories',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (state.selectedServices.isNotEmpty)
                    Text(
                      '${state.selectedServices.length} Selected',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSizes.md),

          // Grid View with categories
          Expanded(
            child:
                BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                  buildWhen: (prev, curr) =>
                      prev.availableCategories != curr.availableCategories ||
                      prev.selectedServices != curr.selectedServices ||
                      prev.isCategoriesLoading != curr.isCategoriesLoading,
                  builder: (context, state) {
                    if (state.isCategoriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.availableCategories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              'No categories available',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: AppSizes.xl * 2),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppSizes.md,
                            mainAxisSpacing: AppSizes.md,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: state.availableCategories.length,
                      itemBuilder: (context, index) {
                        final category = state.availableCategories[index];
                        final isSelected = state.selectedServices.contains(
                          category.id,
                        );
                        return ServiceCard(
                          name: category.title,
                          icon: IconMapper.fromName(category.icon),
                          isSelected: isSelected,
                          onTap: () => cubit.toggleService(category.id),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

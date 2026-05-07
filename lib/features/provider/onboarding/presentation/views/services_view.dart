import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/empty_pricing_state_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/category_header_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/pricing_header_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/category_chips_widget.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/price_tiles_widget.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
      buildWhen: (prev, curr) =>
          prev.availableCategories != curr.availableCategories ||
          prev.selectedServices != curr.selectedServices ||
          prev.categoryPrices != curr.categoryPrices ||
          prev.isCategoriesLoading != curr.isCategoriesLoading ||
          prev.showPriceValidation != curr.showPriceValidation,
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
                  size: AppSizes.iconXl,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'No categories available',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }

        final cubit = context.read<ProviderOnboardingCubit>();
        final selectedCategories = state.availableCategories
            .where((c) => state.selectedServices.contains(c.id))
            .toList();

        final missingPriceCount = selectedCategories
            .where((c) => (state.categoryPrices[c.id] ?? 0) <= 0)
            .length;

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          children: [
            const SizedBox(height: AppSizes.lg),
            const InfoBanner(
              text:
                  'Select the services you provide, then set your hourly rate for each.',
            ),
            const SizedBox(height: AppSizes.xl),

            // Category Selection
            CategoryHeaderWidget(selectedCount: state.selectedServices.length),
            const SizedBox(height: AppSizes.lg),
            CategoryChipsWidget(state: state, cubit: cubit),
            const SizedBox(height: AppSizes.xl),

            Divider(color: AppColors.border.withAlpha(80), height: 1),
            const SizedBox(height: AppSizes.xl),

            // Pricing Section
            PricingHeaderWidget(
              missingPriceCount: missingPriceCount,
              showPriceValidation: state.showPriceValidation,
            ),
            const SizedBox(height: AppSizes.xl),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: selectedCategories.isNotEmpty
                  ? PriceTilesWidget(
                      selectedCategories: selectedCategories,
                      state: state,
                      cubit: cubit,
                    )
                  : EmptyPricingStateWidget(),
            ),

            const SizedBox(height: AppSizes.xl * 2),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/price_input_tile.dart';

class PriceTilesWidget extends StatelessWidget {
  final List<dynamic> selectedCategories;
  final ProviderOnboardingState state;
  final ProviderOnboardingCubit cubit;

  const PriceTilesWidget({
    super.key,
    required this.selectedCategories,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: selectedCategories.map((category) {
        final currentPrice = state.categoryPrices[category.id];
        final hasError =
            state.showPriceValidation &&
            (currentPrice == null || currentPrice <= 0);

        return Padding(
          key: ValueKey(category.id),
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: PriceInputTile(
            categoryId: category.id,
            categoryTitle: category.title,
            categoryIcon: IconMapper.fromName(category.icon),
            currentPrice: currentPrice,
            hasError: hasError,
            onPriceChanged: (price) =>
                cubit.updateCategoryPrice(category.id, price),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/utils/icon_mapper.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/category_chip.dart';

class CategoryChipsWidget extends StatelessWidget {
  final ProviderOnboardingState state;
  final ProviderOnboardingCubit cubit;

  const CategoryChipsWidget({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: state.availableCategories.map((category) {
        final isSelected = state.selectedServices.contains(category.id);
        return CategoryChip(
          label: category.title,
          icon: IconMapper.fromName(category.icon),
          isSelected: isSelected,
          onTap: () => cubit.toggleService(category.id),
        );
      }).toList(),
    );
  }
}

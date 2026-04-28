import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/service_card.dart';

// Mock data for services
const _mockServices = [
  {'id': '1', 'name': 'Appliance Repair', 'icon': Icons.kitchen_rounded},
  {'id': '2', 'name': 'Plumbing Repair', 'icon': Icons.plumbing_rounded},
  {'id': '3', 'name': 'House Shifting', 'icon': Icons.local_shipping_rounded},
  {'id': '4', 'name': 'Gardening', 'icon': Icons.yard_rounded},
  {'id': '5', 'name': 'Electrician', 'icon': Icons.electrical_services_rounded},
];

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

          // Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: AppSizes.xl * 2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.md,
                mainAxisSpacing: AppSizes.md,
                childAspectRatio: 1.1,
              ),
              itemCount: _mockServices.length,
              itemBuilder: (context, index) {
                final service = _mockServices[index];
                return BlocBuilder<
                  ProviderOnboardingCubit,
                  ProviderOnboardingState
                >(
                  builder: (context, state) {
                    final isSelected = state.selectedServices.contains(
                      service['id'],
                    );
                    return ServiceCard(
                      name: service['name'] as String,
                      icon: service['icon'] as IconData,
                      isSelected: isSelected,
                      onTap: () => cubit.toggleService(service['id'] as String),
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

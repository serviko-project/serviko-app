import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_cubit.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/cubit/provider_promo_state.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/create_promo_bottom_sheet.dart';
import 'package:serviko_app/features/provider/promo_codes/presentation/widgets/promo_card_widget.dart';
import 'package:serviko_app/injection_container.dart';

class ProviderPromoCodesScreen extends StatelessWidget {
  const ProviderPromoCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderPromoCubit(
        getPromoCodes: InjectionContainer.instance.getPromoCodesUseCase,
        createPromoCode: InjectionContainer.instance.createPromoCodeUseCase,
        updatePromoCode: InjectionContainer.instance.updatePromoCodeUseCase,
        deactivatePromoCode:
            InjectionContainer.instance.deactivatePromoCodeUseCase,
      )..loadPromoCodes(),
      child: const ProviderPromoCodesView(),
    );
  }
}

class ProviderPromoCodesView extends StatelessWidget {
  const ProviderPromoCodesView({super.key});

  void _showCreatePromoBottomSheet(
    BuildContext context,
    ProviderPromoCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (modalContext) => CreatePromoBottomSheet(cubit: cubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProviderPromoCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "My Promo Codes"),
      body: BlocConsumer<ProviderPromoCubit, ProviderPromoState>(
        listener: (context, state) {
          if (state.status == ProviderPromoStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProviderPromoStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.promoCodes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                child: Column(
                  spacing: AppSizes.lg,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_offer_rounded,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),

                    Text("No Promo Codes Yet..!!", style: AppTextStyles.h2),

                    Text(
                      "Create custom promo codes to\n attract customers and boost your bookings!",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => cubit.loadPromoCodes(),
            color: AppColors.primary,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              itemCount: state.promoCodes.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                final promo = state.promoCodes[index];
                return PromoCardWidget(promo: promo, cubit: cubit);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreatePromoBottomSheet(context, cubit),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "New Promo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

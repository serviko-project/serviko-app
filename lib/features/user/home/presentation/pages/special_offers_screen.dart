import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/special_offers_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/special_offers_state.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/offer_card_widget.dart';

class SpecialOffersScreen extends StatelessWidget {
  const SpecialOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Special Offers'),
      body: BlocProvider(
        create: (context) => SpecialOffersCubit(
          getActivePromoCodesUseCase:
              InjectionContainer.instance.getActivePromoCodesUseCase,
        )..fetchActiveOffers(limit: 20),
        child: const _SpecialOffersView(),
      ),
    );
  }
}

class _SpecialOffersView extends StatelessWidget {
  const _SpecialOffersView();

  PromoCode get _mockPromoCode => PromoCode(
    id: '1',
    providerId: '1',
    code: 'PROMO30',
    discountType: 'percentage',
    discountValue: 30.0,
    maxUsesPerCustomer: 1,
    isActive: true,
    usageCount: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    providerName: 'Loading Provider Name',
    description: 'Get dynamic discounts for premium services.',
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<SpecialOffersCubit>().fetchActiveOffers(limit: 20),
      child: BlocBuilder<SpecialOffersCubit, SpecialOffersState>(
        builder: (context, state) {
          // Loading state with skeleton placeholders
          if (state is SpecialOffersLoading) {
            return Skeletonizer(
              enabled: true,
              containersColor: AppColors.surface,
              effect: const ShimmerEffect(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSizes.md),
                itemBuilder: (context, index) {
                  return OfferCardWidget(promo: _mockPromoCode, index: index);
                },
              ),
            );
          }
          // Error State
          if (state is SpecialOffersError) {
            return CustomErrorWidget(
              message: state.message,
              isFullPage: true,
              onRetry: () => context
                  .read<SpecialOffersCubit>()
                  .fetchActiveOffers(limit: 20),
            );
          }
          // Loaded State
          if (state is SpecialOffersLoaded) {
            final promos = state.promoCodes;
            if (promos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.discount_outlined,
                      size: AppSizes.xl * 2,
                      color: Colors.grey,
                    ),
                    SizedBox(height: AppSizes.md),
                    Text(
                      'No active special offers currently available.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: promos.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return OfferCardWidget(promo: promos[index], index: index);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

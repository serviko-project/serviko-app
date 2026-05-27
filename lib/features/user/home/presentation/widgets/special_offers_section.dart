import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/no_offers_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/section_header.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/special_offers_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/special_offers_state.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/offer_card_widget.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialOffersCubit(
        getActivePromoCodesUseCase:
            InjectionContainer.instance.getActivePromoCodesUseCase,
      )..fetchActiveOffers(limit: 3),
      child: const _SpecialOffersView(),
    );
  }
}

class _SpecialOffersView extends StatefulWidget {
  const _SpecialOffersView();

  @override
  State<_SpecialOffersView> createState() => _SpecialOffersViewState();
}

class _SpecialOffersViewState extends State<_SpecialOffersView> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && _itemCount > 1) {
        final currentPage = _pageController.page?.toInt() ?? 0;
        final nextPage = (currentPage + 1) % _itemCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // PromoCode for skeleton display
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
    description: 'Get dynamic discounts for premium home services.',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialOffersCubit, SpecialOffersState>(
      builder: (context, state) {
        // Loading State
        if (state is SpecialOffersLoading) {
          _itemCount = 0;
          return Column(
            spacing: 10,
            children: [
              SectionHeader(
                title: 'Special Offers',
                onSeeAllTap: () {
                  context.pushNamed(RouteNames.specialOffers);
                },
              ),
              // Skeleton Loader for Carousel
              SizedBox(
                height: 175,
                child: Skeletonizer(
                  enabled: true,
                  containersColor: AppColors.surface,
                  effect: ShimmerEffect(
                    baseColor: AppColors.shimmerBase,
                    highlightColor: AppColors.shimmerHighlight,
                  ),
                  child: OfferCardWidget(promo: _mockPromoCode, index: 0),
                ),
              ),
            ],
          );
        }
        // Loaded State
        else if (state is SpecialOffersLoaded) {
          final promos = state.promoCodes;
          final isEmpty = promos.isEmpty;
          _itemCount = isEmpty ? 1 : math.min(3, promos.length);

          return Column(
            spacing: 10,
            children: [
              // Header
              SectionHeader(
                title: 'Special Offers',
                onSeeAllTap: isEmpty
                    ? null
                    : () => context.pushNamed(RouteNames.specialOffers),
              ),

              // Carousel or No Offers Card
              SizedBox(
                height: 175,
                child: PageView.builder(
                  itemCount: _itemCount,
                  controller: _pageController,
                  physics: isEmpty
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  onPageChanged: (index) {
                    if (!isEmpty) {
                      context.read<SpecialOffersCubit>().updatePage(index);
                    }
                  },
                  itemBuilder: (context, index) {
                    if (isEmpty) {
                      return const NoOffersCard();
                    }
                    return OfferCardWidget(promo: promos[index], index: index);
                  },
                ),
              ),

              // Dots Indicators
              if (!isEmpty && _itemCount > 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _itemCount,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: state.currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: state.currentPage == index
                            ? AppColors.primary
                            : AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        } else {
          _itemCount = 0;
          return const SizedBox.shrink();
        }
      },
    );
  }
}

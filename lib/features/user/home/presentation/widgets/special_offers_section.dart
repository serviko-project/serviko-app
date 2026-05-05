import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/section_header.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/special_offers_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/offer_card_widget.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialOffersCubit(),
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

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page?.toInt() ?? 0;
        final nextPage = (currentPage + 1) % 3;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.md,
      children: [
        // Header
        SectionHeader(title: 'Special Offers', onSeeAllTap: () {}),
        const SizedBox(),

        // Carousel
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: 3,
            controller: _pageController,
            onPageChanged: (index) {
              context.read<SpecialOffersCubit>().updatePage(index);
            },
            itemBuilder: (context, index) {
              return OfferCardWidget(index);
            },
          ),
        ),

        // Dots Indicator
        BlocBuilder<SpecialOffersCubit, int>(
          builder: (context, currentPage) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? AppColors.primary
                        : AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'search_result_header.dart';
import '../bloc/search_state.dart';

class SearchResultsView extends StatelessWidget {
  final SearchLoaded? state;
  final bool isLoading;

  const SearchResultsView({super.key, this.state, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state != null)
          SearchResultHeader(
            query: state!.query,
            totalFound: state!.totalFound,
          ),
        const SizedBox(height: AppSizes.md),

        // Search results list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            itemCount: isLoading ? 4 : (state?.results.length ?? 0),
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              if (isLoading) {
                return const ServiceCard(
                  isLoading: true,
                  bannerImage: null,
                  categoryIcon: 'category_rounded',
                  providerName: 'Provider Name',
                  categoryName: 'Category',
                  price: 0,
                  rating: 0,
                  reviews: 0,
                );
              }

              final result = state!.results[index];
              return ServiceCard(
                bannerImage: result.bannerImage,
                categoryIcon: result.categoryIcon,
                providerName: result.providerName,
                categoryName: result.categoryName,
                price: result.basePricePerHour,
                rating: result.rating,
                reviews: result.reviewsCount,
                onTap: () {
                  context.pushNamed(AppRouter.serviceDetails, extra: result.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

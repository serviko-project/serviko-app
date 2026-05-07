import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'search_result_header.dart';
import '../bloc/search_state.dart';

class SearchResultsView extends StatelessWidget {
  final SearchLoaded state;

  const SearchResultsView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchResultHeader(query: state.query, totalFound: state.totalFound),
        const SizedBox(height: AppSizes.md),

        // Search results list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            itemCount: state.results.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              final result = state.results[index];
              return ServiceCard(
                imageUrl: result['image'],
                providerName: result['name'],
                categories: [result['service']],
                price: result['price'],
                rating: result['rating'],
                reviews: result['reviews'],
                onTap: () {
                  context.pushNamed(AppRouter.serviceDetails, extra: index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

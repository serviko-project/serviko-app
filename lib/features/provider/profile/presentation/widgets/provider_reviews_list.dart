import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/provider_review_card.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';

class ProviderReviewsList extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const ProviderReviewsList({
    super.key,
    required this.reviews,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ProviderReviewCard(review: reviews[index]);
          },
        ),
        if (hasMore) ...[
          const SizedBox(height: AppSizes.md),
          Center(
            child: isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: SizedBox(
                      width: AppSizes.lg,
                      height: AppSizes.lg,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : CustomButton(
                    text: "Load More",
                    height: 40,
                    onPressed: onLoadMore,
                  ),
          ),
        ],
      ],
    );
  }
}

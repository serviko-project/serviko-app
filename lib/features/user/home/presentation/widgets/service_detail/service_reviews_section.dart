import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/load_more_reviews_button.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/review_cards_skeletonizer_widget.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/review_filter_chips.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_reviews_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_reviews_state.dart';
import 'review_card.dart';

// Reviews section with filter chips and review list
class ServiceReviewsSection extends StatefulWidget {
  final String providerId;
  final double rating;
  final int reviewsCount;

  const ServiceReviewsSection({
    super.key,
    required this.providerId,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  State<ServiceReviewsSection> createState() => _ServiceReviewsSectionState();
}

class _ServiceReviewsSectionState extends State<ServiceReviewsSection> {
  @override
  void initState() {
    super.initState();
    if (widget.providerId.isNotEmpty) {
      context.read<ServiceReviewsCubit>().fetchReviews(widget.providerId);
    }
  }

  @override
  void didUpdateWidget(covariant ServiceReviewsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.providerId != widget.providerId &&
        widget.providerId.isNotEmpty) {
      context.read<ServiceReviewsCubit>().fetchReviews(widget.providerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    '${widget.rating.toStringAsFixed(1)} (${widget.reviewsCount} reviews)',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Filter chips
          ReviewFilterChips(providerId: widget.providerId),
          const SizedBox(height: AppSizes.md),

          // Review cards list
          BlocBuilder<ServiceReviewsCubit, ServiceReviewsState>(
            builder: (context, state) {
              if (state.status == ServiceReviewsStatus.loading) {
                return const ReviewCardsSkeletonizerWidget();
              }

              if (state.status == ServiceReviewsStatus.error) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                  child: Center(
                    child: Text(
                      state.message ??
                          'An error occurred while loading reviews.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                );
              }

              if (state.reviews.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: AppSizes.xxl,
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: AppSizes.md),
                        Text(
                          state.selectedRating == null
                              ? 'No reviews yet.'
                              : 'No reviews yet for this rating filter.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.reviews.length,
                    itemBuilder: (context, index) {
                      return ReviewCard(review: state.reviews[index]);
                    },
                  ),
                  if (state.hasMore) ...[
                    const SizedBox(height: AppSizes.md),
                    Center(
                      child: state.status == ServiceReviewsStatus.loadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(AppSizes.sm),
                              child: SizedBox(
                                width: AppSizes.lg,
                                height: AppSizes.lg,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : LoadMoreReviewsButton(
                              providerId: widget.providerId,
                            ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

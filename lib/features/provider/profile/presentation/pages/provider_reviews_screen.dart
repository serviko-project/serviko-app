import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/provider_profile_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/widgets/rating_header_section.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../cubit/provider_reviews_cubit.dart';
import '../cubit/provider_reviews_state.dart';
import '../widgets/provider_reviews_empty_state.dart';
import '../widgets/provider_reviews_list.dart';
import '../widgets/provider_review_card.dart';

// Ratings Screen of Provider to read customer feedback
class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  String? _fetchedProviderId;

  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProviderProfileCubit>();
    final profileState = profileCubit.state;
    if (profileState is ProviderProfileLoaded) {
      _fetchedProviderId = profileState.profile.id;
      context.read<ProviderReviewsCubit>().fetchReviews(_fetchedProviderId!);
    } else {
      profileCubit.fetchProviderProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "My Ratings"),
      body: SafeArea(
        child: BlocListener<ProviderProfileCubit, ProviderProfileState>(
          listener: (context, profileState) {
            if (profileState is ProviderProfileLoaded) {
              final providerId = profileState.profile.id;
              if (_fetchedProviderId != providerId) {
                _fetchedProviderId = providerId;
                context.read<ProviderReviewsCubit>().fetchReviews(providerId);
              }
            }
          },
          child: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
            builder: (context, profileState) {
              if (profileState is ProviderProfileError) {
                return CustomErrorWidget(
                  message: profileState.message,
                  onRetry: () => context
                      .read<ProviderProfileCubit>()
                      .fetchProviderProfile(),
                );
              }

              final isProfileLoaded = profileState is ProviderProfileLoaded;
              final providerId = isProfileLoaded ? profileState.profile.id : '';

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => providerId.isNotEmpty
                    ? context.read<ProviderReviewsCubit>().fetchReviews(
                        providerId,
                        refresh: true,
                      )
                    : Future.value(),
                child: BlocBuilder<ProviderReviewsCubit, ProviderReviewsState>(
                  builder: (context, state) {
                    if (state.status == ProviderReviewsStatus.error) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          alignment: Alignment.center,
                          child: CustomErrorWidget(
                            message:
                                state.message ??
                                'An error occurred while loading reviews.',
                            onRetry: () {
                              if (providerId.isNotEmpty) {
                                context
                                    .read<ProviderReviewsCubit>()
                                    .fetchReviews(providerId, refresh: true);
                              }
                            },
                          ),
                        ),
                      );
                    }

                    final isLoading =
                        state.status == ProviderReviewsStatus.loading ||
                        state.status == ProviderReviewsStatus.initial ||
                        !isProfileLoaded;

                    return Skeletonizer(
                      enabled: isLoading,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.screenPadding,
                          vertical: AppSizes.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Rating Value
                            RatingHeaderSection(
                              isLoading: isLoading,
                              state: state,
                            ),

                            // Recent Feedback Section
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Skeleton.ignore(
                                child: Text(
                                  'Recent Feedback',
                                  style: AppTextStyles.h3.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),

                            // Loading State
                            if (isLoading)
                              Column(
                                children: List.generate(
                                  3,
                                  (index) => ProviderReviewCard(
                                    review: ReviewEntity(
                                      id: '$index',
                                      bookingId: 'booking_$index',
                                      customerId: 'customer_$index',
                                      customerName: 'Customer $index',
                                      providerServiceId:
                                          'provider_service_$index',
                                      rating: 5,
                                      comment:
                                          'This is a sample review comment text to render the loading state',
                                      createdAt: DateTime.now()
                                          .toIso8601String(),
                                    ),
                                  ),
                                ),
                              )
                            //  Empty state
                            else if (state.reviews.isEmpty)
                              const ProviderReviewsEmptyState()
                            // Reviews List
                            else
                              ProviderReviewsList(
                                reviews: state.reviews,
                                hasMore: state.hasMore,
                                isLoadingMore:
                                    state.status ==
                                    ProviderReviewsStatus.loadingMore,
                                onLoadMore: () => providerId.isNotEmpty
                                    ? context
                                          .read<ProviderReviewsCubit>()
                                          .fetchReviews(providerId)
                                    : null,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/popular_services_filter_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/popular_services_filter_cubit.dart';
import 'package:serviko_app/core/widgets/section_header.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/popular_services_cubit.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';

class PopularServicesSection extends StatelessWidget {
  const PopularServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PopularServicesFilterCubit(),
      child: const _PopularServicesView(),
    );
  }
}

class _PopularServicesView extends StatelessWidget {
  const _PopularServicesView();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header
              SectionHeader(
                title: 'Most Popular Services',
                onSeeAllTap: () => context.pushNamed(AppRouter.popularServices),
              ),
              const SizedBox(height: AppSizes.md),

              // Filters
              PopularServicesFilterWidget(),
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),

        // Service Cards List
        BlocBuilder<PopularServicesCubit, PopularServicesState>(
          builder: (context, state) {
            if (state is PopularServicesLoading) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                sliver: Skeletonizer.sliver(
                  enabled: true,
                  child: SliverList.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return ServiceCard(
                        isLoading: true,
                        bannerImage: null,
                        categoryIcon: 'category_rounded',
                        providerName: 'Provider Name',
                        categoryName: 'Category',
                        price: 0.0,
                        rating: 0.0,
                        reviews: 0,
                        onBookmarkTap: () {},
                        onTap: () {},
                      );
                    },
                  ),
                ),
              );
            } else if (state is PopularServicesError) {
              return SliverToBoxAdapter(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () {
                    final categoryId = context
                        .read<PopularServicesFilterCubit>()
                        .state;
                    context.read<PopularServicesCubit>().fetchPopularServices(
                      categoryId: categoryId,
                    );
                  },
                ),
              );
            } else if (state is PopularServicesLoaded) {
              final services = state.services;
              if (services.isEmpty) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Lottie.asset(
                        AppAssets.notFoundAnimation,
                        width: 180,
                        height: 180,
                      ),
                      Text(
                        'No popular services found.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                sliver: SliverList.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final cubit = context.watch<BookmarksCubit>();
                    final isBookmarked = cubit.isBookmarked(service.id);

                    return ServiceCard(
                      bannerImage: service.bannerImage,
                      categoryIcon: service.categoryIcon,
                      providerName: service.providerName,
                      categoryName: service.categoryName,
                      price: service.basePricePerHour,
                      rating: service.rating,
                      reviews: service.reviewsCount,
                      isBookmarked: isBookmarked,
                      onBookmarkTap: () => context
                          .read<BookmarksCubit>()
                          .toggleBookmark(service),
                      onTap: () {
                        context.pushNamed(
                          AppRouter.serviceDetails,
                          extra: service.id,
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}

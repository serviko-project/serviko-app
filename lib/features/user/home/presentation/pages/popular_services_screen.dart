import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/popular_services_filter_widget.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/popular_services_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/popular_services_filter_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/injection_container.dart';

// Popular Services Screen
class PopularServicesScreen extends StatelessWidget {
  const PopularServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final di = InjectionContainer.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PopularServicesCubit(
            getPopularServicesUseCase: di.getPopularServicesUseCase,
          )..fetchPopularServices(),
        ),
        BlocProvider(create: (context) => PopularServicesFilterCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: 'Popular Services'),
        body: const _PopularServicesScreenBody(),
      ),
    );
  }
}

class _PopularServicesScreenBody extends StatelessWidget {
  const _PopularServicesScreenBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSizes.sm),

        // Filter Widget
        const PopularServicesFilterWidget(),
        const SizedBox(height: AppSizes.md),

        // Services List
        Expanded(
          child: BlocBuilder<PopularServicesCubit, PopularServicesState>(
            builder: (context, state) {
              // Loading State
              if (state is PopularServicesLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
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
                );
              }
              // Error State
              else if (state is PopularServicesError) {
                return CustomErrorWidget(
                  message: state.message,
                  isFullPage: true,
                  onRetry: () {
                    final cubit = context.read<PopularServicesFilterCubit>();
                    final categoryId = cubit.state;
                    context.read<PopularServicesCubit>().fetchPopularServices(
                      categoryId: categoryId,
                    );
                  },
                );
              }
              // Loaded State
              else if (state is PopularServicesLoaded) {
                final services = state.services;
                if (services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isBookmarked = context
                        .watch<BookmarksCubit>()
                        .isBookmarked(service.id);

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
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

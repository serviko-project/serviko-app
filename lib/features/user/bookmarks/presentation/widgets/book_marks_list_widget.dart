import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_filter_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/widgets/bookmark_empty_state_widget.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/widgets/remove_bookmark_bottom_sheet_widget.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookMarksListWidget extends StatelessWidget {
  const BookMarksListWidget({
    super.key,
    required this.isLoading,
    required this.bookmarks,
    required this.categories,
    required this.filteredServices,
  });

  final bool isLoading;
  final List<ServiceEntity> bookmarks;
  final List<String> categories;
  final List<ServiceEntity> filteredServices;

  @override
  Widget build(BuildContext context) {
    final selectedFilter = context.watch<BookmarksFilterCubit>().state;
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        slivers: [
          // Filter Chips
          if (bookmarks.isNotEmpty || isLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: isLoading ? 4 : categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  itemBuilder: (context, index) {
                    final filter = isLoading
                        ? 'Category $index'
                        : categories[index];

                    final isSelected = filter == selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.sm),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected && !isLoading) {
                            final cubit = context.read<BookmarksFilterCubit>();
                            cubit.updateFilter(filter);
                          }
                        },
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXl,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.sm)),

          // Empty State
          if (!isLoading && bookmarks.isEmpty)
            const BookmarksEmptyState()
          else if (!isLoading && filteredServices.isEmpty)
            BookmarksEmptyState(categoryName: selectedFilter)
          // BookMark List
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              sliver: SliverList.builder(
                itemCount: isLoading ? 4 : filteredServices.length,
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

                  final service = filteredServices[index];
                  return ServiceCard(
                    bannerImage: service.bannerImage,
                    categoryIcon: service.categoryIcon,
                    providerName: service.providerName,
                    categoryName: service.categoryName,
                    price: service.basePricePerHour,
                    rating: service.rating,
                    reviews: service.reviewsCount,
                    isBookmarked: true,
                    onBookmarkTap: () {
                      RemoveBookmarkBottomSheetWidget.show(
                        context,
                        service: service,
                        onRemoveConfirm: () {
                          final cubit = context.read<BookmarksCubit>();
                          cubit.toggleBookmark(service);
                        },
                      );
                    },
                    onTap: () => context.pushNamed(
                      AppRouter.serviceDetails,
                      extra: service.id,
                    ),
                  );
                },
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_filter_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/widgets/remove_bookmark_bottom_sheet_widget.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksFilterCubit(),
      child: const _BookmarksView(),
    );
  }
}

class _BookmarksView extends StatelessWidget {
  const _BookmarksView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "My Bookmarks"),
      body: CustomScrollView(
        slivers: [
          // Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60,
              child: BlocBuilder<BookmarksFilterCubit, String>(
                builder: (context, selectedFilter) {
                  return ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    itemBuilder: (context, index) {
                      final filter = index == 0 ? 'All' : 'Category $index';
                      final isSelected = filter == selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.sm),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              final controller = context
                                  .read<BookmarksFilterCubit>();
                              controller.updateFilter(filter);
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
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.sm)),

          // Bookmarks List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            sliver: SliverList.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ServiceCard(
                  imageUrl:
                      "https://imgs.search.brave.com/UveizRxweFrraMwnNtB7kFdENT_6dhwB5FpySUMnm3I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wbHVz/LnVuc3BsYXNoLmNv/bS9wcmVtaXVtX3Bo/b3RvLTE2NjEzMzM0/NDU5NDEtOTUzMTcz/OWU1NGUwP2ZtPWpw/ZyZxPTYwJnc9MzAw/MCZhdXRvPWZvcm1h/dCZmaXQ9Y3JvcCZp/eGxpYj1yYi00LjEu/MCZpeGlkPU0zd3hN/akEzZkRCOE1IeHpa/V0Z5WTJoOE9YeDhj/bVZ3WVdseUpUSXdj/MlZ5ZG1salpYeGxi/bnd3Zkh3d2ZIeDhN/QT09",
                  providerName: 'Provider ${index + 1}',
                  categories: const ['Category 1', 'Category 2'],
                  price: 20.0 + (index * 5),
                  rating: 4.5 + (index * 0.05),
                  reviews: 120 + (index * 42),
                  isBookmarked: true,
                  onBookmarkTap: () =>
                      RemoveBookmarkBottomSheetWidget.show(context, index),
                  onTap: () =>
                      context.pushNamed(AppRouter.serviceDetails, extra: index),
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

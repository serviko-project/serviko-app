import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/category_item_widget.dart';
import 'package:serviko_app/core/widgets/section_header.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Categories',
            onSeeAllTap: () => context.pushNamed(RouteNames.allCategories),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

        // Grid of categories
        BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                sliver: Skeletonizer.sliver(
                  enabled: true,
                  child: SliverGrid.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: AppSizes.sm,
                          mainAxisSpacing: AppSizes.md,
                        ),
                    itemBuilder: (context, index) {
                      return CategoryItemWidget(
                        index: index,
                        title: 'Category',
                        icon: null,
                      );
                    },
                  ),
                ),
              );
            } else if (state is CategoryError) {
              return SliverToBoxAdapter(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      context.read<CategoryCubit>().fetchCategories(),
                ),
              );
            } else if (state is CategoryLoaded) {
              final categories = state.categories;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                sliver: SliverGrid.builder(
                  itemCount: categories.length > 8 ? 8 : categories.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: AppSizes.sm,
                    mainAxisSpacing: AppSizes.md,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryItemWidget(
                      index: index,
                      title: category.title,
                      icon: category.icon,
                      onTap: () => context.pushNamed(
                        RouteNames.categoryDetails,
                        extra: {'id': category.id, 'name': category.title},
                      ),
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

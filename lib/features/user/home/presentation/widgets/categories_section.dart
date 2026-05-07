import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/category_item_widget.dart';
import 'package:serviko_app/core/widgets/section_header.dart';

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
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          sliver: SliverGrid.builder(
            itemCount: 7,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppSizes.sm,
              mainAxisSpacing: AppSizes.md,
            ),
            itemBuilder: (context, index) {
              return CategoryItemWidget(
                index: index,
                onTap: () => context.pushNamed(
                  RouteNames.categoryDetails,
                  extra: 'Category ${index + 1}',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

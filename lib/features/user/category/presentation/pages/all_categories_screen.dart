import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/category_item_widget.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'All Categories'),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.lg),
        itemCount: 15,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.75,
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
    );
  }
}

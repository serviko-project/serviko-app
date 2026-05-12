import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/route_constants.dart';
import 'package:serviko_app/core/widgets/category_item_widget.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_cubit.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'All Categories'),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return CustomErrorWidget(
              message: state.message,
              isFullPage: true,
              onRetry: () => context.read<CategoryCubit>().fetchCategories(),
            );
          }

          if (state is CategoryLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: state.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.md,
              ),
              itemBuilder: (context, index) {
                final category = state.categories[index];
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

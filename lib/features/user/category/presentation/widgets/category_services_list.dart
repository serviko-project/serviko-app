import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';

class CategoryServicesList extends StatelessWidget {
  const CategoryServicesList({super.key, required this.indices});

  final List<int> indices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: indices.length,
      itemBuilder: (context, position) {
        final index = indices[position];
        return ServiceCard(
          imageUrl: 'https://picsum.photos/seed/service$index/200/200',
          providerName: 'Provider ${index + 1}',
          categories: const ['Category 1', 'Category 2'],
          price: 20.0 + (index * 5),
          rating: 4.0 + (index % 10) / 10,
          reviews: 100 + (index * 10),
          onBookmarkTap: () {},
          onTap: () =>
              context.pushNamed(AppRouter.serviceDetails, extra: index),
        );
      },
    );
  }
}

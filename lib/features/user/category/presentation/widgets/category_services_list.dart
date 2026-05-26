import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';

class CategoryServicesList extends StatelessWidget {
  const CategoryServicesList({
    super.key,
    required this.services,
    this.isLoading = false,
  });

  final List<ServiceEntity> services;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isBookmarked = context.watch<BookmarksCubit>().isBookmarked(
          service.id,
        );
        return ServiceCard(
          isLoading: isLoading,
          bannerImage: service.bannerImage,
          categoryIcon: service.categoryIcon,
          providerName: service.providerName,
          categoryName: service.categoryName,
          price: service.basePricePerHour,
          rating: service.rating,
          reviews: service.reviewsCount,
          isBookmarked: isBookmarked,
          onBookmarkTap: () =>
              context.read<BookmarksCubit>().toggleBookmark(service),
          onTap: () =>
              context.pushNamed(AppRouter.serviceDetails, extra: service.id),
        );
      },
    );
  }
}

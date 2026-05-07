import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/popular_services_filter_cubit.dart';
import 'package:serviko_app/core/widgets/section_header.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_card.dart';

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
              SectionHeader(title: 'Most Popular Services', onSeeAllTap: () {}),
              const SizedBox(height: AppSizes.md),

              // Filters
              SizedBox(
                height: 50,
                child: BlocBuilder<PopularServicesFilterCubit, String>(
                  builder: (context, selectedFilter) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                      ),
                      itemCount: 5,
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
                                    .read<PopularServicesFilterCubit>();
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
              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),

        // Service Cards List
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
                price: 400 + (index * 50),
                rating: 4.5 + (index * 0.05),
                reviews: 100 + (index * 30),
                onBookmarkTap: () {},
                onTap: () {
                  context.pushNamed(AppRouter.serviceDetails, extra: index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

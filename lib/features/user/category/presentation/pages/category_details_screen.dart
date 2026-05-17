import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_details_cubit.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_details_state.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_search_empty_view.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_search_field.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_services_list.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import 'package:serviko_app/injection_container.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryDetailsCubit(
        searchServicesUseCase:
            InjectionContainer.instance.searchServicesUseCase,
        categoryId: categoryId,
      )..loadCategoryServices(),
      child: _CategoryDetailsView(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    );
  }
}

class _CategoryDetailsView extends StatefulWidget {
  const _CategoryDetailsView({
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  State<_CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<_CategoryDetailsView> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onToggleSearch(CategoryDetailsCubit cubit, bool wasSearching) {
    cubit.toggleSearch();
    if (!wasSearching) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _searchFocusNode.canRequestFocus) {
          _searchFocusNode.requestFocus();
        }
      });
    } else {
      _searchController.clear();
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryDetailsCubit>();

    return BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: const BackButtonWidget(),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                );
              },
              child: state.isSearching
                  ? CategorySearchField(
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                      cubit: cubit,
                      categoryName: widget.categoryName,
                    )
                  : Text(
                      widget.categoryName,
                      key: const ValueKey('category_title'),
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
            centerTitle: !state.isSearching,
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    state.isSearching
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    key: ValueKey(state.isSearching),
                    color: AppColors.textPrimary,
                    size: 26,
                  ),
                ),
                onPressed: () => _onToggleSearch(cubit, state.isSearching),
              ),
              const SizedBox(width: AppSizes.xs),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(CategoryDetailsState state) {
    switch (state.status) {
      // Loading State
      case CategoryDetailsStatus.loading:
        return _buildLoadingSkeleton();

      // Error State
      case CategoryDetailsStatus.error:
        return CustomErrorWidget(
          message: state.errorMessage ?? 'Something went wrong',
          isFullPage: true,
          onRetry: () =>
              context.read<CategoryDetailsCubit>().loadCategoryServices(),
        );

      // Success State
      case CategoryDetailsStatus.success:
      case CategoryDetailsStatus.initial:
        final services = state.filteredServices;
        if (services.isEmpty) {
          return CategorySearchEmptyView(searchQuery: state.searchQuery);
        }
        return CategoryServicesList(services: services);
    }
  }

  // Loading skeleton with shimmer effect
  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: CategoryServicesList(
        services: List.generate(4, (index) {
          return ServiceEntity(
            id: index.toString(),
            categoryId: widget.categoryId,
            categoryName: widget.categoryName,
            categoryIcon: "category_icon",
            providerId: index.toString(),
            providerName: "Provider Name",
            professionalTitle: "Professional Title",
            basePricePerHour: 500,
            rating: 4.5,
            reviewsCount: 100,
          );
        }),
        isLoading: true,
      ),
    );
  }
}

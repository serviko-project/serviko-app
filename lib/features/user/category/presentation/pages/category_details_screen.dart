import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_details_cubit.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_details_state.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_search_empty_view.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_search_field.dart';
import 'package:serviko_app/features/user/category/presentation/widgets/category_services_list.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryDetailsCubit(),
      child: _CategoryDetailsView(categoryName: categoryName),
    );
  }
}

class _CategoryDetailsView extends StatefulWidget {
  const _CategoryDetailsView({required this.categoryName});

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
      _searchFocusNode.requestFocus();
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
        final indices = state.filteredIndices;

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
          body: indices.isEmpty
              ? CategorySearchEmptyView(searchQuery: state.searchQuery)
              : CategoryServicesList(indices: indices),
        );
      },
    );
  }
}

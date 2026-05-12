import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/widgets/back_button_widget.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/recent_searches_view.dart';
import '../widgets/search_results_view.dart';
import '../widgets/search_empty_view.dart';
import '../bloc/filter_cubit.dart';
import 'package:serviko_app/injection_container.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.openFilter = false});

  final bool openFilter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchCubit(
            searchServicesUseCase:
                InjectionContainer.instance.searchServicesUseCase,
          ),
        ),
        BlocProvider(create: (context) => FilterCubit()),
      ],
      child: _SearchScreenView(openFilter: openFilter),
    );
  }
}

class _SearchScreenView extends StatefulWidget {
  final bool openFilter;
  const _SearchScreenView({this.openFilter = false});

  @override
  State<_SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<_SearchScreenView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.openFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFilterBottomSheet();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchController.text = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final categoryId = context.read<FilterCubit>().state.categoryId;
      context.read<SearchCubit>().search(value, categoryId: categoryId);
    });
  }

  void _onSearchSubmit(String value) {
    _searchController.text = value;
    final categoryId = context.read<FilterCubit>().state.categoryId;
    context.read<SearchCubit>().search(value, categoryId: categoryId);
  }

  void _showFilterBottomSheet() async {
    final filterCubit = context.read<FilterCubit>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: filterCubit,
        child: const FilterBottomSheet(),
      ),
    );

    if (mounted) {
      final query = _searchController.text;
      final categoryId = context.read<FilterCubit>().state.categoryId;
      context.read<SearchCubit>().search(query, categoryId: categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.md),
            // Search Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                children: [
                  const BackButtonWidget(),
                  const SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomTextField(
                        controller: _searchController,
                        hintText: 'Search',
                        autofocus: !widget.openFilter,
                        textInputAction: TextInputAction.search,
                        onChanged: _onSearchChanged,
                        onFieldSubmitted: _onSearchSubmit,
                        prefixIcon: const Icon(
                          CupertinoIcons.search,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _showFilterBottomSheet,
                          icon: const Icon(
                            Icons.tune_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Content Area
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return RecentSearchesView(
                      state: state,
                      onSearchSubmit: _onSearchSubmit,
                    );
                  } else if (state is SearchLoading) {
                    return _buildLoadingSkeleton();
                  } else if (state is SearchLoaded) {
                    return SearchResultsView(state: state);
                  } else if (state is SearchEmpty) {
                    return SearchEmptyView(state: state);
                  } else if (state is SearchError) {
                    return CustomErrorWidget(
                      message: state.message,
                      isFullPage: true,
                      onRetry: () {
                        final cubit = context.read<FilterCubit>();
                        final categoryId = cubit.state.categoryId;
                        context.read<SearchCubit>().search(
                          _searchController.text,
                          categoryId: categoryId,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return const Skeletonizer(
      enabled: true,
      child: SearchResultsView(isLoading: true),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/cubit/bookmarks_filter_cubit.dart';
import 'package:serviko_app/features/user/bookmarks/presentation/widgets/book_marks_list_widget.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksFilterCubit(),
      child: const _BookmarksView(),
    );
  }
}

class _BookmarksView extends StatefulWidget {
  const _BookmarksView();

  @override
  State<_BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<_BookmarksView> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarksCubit>().fetchBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "My Bookmarks"),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          // Error State
          if (state is BookmarksError) {
            return CustomErrorWidget(
              message: state.message,
              isFullPage: true,
              onRetry: () => context.read<BookmarksCubit>().fetchBookmarks(),
            );
          }

          final bool isLoading =
              state is BookmarksLoading || state is BookmarksInitial;
          final List<ServiceEntity> bookmarks = state is BookmarksLoaded
              ? state.bookmarks
              : [];

          final categoriesSet = bookmarks.map((e) => e.categoryName).toSet();
          final List<String> categories = ['All', ...categoriesSet];

          return BlocBuilder<BookmarksFilterCubit, String>(
            builder: (context, selectedFilter) {
              if (!categories.contains(selectedFilter)) {
                context.read<BookmarksFilterCubit>().updateFilter('All');
              }

              final filteredServices = selectedFilter == 'All'
                  ? bookmarks
                  : bookmarks.where((s) {
                      return s.categoryName == selectedFilter;
                    }).toList();

              return BookMarksListWidget(
                isLoading: isLoading,
                bookmarks: bookmarks,
                categories: categories,
                filteredServices: filteredServices,
              );
            },
          );
        },
      ),
    );
  }
}

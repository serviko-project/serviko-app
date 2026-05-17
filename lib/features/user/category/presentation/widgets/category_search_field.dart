import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/category/presentation/cubit/category_details_cubit.dart';

class CategorySearchField extends StatelessWidget {
  const CategorySearchField({
    super.key,
    required TextEditingController searchController,
    required FocusNode searchFocusNode,
    required this.cubit,
    required this.categoryName,
  }) : _searchController = searchController,
       _searchFocusNode = searchFocusNode;

  final TextEditingController _searchController;
  final FocusNode _searchFocusNode;
  final CategoryDetailsCubit cubit;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey('search_field'),
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: cubit.onSearchChanged,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Search in $categoryName...',
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textHint),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        isDense: true,
      ),
    );
  }
}

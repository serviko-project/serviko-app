import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class RecentSearchesView extends StatelessWidget {
  final SearchInitial state;
  final Function(String) onSearchSubmit;

  const RecentSearchesView({
    super.key,
    required this.state,
    required this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: AppTextStyles.h3),
              TextButton(
                onPressed: () => context.read<SearchCubit>().clearRecents(),
                child: Text(
                  'Clear All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(left: AppSizes.md),
              itemCount: state.recentSearches.length,
              itemBuilder: (context, index) {
                final query = state.recentSearches[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    query,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        context.read<SearchCubit>().removeRecent(query),
                  ),
                  onTap: () => onSearchSubmit(query),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

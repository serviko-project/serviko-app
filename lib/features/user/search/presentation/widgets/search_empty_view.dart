import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:serviko_app/core/constants/app_assets.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'search_result_header.dart';
import '../bloc/search_state.dart';

class SearchEmptyView extends StatelessWidget {
  final SearchEmpty state;

  const SearchEmptyView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with query and total found
          SearchResultHeader(query: state.query, totalFound: 0),

          // Empty state content
          Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lottie.asset(
                  AppAssets.notFoundAnimation,
                  width: 200,
                  height: 200,
                ),
                Text(
                  "No results found..!!",
                  style: AppTextStyles.h2.copyWith(
                    letterSpacing: 0.5,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  "We couldn't find anything for that.",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

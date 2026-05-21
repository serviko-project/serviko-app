import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/faq_cubit.dart';

// Search Bar widget in Help Center screen
class HelpCenterSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const HelpCenterSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.watch<FaqCubit>().state.searchQuery;

    return CustomTextField(
      controller: controller,
      hintText: 'Search for questions...',
      onChanged: (val) {
        context.read<FaqCubit>().updateSearchQuery(val);
      },
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.sm),
        child: Icon(
          CupertinoIcons.search,
          color: AppColors.textSecondary,
          size: AppSizes.iconMd,
        ),
      ),
      suffixIcon: searchQuery.isNotEmpty
          ? IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedCancel01,
                color: AppColors.textSecondary,
                size: AppSizes.iconSm,
              ),
              onPressed: () {
                controller.clear();
                context.read<FaqCubit>().clearSearchQuery();
              },
            )
          : null,
    );
  }
}

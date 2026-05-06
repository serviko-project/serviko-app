import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/router/app_router.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomTextField(
          hintText: 'Search',
          readOnly: true,
          onTap: () => context.pushNamed(AppRouter.search),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: AppColors.textHint,
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: () => context.pushNamed(AppRouter.search, extra: true),
            icon: Icon(
              Icons.tune_outlined,
              size: 20,
              color: AppColors.textHint,
            ),
          ),
        ),
      ),
    );
  }
}

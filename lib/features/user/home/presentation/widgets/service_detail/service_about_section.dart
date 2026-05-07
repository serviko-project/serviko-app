import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_detail_cubit.dart';
import 'package:serviko_app/features/user/home/presentation/cubit/service_detail_state.dart';

class ServiceAboutSection extends StatelessWidget {
  const ServiceAboutSection({super.key});

  static const String _description =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim nostrud exercitation ullamco laboris nisi ut '
      'aliquip ex ea commodo consequat. Duis aute irure dolor in '
      'reprehenderit in voluptate velit esse cillum dolore eu fugiat '
      'nulla pariatur. Excepteur sint occaecat cupidatat non proident, '
      'sunt in culpa qui officia deserunt mollit anim id est laborum.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About me', style: AppTextStyles.h2),
          const SizedBox(height: AppSizes.sm),

          // Description
          BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
            buildWhen: (prev, curr) =>
                prev.isAboutExpanded != curr.isAboutExpanded,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _description,
                    maxLines: state.isAboutExpanded ? null : 4,
                    overflow: state.isAboutExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: AppSizes.xs),

                  GestureDetector(
                    onTap: () {
                      context.read<ServiceDetailCubit>().toggleAboutExpanded();
                    },
                    child: Text(
                      state.isAboutExpanded ? 'Read less' : 'Read more',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

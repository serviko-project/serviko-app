import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/service/presentation/cubit/service_detail_cubit.dart';

class ServiceAboutSection extends StatelessWidget {
  final String? about;

  const ServiceAboutSection({super.key, this.about});

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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final span = TextSpan(
                        text: about,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      );
                      final tp = TextPainter(
                        text: span,
                        textDirection: TextDirection.ltr,
                        maxLines: 4,
                      );
                      tp.layout(maxWidth: constraints.maxWidth);

                      final isOverflowing = tp.didExceedMaxLines;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            about ?? 'No description provided.',
                            maxLines: state.isAboutExpanded ? null : 4,
                            overflow: state.isAboutExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                          if (isOverflowing) ...[
                            const SizedBox(height: AppSizes.xs),
                            GestureDetector(
                              onTap: () => context
                                  .read<ServiceDetailCubit>()
                                  .toggleAboutExpanded(),
                              child: Text(
                                state.isAboutExpanded
                                    ? 'Read less'
                                    : 'Read more',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
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

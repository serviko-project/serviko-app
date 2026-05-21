import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/privacy_policy_cubit.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/privacy_policy_state.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/policy_header_card.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/policy_section_card.dart';
import 'package:serviko_app/injection_container.dart';

// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrivacyPolicyCubit>(
      create: (context) => PrivacyPolicyCubit(
        getPrivacyPolicyUseCase:
            InjectionContainer.instance.getPrivacyPolicyUseCase,
      )..loadPrivacyPolicy(),

      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'Privacy Policy'),
        body: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
          builder: (context, state) {
            if (state is PrivacyPolicyLoading) {
              return Skeletonizer(
                enabled: true,
                effect: ShimmerEffect(
                  baseColor: AppColors.shimmerHighlight,
                  highlightColor: AppColors.shimmerHighlight.withValues(
                    alpha: 0.35,
                  ),
                ),
                child: _buildPolicyContent(
                  context,
                  const PrivacyPolicyItem(
                    id: 'id',
                    title: 'Serviko Privacy Policy Guidelines',
                    content: 'This is a placeholder privacy policy content',
                    version: '1.0.0',
                    isActive: true,
                  ),
                ),
              );
            } else if (state is PrivacyPolicyError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: CustomErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<PrivacyPolicyCubit>().loadPrivacyPolicy(),
                  ),
                ),
              );
            } else if (state is PrivacyPolicyLoaded) {
              return _buildPolicyContent(context, state.policy);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPolicyContent(BuildContext context, PrivacyPolicyItem policy) {
    final sections = _parsePolicyContent(policy.content);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenPadding,
          vertical: AppSizes.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicyHeaderCard(title: policy.title, version: policy.version),
            const SizedBox(height: AppSizes.lg),

            ...sections.map(
              (section) =>
                  PolicySectionCard(title: section.title, items: section.items),
            ),

            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  // Parse Policy Content
  List<_PolicySection> _parsePolicyContent(String rawContent) {
    final sections = <_PolicySection>[];
    final lines = rawContent.split('\n');
    String currentTitle = '';
    final currentItems = <String>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('###')) {
        if (currentTitle.isNotEmpty || currentItems.isNotEmpty) {
          sections.add(
            _PolicySection(
              currentTitle.isEmpty ? 'Policy Guidelines' : currentTitle,
              List.from(currentItems),
            ),
          );
          currentItems.clear();
        }
        currentTitle = line.replaceFirst('###', '').trim();
      } else {
        currentItems.add(line);
      }
    }

    if (currentTitle.isNotEmpty || currentItems.isNotEmpty) {
      sections.add(
        _PolicySection(
          currentTitle.isEmpty ? 'Policy Guidelines' : currentTitle,
          List.from(currentItems),
        ),
      );
    }

    return sections;
  }
}

class _PolicySection {
  final String title;
  final List<String> items;

  const _PolicySection(this.title, this.items);
}

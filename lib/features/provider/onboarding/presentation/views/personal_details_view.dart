import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/utils/form_validators.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/number_stepper_widget.dart';

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProviderOnboardingCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Form(
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.lg),

            // Top Information Banner
            const InfoBanner(
              text:
                  'This information will be shown on your public profile to help customers know and trust you.',
            ),
            const SizedBox(height: AppSizes.xl),

            // Profile Info
            Center(
              child:
                  BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                    buildWhen: (prev, curr) =>
                        prev.userName != curr.userName ||
                        prev.profileImageUrl != curr.profileImageUrl ||
                        prev.isReapplication != curr.isReapplication,
                    builder: (context, state) {
                      final userName = state.userName ?? 'User';
                      final photoUrl = state.profileImageUrl;
                      final greeting = state.isReapplication
                          ? 'Welcome back, $userName'
                          : 'Hey, $userName 👋';
                      final subtitle = state.isReapplication
                          ? 'Let\'s update your details'
                          : 'Let\'s build your provider profile';

                      return Column(
                        children: [
                          // Profile Image
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withAlpha(60),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: photoUrl != null && photoUrl.isNotEmpty
                                  ? Image.network(
                                      photoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          _buildDefaultAvatar(userName),
                                    )
                                  : _buildDefaultAvatar(userName),
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // Greeting and Subtitle
                          Text(greeting, style: AppTextStyles.h3),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                        ],
                      );
                    },
                  ),
            ),
            const SizedBox(height: AppSizes.xl * 1.2),

            // Form Fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Professional Title
                CustomTextField(
                  labelText: 'Professional Title',
                  hintText: 'e.g. App Developer',
                  controller: cubit.titleController,
                  focusNode: cubit.titleFocusNode,
                  textInputAction: TextInputAction.next,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    'professional title',
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // Years of Experience
                Text('Years of Experience', style: AppTextStyles.labelMedium),
                const SizedBox(height: AppSizes.sm),
                BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
                  builder: (context, state) {
                    return NumberStepperWidget(
                      value: state.yearsOfExperience,
                      suffix: 'years',
                      onChanged: cubit.setYearsOfExperience,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.xl),

                // About You
                CustomTextField(
                  labelText: 'About You',
                  hintText:
                      'Tell customers a bit about your skills and background...',
                  controller: cubit.aboutController,
                  focusNode: cubit.aboutFocusNode,
                  textInputAction: TextInputAction.done,
                  maxLines: 7,
                ),
                const SizedBox(height: AppSizes.sm),

                // Helper Text for About You
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 14,
                      color: AppColors.primary.withAlpha(200),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Tip: Mention your specialties, how long you've been working or what you love about your job.",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl * 2),
          ],
        ),
      ),
    );
  }

  // Default avatar with user initial
  Widget _buildDefaultAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Container(
      color: AppColors.primary.withAlpha(20),
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

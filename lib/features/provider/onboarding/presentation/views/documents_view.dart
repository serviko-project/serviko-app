import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/document_upload_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';

class DocumentsView extends StatelessWidget {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProviderOnboardingCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSizes.lg),
          // Top Information Banner
          const InfoBanner(
            text:
                'Please upload the following documents for verification. Your privacy is protected with bank-grade encryption.',
          ),
          const SizedBox(height: AppSizes.xl),

          Text(
            'GOVERNMENT ID',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textHint,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
            builder: (context, state) {
              return DocumentUploadCard(
                title: 'Government ID',
                subtitle: 'Passport, National ID or Driver\'s License',
                icon: Icons.badge_outlined,
                isUploaded: state.document1Path != null,
                fileName: state.document1Path != null ? 'ID_Front.jpg' : null,
                onTap: () => cubit.pickDocument(1),
                onDelete: () => cubit.removeDocument(1),
              );
            },
          ),

          const SizedBox(height: AppSizes.xl),

          Text(
            'PROFESSIONAL CERTIFICATE',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textHint,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          BlocBuilder<ProviderOnboardingCubit, ProviderOnboardingState>(
            builder: (context, state) {
              return DocumentUploadCard(
                title: 'Service Certificate',
                subtitle: 'Professional license or training certificate',
                icon: Icons.workspace_premium_outlined,
                isUploaded: state.document2Path != null,
                fileName: state.document2Path != null
                    ? 'Certificate_Copy.pdf'
                    : null,
                onTap: () => cubit.pickDocument(2),
                onDelete: () => cubit.removeDocument(2),
              );
            },
          ),

          const SizedBox(height: AppSizes.xl),

          // Security Banner
          const InfoBanner(
            text:
                'We use 256-bit encryption to keep your personal data safe and private. Your security is our priority.',
            icon: Icons.shield_outlined,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSizes.xl * 2),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_cubit.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/cubit/provider_onboarding_state.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/document_upload_card.dart';
import 'package:serviko_app/features/provider/onboarding/presentation/widgets/info_banner.dart';
import 'package:url_launcher/url_launcher.dart';

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
            buildWhen: (prev, curr) =>
                prev.governmentIdDoc != curr.governmentIdDoc ||
                prev.isUploadingDoc1 != curr.isUploadingDoc1,
            builder: (context, state) {
              return DocumentUploadCard(
                title: 'Government ID',
                subtitle: 'Passport, National ID or Driver\'s License',
                icon: Icons.badge_outlined,
                isUploaded: state.governmentIdDoc != null,
                isUploading: state.isUploadingDoc1,
                fileName: state.governmentIdDoc?.originalFilename,
                onTap: () => cubit.pickAndUploadDocument(1),
                onDelete: () => cubit.removeDocument(1),
                onView: state.governmentIdDoc != null
                    ? () =>
                          _viewDocument(context, state.governmentIdDoc!.fileUrl)
                    : null,
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
            buildWhen: (prev, curr) =>
                prev.certificateDoc != curr.certificateDoc ||
                prev.isUploadingDoc2 != curr.isUploadingDoc2,
            builder: (context, state) {
              return DocumentUploadCard(
                title: 'Service Certificate',
                subtitle: 'Professional license or training certificate',
                icon: Icons.workspace_premium_outlined,
                isUploaded: state.certificateDoc != null,
                isUploading: state.isUploadingDoc2,
                fileName: state.certificateDoc?.originalFilename,
                onTap: () => cubit.pickAndUploadDocument(2),
                onDelete: () => cubit.removeDocument(2),
                onView: state.certificateDoc != null
                    ? () =>
                          _viewDocument(context, state.certificateDoc!.fileUrl)
                    : null,
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

  void _viewDocument(BuildContext context, String url) {
    // Check if the URL points to an image
    final lowerUrl = url.split('?').first.toLowerCase();
    final isImage =
        lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png');

    if (isImage) {
      _showImagePreview(context, url);
    } else {
      _openInBrowser(url);
    }
  }

  void _showImagePreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Image with pinch-to-zoom
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              'Unable to load preview',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: AppSizes.sm),
                            TextButton(
                              onPressed: () => _openInBrowser(url),
                              child: const Text('Open in Browser'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Action Buttons Row
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  // Open in Browser Button
                  _CircleActionButton(
                    icon: Icons.open_in_new_rounded,
                    onTap: () => _openInBrowser(url),
                  ),
                  const SizedBox(width: 8),
                  // Close Button
                  _CircleActionButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

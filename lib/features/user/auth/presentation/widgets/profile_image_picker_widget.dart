import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/fill_profile_cubit.dart';

// Profile image picker widget
class ProfileImagePickerWidget extends StatelessWidget {
  const ProfileImagePickerWidget({super.key});

  void _showImageSourceSheet(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              HugeIcon(
                icon: HugeIcons.strokeRoundedSolidLine01,
                color: AppColors.border,
                size: 35,
              ),
              // Title
              Text(
                'Choose Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Gallery option
              _buildOptionTile(
                icon: Icons.photo_library_rounded,
                color: AppColors.primary,
                title: 'Gallery',
                subtitle: 'Choose from your photos',
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImage(ImageSource.gallery);
                },
              ),

              // Camera option
              _buildOptionTile(
                icon: Icons.camera_alt_rounded,
                color: AppColors.primary,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImage(ImageSource.camera);
                },
              ),

              // Show remove option if an image is present
              BlocBuilder<FillProfileCubit, FillProfileState>(
                bloc: cubit,
                buildWhen: (prev, curr) => prev.hasImage != curr.hasImage,
                builder: (_, state) {
                  if (!state.hasImage) return const SizedBox.shrink();
                  return _buildOptionTile(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.error,
                    title: 'Remove Photo',
                    subtitle: 'Delete current photo',
                    onTap: () {
                      Navigator.pop(context);
                      if (state.uploadedImageUrl != null) {
                        cubit.deleteUploadedImage();
                      } else {
                        cubit.clearSelectedImage();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FillProfileCubit, FillProfileState>(
      listenWhen: (prev, curr) => prev.imageStatus != curr.imageStatus,
      listener: (context, state) {
        if (state.imageStatus == ImageUploadStatus.error &&
            state.imageError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.imageError!),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      buildWhen: (prev, curr) =>
          prev.selectedImage != curr.selectedImage ||
          prev.imageStatus != curr.imageStatus ||
          prev.uploadedImageUrl != curr.uploadedImageUrl,
      builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: () => _showImageSourceSheet(context),
            child: _buildAvatar(state),
          ),
        );
      },
    );
  }

  // Avatar widget with upload status
  Widget _buildAvatar(FillProfileState state) {
    final isUploading = state.imageStatus == ImageUploadStatus.uploading;

    return Stack(
      children: [
        // Avatar
        CircleAvatar(
          radius: 56,
          backgroundColor: AppColors.surface,
          backgroundImage: _resolveImage(state),
          child: _resolveImage(state) == null
              ? const Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: AppColors.textHint,
                )
              : null,
        ),

        // Upload progress overlay
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        // Camera / Edit badge
        if (!isUploading)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: state.hasImage ? AppColors.success : AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                state.hasImage ? Icons.edit_rounded : Icons.camera_alt_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  ImageProvider? _resolveImage(FillProfileState state) {
    if (state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    }
    if (state.uploadedImageUrl != null) {
      return NetworkImage(state.uploadedImageUrl!);
    }
    return null;
  }

  // Option tile builder for gallery, camera and remove action
  Widget _buildOptionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}

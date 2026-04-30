import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/auth/presentation/cubit/fill_profile_cubit.dart';
import 'package:serviko_app/core/widgets/image_picker_bottom_sheet.dart';

// Profile image picker widget
class ProfileImagePickerWidget extends StatelessWidget {
  const ProfileImagePickerWidget({super.key});

  void _showImageSourceSheet(BuildContext context) {
    final cubit = context.read<FillProfileCubit>();
    final state = cubit.state;

    ImagePickerBottomSheet.show(
      context,
      onGalleryTap: () => cubit.pickImage(ImageSource.gallery),
      onCameraTap: () => cubit.pickImage(ImageSource.camera),
      onRemoveTap: state.hasImage
          ? () {
              if (state.uploadedImageUrl != null) {
                cubit.deleteUploadedImage();
              } else {
                cubit.clearSelectedImage();
              }
            }
          : null,
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

  // Avatar widget
  Widget _buildAvatar(FillProfileState state) {
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

        // Camera / Edit badge
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
}

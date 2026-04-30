import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:serviko_app/features/user/profile/presentation/cubit/edit_profile_state.dart';
import 'package:serviko_app/core/widgets/image_picker_bottom_sheet.dart';

class EditProfileImagePicker extends StatelessWidget {
  const EditProfileImagePicker({super.key});

  void _showImageSourceSheet(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    final state = cubit.state;

    ImagePickerBottomSheet.show(
      context,
      onGalleryTap: () => cubit.pickImage(ImageSource.gallery),
      onCameraTap: () => cubit.pickImage(ImageSource.camera),
      onRemoveTap: state.hasImage ? () => cubit.removeImage() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          BlocBuilder<EditProfileCubit, EditProfileState>(
            buildWhen: (prev, curr) =>
                prev.selectedImage != curr.selectedImage ||
                prev.uploadedImageUrl != curr.uploadedImageUrl ||
                prev.hasImage != curr.hasImage ||
                prev.isDeleted != curr.isDeleted,
            builder: (context, state) {
              return CircleAvatar(
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
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showImageSourceSheet(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _resolveImage(EditProfileState state) {
    if (state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    }
    if (!state.isDeleted &&
        state.uploadedImageUrl != null &&
        state.uploadedImageUrl!.isNotEmpty) {
      return NetworkImage(state.uploadedImageUrl!);
    }
    return null;
  }
}

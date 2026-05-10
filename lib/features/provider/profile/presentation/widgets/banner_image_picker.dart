import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/banner_image_picker_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/banner_image_picker_state.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_cubit.dart';
import 'package:serviko_app/features/provider/profile/presentation/cubit/edit_provider_details_state.dart';
import 'package:serviko_app/core/widgets/image_picker_bottom_sheet.dart';
import 'dart:io';

class BannerImagePicker extends StatelessWidget {
  final String? initialImageUrl;

  const BannerImagePicker({super.key, this.initialImageUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannerImagePickerCubit(),
      child: _BannerImagePickerView(initialImageUrl: initialImageUrl),
    );
  }
}

class _BannerImagePickerView extends StatelessWidget {
  final String? initialImageUrl;

  const _BannerImagePickerView({this.initialImageUrl});

  void _showImageSourceSheet(
    BuildContext context,
    BannerImagePickerState pickerState,
  ) {
    final cubit = context.read<EditProviderDetailsCubit>();
    final pickerCubit = context.read<BannerImagePickerCubit>();
    final hasImage =
        pickerState.selectedImage != null ||
        (!(pickerState.isDeleted) && initialImageUrl != null);

    ImagePickerBottomSheet.show(
      context,
      onGalleryTap: () =>
          _pickImage(ImageSource.gallery, context, cubit, pickerCubit),
      onCameraTap: () =>
          _pickImage(ImageSource.camera, context, cubit, pickerCubit),
      onRemoveTap: hasImage
          ? () => _removeImage(context, cubit, pickerCubit)
          : null,
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    BuildContext context,
    EditProviderDetailsCubit cubit,
    BannerImagePickerCubit pickerCubit,
  ) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (image != null) {
        final file = File(image.path);
        pickerCubit.setImage(file);
        await cubit.uploadBannerImage(file);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _removeImage(
    BuildContext context,
    EditProviderDetailsCubit cubit,
    BannerImagePickerCubit pickerCubit,
  ) async {
    pickerCubit.removeImage();
    await cubit.deleteBannerImage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerImagePickerCubit, BannerImagePickerState>(
      builder: (context, pickerState) {
        return BlocConsumer<EditProviderDetailsCubit, EditProviderDetailsState>(
          listenWhen: (prev, curr) =>
              curr is BannerImageUploadError || curr is BannerImageDeleteError,
          listener: (context, state) {
            if (state is BannerImageUploadError ||
                state is BannerImageDeleteError) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to upload/delete banner image. Please try again.',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          buildWhen: (prev, curr) =>
              curr is BannerImageUploadLoading ||
              curr is BannerImageDeleteLoading ||
              curr is BannerImageUploadSuccess ||
              curr is BannerImageDeleteSuccess ||
              curr is BannerImageUploadError ||
              curr is BannerImageDeleteError,
          builder: (context, state) {
            final isLoading =
                state is BannerImageUploadLoading ||
                state is BannerImageDeleteLoading;

            return GestureDetector(
              onTap: isLoading
                  ? null
                  : () => _showImageSourceSheet(context, pickerState),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  image: _resolveImage(pickerState) != null
                      ? DecorationImage(
                          image: _resolveImage(pickerState)!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_resolveImage(pickerState) == null && !isLoading)
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: AppColors.textHint,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload Banner Image',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (_resolveImage(pickerState) != null && isLoading)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    if (isLoading) const CircularProgressIndicator(),
                    if (_resolveImage(pickerState) != null && !isLoading)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  ImageProvider? _resolveImage(BannerImagePickerState state) {
    if (state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    }
    if (!state.isDeleted &&
        initialImageUrl != null &&
        initialImageUrl!.isNotEmpty) {
      return NetworkImage(initialImageUrl!);
    }
    return null;
  }
}

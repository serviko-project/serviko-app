import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

// Profile Image Picker Widget
class ProfileImagePickerWidget extends StatelessWidget {
  const ProfileImagePickerWidget({super.key});

  void _onPickProfileImage() {
    // TODO: Implement image picker
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _onPickProfileImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.surface,
              child: const Icon(
                Icons.person_rounded,
                size: 56,
                color: AppColors.textHint,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

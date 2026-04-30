import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

// Common bottom sheet for picking image source (Gallery/Camera/Remove)
class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback? onRemoveTap;

  const ImagePickerBottomSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    this.onRemoveTap,
  });

  // Helper method to show the bottom sheet
  static void show(
    BuildContext context, {
    required VoidCallback onGalleryTap,
    required VoidCallback onCameraTap,
    VoidCallback? onRemoveTap,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ImagePickerBottomSheet(
        onGalleryTap: onGalleryTap,
        onCameraTap: onCameraTap,
        onRemoveTap: onRemoveTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSolidLine01,
              color: AppColors.border,
              size: 35,
            ),
            // Title
            const Text(
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
                onGalleryTap();
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
                onCameraTap();
              },
            ),

            // Remove option
            if (onRemoveTap != null)
              _buildOptionTile(
                icon: Icons.delete_outline_rounded,
                color: AppColors.error,
                title: 'Remove Photo',
                subtitle: 'Delete current photo',
                onTap: () {
                  Navigator.pop(context);
                  onRemoveTap!();
                },
              ),
          ],
        ),
      ),
    );
  }

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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}

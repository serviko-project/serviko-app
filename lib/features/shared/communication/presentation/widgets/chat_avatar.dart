import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_colors.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 58,
        height: 58,
        color: AppColors.surface,
        child: imageUrl == null || imageUrl!.isEmpty
            ? const Icon(Icons.person, color: AppColors.primary)
            : CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    const Icon(Icons.person, color: AppColors.primary),
              ),
      ),
    );
  }
}

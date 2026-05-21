import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/pages/chat_screen.dart';

// Provider Chat Button
class ProviderChatButton extends StatelessWidget {
  final String providerId;
  final String? providerFirebaseUid;
  final String? providerName;
  final String? providerImage;
  final String? categoryName;

  const ProviderChatButton({
    super.key,
    required this.providerId,
    this.providerFirebaseUid,
    this.providerName,
    this.providerImage,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton.replace(
      replacement: const Bone.circle(size: 40),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedMessage02,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: () {
            final firebaseUid = providerFirebaseUid;
            if (firebaseUid == null || firebaseUid.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unable to chat — provider info unavailable.'),
                ),
              );
              return;
            }

            final authState = context.read<AuthBloc>().state;
            if (authState is AuthAuthenticated) {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    contact: ProviderDirectoryEntity(
                      id: providerId,
                      userId: providerId,
                      firebaseUid: firebaseUid,
                      name: providerName,
                      profileImageUrl: providerImage,
                      professionalTitle: categoryName,
                      categories: categoryName != null
                          ? [categoryName!]
                          : const [],
                    ),
                    customerFirebaseUid: authState.user.uid,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please sign in to chat with this provider.'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

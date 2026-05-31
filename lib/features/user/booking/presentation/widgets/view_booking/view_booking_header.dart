import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';
import 'package:serviko_app/features/shared/communication/presentation/widgets/provider_chat_button.dart';

class ViewBookingHeader extends StatelessWidget {
  final BookingEntity booking;

  const ViewBookingHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final isBookingOwner = booking.customerFirebaseUid == currentUserUid;

    final displayName = isBookingOwner
        ? (booking.providerName ?? 'Unknown Provider')
        : (booking.customerName ?? 'Customer');

    final displayImage = isBookingOwner
        ? booking.providerImage
        : booking.customerImage;

    final displaySubtitle = isBookingOwner
        ? (booking.categoryName ?? 'Service')
        : 'Customer';

    final chatRecipientId = isBookingOwner
        ? booking.providerId
        : booking.customerId;
    final chatRecipientFirebaseUid = isBookingOwner
        ? booking.providerFirebaseUid
        : booking.customerFirebaseUid;
    final chatRecipientName = isBookingOwner
        ? booking.providerName
        : booking.customerName;
    final chatRecipientImage = isBookingOwner
        ? booking.providerImage
        : booking.customerImage;
    final chatRecipientTitle = isBookingOwner
        ? booking.categoryName
        : 'Customer';

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            image: displayImage != null
                ? DecorationImage(
                    image: NetworkImage(displayImage),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: displayImage == null
              ? const HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: AppColors.textSecondary,
                )
              : null,
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: AppTextStyles.h3),
              Text(
                displaySubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Chat Button
        ProviderChatButton(
          providerId: chatRecipientId,
          providerFirebaseUid: chatRecipientFirebaseUid,
          providerName: chatRecipientName,
          providerImage: chatRecipientImage,
          categoryName: chatRecipientTitle,
        ),
      ],
    );
  }
}

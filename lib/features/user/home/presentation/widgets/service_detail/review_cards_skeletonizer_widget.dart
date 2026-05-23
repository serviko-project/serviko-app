import 'package:flutter/material.dart';
import 'package:serviko_app/features/user/booking/domain/entities/review_entity.dart';
import 'package:serviko_app/features/user/home/presentation/widgets/service_detail/review_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewCardsSkeletonizerWidget extends StatelessWidget {
  const ReviewCardsSkeletonizerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          3,
          (index) => ReviewCard(
            review: ReviewEntity(
              id: '$index',
              bookingId: 'booking_$index',
              customerId: 'customer_$index',
              customerName: 'Customer $index',
              providerServiceId: 'provider_service_$index',
              rating: 5,
              comment:
                  'This is a sample review comment text to render the loading state',
              createdAt: DateTime.now().toIso8601String(),
            ),
          ),
        ),
      ),
    );
  }
}

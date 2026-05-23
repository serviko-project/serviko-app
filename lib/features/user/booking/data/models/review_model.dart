import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.bookingId,
    required super.customerId,
    required super.customerName,
    super.customerImage,
    required super.providerServiceId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: (json['id'] as String?) ?? '',
      bookingId: (json['booking_id'] as String?) ?? '',
      customerId: (json['customer_id'] as String?) ?? '',
      customerName: (json['customer_name'] as String?) ?? '',
      customerImage: json['customer_image'] as String?,
      providerServiceId: (json['provider_service_id'] as String?) ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: (json['comment'] as String?) ?? '',
      createdAt: (json['created_at'] as String?) ?? '',
    );
  }
}

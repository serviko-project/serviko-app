import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String bookingId;
  final String customerId;
  final String customerName;
  final String? customerImage;
  final String providerServiceId;
  final int rating;
  final String comment;
  final String createdAt;

  const ReviewEntity({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.customerName,
    this.customerImage,
    required this.providerServiceId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    bookingId,
    customerId,
    customerName,
    customerImage,
    providerServiceId,
    rating,
    comment,
    createdAt,
  ];
}

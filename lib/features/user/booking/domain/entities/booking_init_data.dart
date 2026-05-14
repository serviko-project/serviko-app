import 'package:equatable/equatable.dart';

// Data passed from ServiceDetailScreen to BookingDetailsScreen
class BookingInitData extends Equatable {
  final String serviceId;
  final String providerId;
  final String categoryId;
  final String categoryName;
  final String providerName;
  final String? providerImage;
  final double basePricePerHour;

  const BookingInitData({
    required this.serviceId,
    required this.providerId,
    required this.categoryId,
    required this.categoryName,
    required this.providerName,
    this.providerImage,
    required this.basePricePerHour,
  });

  @override
  List<Object?> get props => [
    serviceId,
    providerId,
    categoryId,
    categoryName,
    providerName,
    providerImage,
    basePricePerHour,
  ];
}

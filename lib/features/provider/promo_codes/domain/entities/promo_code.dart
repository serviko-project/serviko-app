import 'package:equatable/equatable.dart';

class PromoCode extends Equatable {
  final String id;
  final String providerId;
  final String code;
  final String? description;
  final String discountType;
  final double discountValue;
  final double? minBookingAmount;
  final int? maxUses;
  final double? maxDiscountAmount;
  final DateTime? expiresAt;
  final int maxUsesPerCustomer;
  final bool isActive;
  final int usageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PromoCode({
    required this.id,
    required this.providerId,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minBookingAmount,
    this.maxUses,
    this.maxDiscountAmount,
    this.expiresAt,
    required this.maxUsesPerCustomer,
    required this.isActive,
    required this.usageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    providerId,
    code,
    description,
    discountType,
    discountValue,
    minBookingAmount,
    maxUses,
    maxDiscountAmount,
    expiresAt,
    maxUsesPerCustomer,
    isActive,
    usageCount,
    createdAt,
    updatedAt,
  ];
}

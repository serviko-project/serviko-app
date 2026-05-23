import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

class PromoCodeModel extends PromoCode {
  const PromoCodeModel({
    required super.id,
    required super.providerId,
    required super.code,
    super.description,
    required super.discountType,
    required super.discountValue,
    super.minBookingAmount,
    super.maxUses,
    super.maxDiscountAmount,
    super.expiresAt,
    required super.maxUsesPerCustomer,
    required super.isActive,
    required super.usageCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id'] as String? ?? '',
      providerId: json['provider_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String?,
      discountType: json['discount_type'] as String? ?? 'percentage',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
      minBookingAmount: (json['min_booking_amount'] as num?)?.toDouble(),
      maxUses: json['max_uses'] as int?,
      maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String).toLocal()
          : null,
      maxUsesPerCustomer: json['max_uses_per_customer'] as int? ?? 1,
      isActive: json['is_active'] as bool? ?? true,
      usageCount: json['usage_count'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_booking_amount': minBookingAmount,
      'max_uses': maxUses,
      'max_discount_amount': maxDiscountAmount,
      'expires_at': expiresAt?.toUtc().toIso8601String(),
      'max_uses_per_customer': maxUsesPerCustomer,
      'is_active': isActive,
      'usage_count': usageCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

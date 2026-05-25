import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/provider/promo_codes/domain/entities/promo_code.dart';

abstract class PromoCodeRepository {
  Future<Either<Failure, List<PromoCode>>> getPromoCodes({
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, PromoCode>> createPromoCode(Map<String, dynamic> data);

  Future<Either<Failure, PromoCode>> updatePromoCode(
    String promoId,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, PromoCode>> deactivatePromoCode(String promoId);
}

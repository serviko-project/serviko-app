import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';
import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<FaqItem>>> getFAQs({
    String? category,
    String? search,
  });

  Future<Either<Failure, PrivacyPolicyItem>> getPrivacyPolicy();
}

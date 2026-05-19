import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/support/domain/entities/privacy_policy_item.dart';
import 'package:serviko_app/features/shared/support/domain/repositories/support_repository.dart';

// Use case to retrieve the active Privacy Policy
class GetPrivacyPolicyUseCase implements UseCase<PrivacyPolicyItem, NoParams> {
  final SupportRepository repository;

  const GetPrivacyPolicyUseCase(this.repository);

  @override
  Future<Either<Failure, PrivacyPolicyItem>> call(NoParams params) {
    return repository.getPrivacyPolicy();
  }
}

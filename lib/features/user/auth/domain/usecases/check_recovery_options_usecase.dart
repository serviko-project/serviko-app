import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/user/auth/domain/entities/password_recovery_options_entity.dart';
import 'package:serviko_app/features/user/auth/domain/repositories/auth_repository.dart';

class CheckRecoveryOptionsUseCase
    extends UseCase<PasswordRecoveryOptionsEntity, CheckRecoveryOptionsParams> {
  final AuthRepository repository;

  CheckRecoveryOptionsUseCase(this.repository);

  @override
  Future<Either<Failure, PasswordRecoveryOptionsEntity>> call(
    CheckRecoveryOptionsParams params,
  ) {
    return repository.checkRecoveryOptionsByEmail(email: params.email);
  }
}

class CheckRecoveryOptionsParams extends Equatable {
  final String email;

  const CheckRecoveryOptionsParams({required this.email});

  @override
  List<Object?> get props => [email];
}

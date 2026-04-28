import 'package:serviko_app/features/user/auth/domain/entities/user_entity.dart';
import 'package:serviko_app/features/user/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  UserEntity? call() => repository.getCurrentUser();
}

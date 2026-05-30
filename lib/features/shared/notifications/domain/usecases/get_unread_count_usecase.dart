import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class GetUnreadCountUseCase implements UseCase<int, NoParams> {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getUnreadCount();
  }
}

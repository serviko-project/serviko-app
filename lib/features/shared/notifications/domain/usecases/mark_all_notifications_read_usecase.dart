import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class MarkAllNotificationsReadUseCase implements UseCase<void, NoParams> {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.markAllNotificationsRead();
  }
}

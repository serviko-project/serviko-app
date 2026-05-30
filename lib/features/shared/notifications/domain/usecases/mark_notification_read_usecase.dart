import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.markNotificationRead(params);
  }
}

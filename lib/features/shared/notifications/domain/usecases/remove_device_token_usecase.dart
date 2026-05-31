import 'package:dartz/dartz.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class RemoveDeviceTokenUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  RemoveDeviceTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.removeDeviceToken(fcmToken: params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class RegisterDeviceTokenUseCase
    implements UseCase<void, RegisterDeviceTokenParams> {
  final NotificationRepository repository;

  RegisterDeviceTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterDeviceTokenParams params) {
    return repository.registerDeviceToken(
      fcmToken: params.fcmToken,
      deviceType: params.deviceType,
    );
  }
}

class RegisterDeviceTokenParams extends Equatable {
  final String fcmToken;
  final String deviceType;

  const RegisterDeviceTokenParams({
    required this.fcmToken,
    required this.deviceType,
  });

  @override
  List<Object?> get props => [fcmToken, deviceType];
}

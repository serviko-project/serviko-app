import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/notifications/domain/entities/notification_entity.dart';
import 'package:serviko_app/features/shared/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotifications(page: params.page, limit: params.limit);
  }
}

class GetNotificationsParams extends Equatable {
  final int page;
  final int limit;

  const GetNotificationsParams({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}

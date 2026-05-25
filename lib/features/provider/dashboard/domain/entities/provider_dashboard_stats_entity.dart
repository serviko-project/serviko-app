import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/booking/domain/entities/booking_entity.dart';

// Provider dashboard stats entity
class ProviderDashboardStatsEntity extends Equatable {
  final double todayEarnings;
  final int activeJobsCount;
  final int newRequestsCount;
  final double rating;
  final BookingEntity? nextJob;

  const ProviderDashboardStatsEntity({
    required this.todayEarnings,
    required this.activeJobsCount,
    required this.newRequestsCount,
    required this.rating,
    this.nextJob,
  });

  @override
  List<Object?> get props => [
    todayEarnings,
    activeJobsCount,
    newRequestsCount,
    rating,
    nextJob,
  ];
}

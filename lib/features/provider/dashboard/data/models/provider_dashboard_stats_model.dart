import 'package:serviko_app/features/user/booking/data/models/booking_model.dart';
import '../../domain/entities/provider_dashboard_stats_entity.dart';

// Provider Dashboard Stats Model
class ProviderDashboardStatsModel extends ProviderDashboardStatsEntity {
  const ProviderDashboardStatsModel({
    required super.todayEarnings,
    required super.activeJobsCount,
    required super.newRequestsCount,
    required super.rating,
    super.nextJob,
  });

  factory ProviderDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return ProviderDashboardStatsModel(
      todayEarnings: (json['today_earnings'] as num?)?.toDouble() ?? 0.0,
      activeJobsCount: (json['active_jobs_count'] as num?)?.toInt() ?? 0,
      newRequestsCount: (json['new_requests_count'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      nextJob: json['next_job'] != null
          ? BookingModel.fromJson(json['next_job'] as Map<String, dynamic>)
          : null,
    );
  }
}

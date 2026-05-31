import 'package:serviko_app/features/user/booking/data/datasources/booking_remote_data_source.dart';
import 'package:serviko_app/features/user/booking/data/repositories/booking_repository_impl.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/complete_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/create_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_available_slots_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_promos_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_bookings_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/review_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_customer_bookings_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/submit_review_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_provider_reviews_stats_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/validate_promo_code_usecase.dart';
import 'package:serviko_app/features/user/booking/domain/usecases/get_active_promo_codes_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize booking dependencies
extension BookingDI on InjectionContainer {
  void initBooking() {
    // Booking
    bookingRemoteDataSource = BookingRemoteDataSourceImpl(apiClient: apiClient);
    bookingRepository = BookingRepositoryImpl(
      remoteDataSource: bookingRemoteDataSource,
      networkInfo: networkInfo,
    );
    getAvailableSlotsUseCase = GetAvailableSlotsUseCase(bookingRepository);
    getProviderPromosUseCase = GetProviderPromosUseCase(bookingRepository);
    getActivePromoCodesUseCase = GetActivePromoCodesUseCase(bookingRepository);
    createBookingUseCase = CreateBookingUseCase(bookingRepository);
    getProviderBookingsUseCase = GetProviderBookingsUseCase(bookingRepository);
    reviewBookingUseCase = ReviewBookingUseCase(bookingRepository);
    getBookingDetailUseCase = GetBookingDetailUseCase(bookingRepository);
    cancelBookingUseCase = CancelBookingUseCase(bookingRepository);
    completeBookingUseCase = CompleteBookingUseCase(bookingRepository);
    getCustomerBookingsUseCase = GetCustomerBookingsUseCase(bookingRepository);
    submitReviewUseCase = SubmitReviewUseCase(bookingRepository);
    getProviderReviewsUseCase = GetProviderReviewsUseCase(bookingRepository);
    getProviderReviewsStatsUseCase = GetProviderReviewsStatsUseCase(
      bookingRepository,
    );
    validatePromoCodeUseCase = ValidatePromoCodeUseCase(bookingRepository);
  }
}

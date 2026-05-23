import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_button.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/view_booking_state.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_state.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/review_bottom_sheet_parts/review_comment_input.dart';
import 'package:serviko_app/features/user/booking/presentation/widgets/view_booking/review_bottom_sheet_parts/review_rating_selector.dart';

class ReviewBottomSheet extends StatelessWidget {
  final String bookingId;

  const ReviewBottomSheet({super.key, required this.bookingId});

  static Future<void> show(
    BuildContext context, {
    required String bookingId,
    required ViewBookingCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider(create: (_) => ReviewFormCubit()),
        ],
        child: ReviewBottomSheet(bookingId: bookingId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<ViewBookingCubit, ViewBookingState>(
      listener: (context, state) {
        if (state.actionStatus == ViewBookingActionStatus.success) {
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.screenPadding,
            right: AppSizes.screenPadding,
            top: 12,
            bottom: AppSizes.screenPadding * 2 + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Title
              Text(
                'Rate Your Experience',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSizes.md),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: AppSizes.lg),

              // Review Rating Selector
              const ReviewRatingSelector(),
              const SizedBox(height: AppSizes.xl),

              // Review Comment Input
              const ReviewCommentInput(),
              const SizedBox(height: AppSizes.lg),

              // Submit Button
              BlocBuilder<ViewBookingCubit, ViewBookingState>(
                builder: (context, bookingState) {
                  final isLoading =
                      bookingState.actionStatus ==
                      ViewBookingActionStatus.loading;

                  return BlocBuilder<ReviewFormCubit, ReviewFormState>(
                    builder: (context, formState) {
                      return CustomButton(
                        text: 'Submit Review',
                        isLoading: isLoading,
                        onPressed: formState.isValid
                            ? () {
                                context.read<ViewBookingCubit>().submitReview(
                                  bookingId: bookingId,
                                  rating: formState.selectedRating,
                                  comment: formState.comment.trim(),
                                );
                              }
                            : null,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

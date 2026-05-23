import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_text_field.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_cubit.dart';
import 'package:serviko_app/features/user/booking/presentation/bloc/review_form_state.dart';

class ReviewCommentInput extends StatefulWidget {
  const ReviewCommentInput({super.key});

  @override
  State<ReviewCommentInput> createState() => _ReviewCommentInputState();
}

class _ReviewCommentInputState extends State<ReviewCommentInput> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentController.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();
    super.dispose();
  }

  void _onCommentChanged() {
    context.read<ReviewFormCubit>().updateComment(_commentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _commentController,
          labelText: 'Write Your Review (Required)',
          hintText: 'Share details of your experience...',
          maxLines: 4,
        ),
        const SizedBox(height: 6),

        // Custom Character Counter
        Align(
          alignment: Alignment.centerRight,
          child: BlocBuilder<ReviewFormCubit, ReviewFormState>(
            buildWhen: (previous, current) =>
                previous.commentLength != current.commentLength,
            builder: (context, state) {
              return Text(
                '${state.commentLength} / 500',
                style: AppTextStyles.bodySmall.copyWith(
                  color: state.commentLength > 450
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

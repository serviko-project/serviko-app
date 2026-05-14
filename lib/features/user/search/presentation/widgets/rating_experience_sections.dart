import 'package:flutter/material.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/features/user/search/domain/models/filter_enums.dart';
import 'package:serviko_app/features/user/search/presentation/bloc/filter_cubit.dart';
import 'package:serviko_app/features/user/search/presentation/bloc/filter_state.dart';
import 'filter_choice_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Rating and Experience filter sections for the search screen
class RatingSection extends StatelessWidget {
  final FilterState state;

  const RatingSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rating', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: RatingFilter.values.map((rating) {
              return FilterChoiceChip(
                label: rating.displayName,
                isSelected: state.rating == rating,
                showStar: true,
                onSelected: (selected) {
                  if (selected) {
                    context.read<FilterCubit>().setRating(rating);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ExperienceSection extends StatelessWidget {
  final FilterState state;

  const ExperienceSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Years of Experience', style: AppTextStyles.h3),
        const SizedBox(height: AppSizes.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ExperienceFilter.values.map((experience) {
              return FilterChoiceChip(
                label: experience.displayName,
                isSelected: state.experience == experience,
                onSelected: (selected) {
                  if (selected) {
                    context.read<FilterCubit>().setExperience(experience);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

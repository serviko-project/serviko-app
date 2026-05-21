import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/faqs_empty_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/faq_cubit.dart';
import 'package:serviko_app/features/shared/support/presentation/cubits/faq_state.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/category_chips_list.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/faq_accordion_tile.dart';
import 'package:serviko_app/features/shared/support/presentation/widgets/help_center_search_bar.dart';
import 'package:serviko_app/injection_container.dart';

// Help Center Screen
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  static const List<String> _categories = [
    'All',
    'General',
    'Account',
    'Services',
    'Payments',
  ];

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FaqCubit>(
      create: (context) =>
          FaqCubit(getFAQsUseCase: InjectionContainer.instance.getFAQsUseCase)
            ..loadFAQs(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const CustomAppBar(title: 'Help Center'),
        body: BlocBuilder<FaqCubit, FaqState>(
          builder: (context, state) {
            return Column(
              children: [
                // Top search and chip filters
                Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                    vertical: AppSizes.md,
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      HelpCenterSearchBar(controller: searchController),
                      const SizedBox(height: AppSizes.md),

                      // Category Chips
                      const CategoryChipsList(
                        categories: HelpCenterScreen._categories,
                      ),
                    ],
                  ),
                ),

                // Accordion FAQs lists
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is FaqLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: _buildFaqList(
                            List.generate(
                              4,
                              (index) => FaqItem(
                                id: '$index',
                                question: 'This is a sample question $index',
                                answer: 'Answer $index ',
                                category: 'Category $index',
                                isActive: true,
                              ),
                            ),
                          ),
                        );
                      } else if (state is FaqError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.lg),
                            child: CustomErrorWidget(
                              message: state.message,
                              onRetry: () =>
                                  context.read<FaqCubit>().loadFAQs(),
                            ),
                          ),
                        );
                      } else if (state is FaqLoaded) {
                        if (state.faqs.isEmpty) {
                          return const FAQsEmptyState();
                        }
                        return _buildFaqList(state.faqs);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFaqList(List<FaqItem> faqs) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPadding,
        vertical: AppSizes.md,
      ),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return FaqAccordionTile(faq: faqs[index]);
      },
    );
  }
}

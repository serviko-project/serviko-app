import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/router/app_router.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/injection_container.dart';
import '../cubit/earnings_cubit.dart';
import '../cubit/earnings_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/earnings_filter_toggle.dart';
import '../widgets/custom_earnings_graph.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/cash_out_bottom_sheet.dart';

// Provider Earnings Page
class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarningsCubit(
        getEarningsSummaryUseCase:
            InjectionContainer.instance.getEarningsSummaryUseCase,
      )..loadEarnings('Weekly'),
      child: const EarningsView(),
    );
  }
}

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Earnings", leading: const SizedBox.shrink()),
      body: BlocBuilder<EarningsCubit, EarningsState>(
        buildWhen: (previous, current) {
          if (previous.runtimeType != current.runtimeType) return true;
          if (previous is EarningsLoaded && current is EarningsLoaded) {
            if (current.isGraphLoading && !previous.isGraphLoading) {
              return false;
            }
            if (!current.isGraphLoading && previous.isGraphLoading) return true;
            return true;
          }
          return true;
        },
        builder: (context, state) {
          if (state is EarningsLoading || state is EarningsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EarningsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<EarningsCubit>().loadEarnings('Weekly'),
              isFullPage: true,
            );
          }
          // Earnings Loaded State
          if (state is EarningsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EarningsCubit>().loadEarnings(
                  state.selectedFilter,
                  startDate: state.startDate,
                  endDate: state.endDate,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Available Balance & Cash Out
                    BalanceCard(
                      balance: state.summary.availableBalance,
                      onCashOut: () {
                        CashOutBottomSheet.show(
                          context,
                          maxAmount: state.summary.availableBalance,
                          onSuccess: () {
                            context.read<EarningsCubit>().loadEarnings(
                              state.selectedFilter,
                              startDate: state.startDate,
                              endDate: state.endDate,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Earnings Filter Toggle
                    EarningsFilterToggle(
                      selectedFilter: state.selectedFilter,
                      onFilterChanged: (filter) async {
                        if (filter == 'Custom') {
                          final now = DateTime.now();
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: now.subtract(
                              const Duration(days: 365 * 5),
                            ),
                            lastDate: now,
                            initialDateRange: DateTimeRange(
                              start: now.subtract(const Duration(days: 7)),
                              end: now,
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null && context.mounted) {
                            context.read<EarningsCubit>().loadEarnings(
                              filter,
                              startDate: picked.start,
                              endDate: picked.end,
                            );
                          }
                        } else {
                          context.read<EarningsCubit>().loadEarnings(filter);
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Earnings Graph
                    BlocBuilder<EarningsCubit, EarningsState>(
                      buildWhen: (previous, current) {
                        if (current is EarningsLoaded) return true;
                        return false;
                      },
                      builder: (context, graphState) {
                        if (graphState is EarningsLoaded) {
                          if (graphState.isGraphLoading) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return CustomEarningsGraph(
                            summary: graphState.summary,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: AppSizes.md),

                    // Recent Transactions
                    RecentTransactionsList(
                      transactions: state.recentTransactions,
                      onSeeAll: () {
                        context.pushNamed(AppRouter.providerTransactionHistory);
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

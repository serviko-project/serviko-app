import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import 'package:serviko_app/core/constants/app_sizes.dart';
import 'package:serviko_app/core/theme/text_styles.dart';
import 'package:serviko_app/core/widgets/custom_app_bar.dart';
import 'package:serviko_app/core/widgets/custom_error_widget.dart';
import 'package:serviko_app/features/provider/earnings/presentation/widgets/transaction_list_tile.dart';
import '../../../../../../injection_container.dart';
import '../../domain/entities/transaction_entity.dart';
import '../cubit/transactions_cubit.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TransactionsCubit(InjectionContainer.instance.getTransactionsUseCase)
            ..fetchTransactions(refresh: true),
      child: const TransactionHistoryView(),
    );
  }
}

class TransactionHistoryView extends StatefulWidget {
  const TransactionHistoryView({super.key});

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TransactionsCubit>().fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Transaction History"),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          // Loading State
          if (state is TransactionsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          // Error State
          else if (state is TransactionsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<TransactionsCubit>()
                  .fetchTransactions(refresh: true),
            );
          }
          // Empty State and Transactions List State
          else if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTransactionList(
              state.transactions,
              state.hasReachedMax,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions_outlined,
            size: AppSizes.iconXl * 2,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'No transactions yet..!!',
            style: AppTextStyles.h2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Your booking and cash out history will appear here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    List<TransactionEntity> transactions,
    bool hasReachedMax,
  ) {
    final groupedTransactions = _groupTransactionsByDate(transactions);
    final dates = groupedTransactions.keys.toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () =>
          context.read<TransactionsCubit>().fetchTransactions(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: dates.length + (hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= dates.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          final date = dates[index];
          final txList = groupedTransactions[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                child: Text(date, style: AppTextStyles.labelLarge),
              ),
              ...txList.map(
                (tx) => TransactionListTile(
                  isCredit: tx.isCredit,
                  title: tx.title,
                  amount: tx.amount,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
            ],
          );
        },
      ),
    );
  }

  // Helper method to group transactions by date
  Map<String, List<TransactionEntity>> _groupTransactionsByDate(
    List<TransactionEntity> transactions,
  ) {
    final Map<String, List<TransactionEntity>> grouped = {};
    for (var tx in transactions) {
      final dateStr = tx.dateStr;
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(tx);
    }
    return grouped;
  }
}

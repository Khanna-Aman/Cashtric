import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_list_item.dart';
import '../services/transaction_service.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onTransactionTap;
  final VoidCallback onRefresh;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.onTransactionTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: transactions.map((transaction) {
        return TransactionListItem(
          transaction: transaction,
          onTap: () => onTransactionTap(transaction),
          onDelete: () => _handleDelete(context, transaction.id),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first transaction',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, String transactionId) {
    // Delete the transaction and refresh
    final transactionService = TransactionService();
    transactionService.deleteTransaction(transactionId);
    onRefresh();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction deleted successfully'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

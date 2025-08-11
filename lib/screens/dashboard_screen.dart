import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions_widget.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onNavigateToTransactions;

  const DashboardScreen({super.key, this.onNavigateToTransactions});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    // Initialize sample data on first run
    _transactionService.initializeSampleData();
  }

  void _refreshData() {
    setState(() {
      // Trigger rebuild to show updated data
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = _transactionService.getTotalBalance();
    final totalIncome = _transactionService.getTotalIncome();
    final totalExpenses = _transactionService.getTotalExpenses();
    final recentTransactions =
        _transactionService.getRecentTransactions(limit: 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashtric'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Overview Card
              BalanceCard(
                totalBalance: totalBalance,
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
              ),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: 24),

              // Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: widget.onNavigateToTransactions,
                    child: const Text('View All'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Recent Transactions List
              RecentTransactionsWidget(
                transactions: recentTransactions,
                onTransactionTap: (transaction) {
                  // Handle transaction tap
                  _showTransactionDetails(transaction);
                },
                onRefresh: _refreshData,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "dashboard_fab",
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );

          if (result == true) {
            _refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: 'Add Income',
                    color: Colors.green,
                    onTap: () => _navigateToAddTransaction(isIncome: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.remove,
                    label: 'Add Expense',
                    color: Colors.red,
                    onTap: () => _navigateToAddTransaction(isIncome: false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTransaction({required bool isIncome}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(initialIsIncome: isIncome),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  void _showTransactionDetails(transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${DateFormatter.formatCurrency(transaction.amount)}'),
            Text('Category: ${transaction.category}'),
            Text('Date: ${DateFormatter.formatDate(transaction.date)}'),
            Text('Type: ${transaction.isIncome ? 'Income' : 'Expense'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTransaction(transaction.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction(String id) {
    final success = _transactionService.deleteTransaction(id);
    if (success) {
      _refreshData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully')),
      );
    }
  }
}

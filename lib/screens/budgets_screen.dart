import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/budget_service.dart';
import '../utils/date_formatter.dart';
import 'add_budget_screen.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final BudgetService _budgetService = BudgetService.instance;

  Future<void> _refreshBudgets() async {
    // Simulate network delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // This will trigger a rebuild and refresh the budget data
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgets = _budgetService.getAllBudgets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => const AddBudgetScreen(),
                ),
              );

              if (result == true) {
                setState(() {
                  // Refresh the budgets list
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBudgets,
        child:
            budgets.isEmpty ? _buildEmptyState() : _buildBudgetsList(budgets),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "budgets_fab",
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddBudgetScreen(),
            ),
          );

          if (result == true) {
            setState(() {
              // Refresh the budgets list
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No Budgets Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first budget to start tracking expenses',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetsList(List<Budget> budgets) {
    return Column(
      children: [
        // Budget Summary Card
        _buildBudgetSummary(budgets),

        // Budget List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return _buildBudgetCard(budget);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSummary(List<Budget> budgets) {
    final totalBudget = _budgetService.getTotalBudgetAmount();
    final totalSpent = _budgetService.getTotalSpentAmount();
    final remaining = totalBudget - totalSpent;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Budget',
                  DateFormatter.formatCurrency(totalBudget),
                  Colors.blue,
                ),
                _buildSummaryItem(
                  'Spent',
                  DateFormatter.formatCurrency(totalSpent),
                  Colors.red,
                ),
                _buildSummaryItem(
                  'Remaining',
                  DateFormatter.formatCurrency(remaining),
                  remaining >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final progress = budget.progressPercentage.clamp(0.0, 1.0);
    final isOverBudget = budget.isOverBudget;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.category,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        '${DateFormatter.formatCurrency(budget.spentAmount)} / ${DateFormatter.formatCurrency(budget.budgetAmount)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  isOverBudget ? Colors.red : Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: () => _showDeleteBudgetDialog(budget),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOverBudget
                      ? 'Over budget by ${DateFormatter.formatCurrency(budget.spentAmount - budget.budgetAmount)}'
                      : 'Remaining: ${DateFormatter.formatCurrency(budget.remainingAmount)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverBudget ? Colors.red : Colors.green,
                      ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverBudget ? Colors.red : Colors.grey[600],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteBudgetDialog(Budget budget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Budget'),
          content: Text(
            'Are you sure you want to delete the budget for ${budget.category}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _budgetService.deleteBudget(budget.id);
                Navigator.of(context).pop();
                setState(() {
                  // Refresh the budgets list
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Budget for ${budget.category} deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

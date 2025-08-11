import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../utils/date_formatter.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final TransactionService _transactionService = TransactionService();
  String _selectedChartType = 'expense_pie';

  Future<void> _refreshAnalytics() async {
    // Simulate network delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      // This will trigger a rebuild and refresh the analytics data
    });
  }

  String _selectedPeriod = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'week', child: Text('This Week')),
              const PopupMenuItem(value: 'month', child: Text('This Month')),
              const PopupMenuItem(value: 'year', child: Text('This Year')),
              const PopupMenuItem(value: 'all', child: Text('All Time')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getPeriodDisplayName()),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAnalytics,
        child: ListView(
          children: [
            // Chart Type Selector
            _buildChartTypeSelector(),

            // Main Chart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getChartTitle(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 400,
                        child: _buildSelectedChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Summary Stats
            _buildSummaryStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTypeSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChartTypeChip(
              'expense_pie', 'Expense Breakdown', Icons.pie_chart),
          _buildChartTypeChip(
              'income_vs_expense', 'Income vs Expense', Icons.bar_chart),
          _buildChartTypeChip('monthly_trend', 'Monthly Trend', Icons.timeline),
          _buildChartTypeChip('category_comparison', 'Category Comparison',
              Icons.compare_arrows),
        ],
      ),
    );
  }

  Widget _buildChartTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedChartType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedChartType = type;
          });
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedChart() {
    final transactions = _getFilteredTransactions();

    switch (_selectedChartType) {
      case 'expense_pie':
        return _buildExpensePieChart(transactions);
      case 'income_vs_expense':
        return _buildIncomeVsExpenseChart(transactions);
      case 'monthly_trend':
        return _buildMonthlyTrendChart(transactions);
      case 'category_comparison':
        return _buildCategoryComparisonChart(transactions);
      default:
        return _buildExpensePieChart(transactions);
    }
  }

  Widget _buildExpensePieChart(List<Transaction> transactions) {
    final expensesByCategory = _getExpensesByCategory(transactions);

    if (expensesByCategory.isEmpty) {
      return const Center(child: Text('No expense data available'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Pie Chart
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PieChart(
                PieChartData(
                  sections: expensesByCategory.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    final categoryEntry = entry.value;
                    final index = entry.key;
                    final color = _getCategoryColor(categoryEntry.key, index);
                    final percentage = (categoryEntry.value /
                            _getTotalExpenses(transactions)) *
                        100;
                    return PieChartSectionData(
                      value: categoryEntry.value,
                      title: percentage > 8
                          ? '${percentage.toStringAsFixed(0)}%'
                          : '',
                      color: color,
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Legend below chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: expensesByCategory.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final categoryEntry = entry.value;
                final index = entry.key;
                final color = _getCategoryColor(categoryEntry.key, index);
                final percentage =
                    (categoryEntry.value / _getTotalExpenses(transactions)) *
                        100;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        categoryEntry.key,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIncomeVsExpenseChart(List<Transaction> transactions) {
    final totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: [totalIncome, totalExpense].reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Income', style: TextStyle(fontSize: 12));
                  case 1:
                    return const Text('Expense',
                        style: TextStyle(fontSize: 12));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatAxisValue(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: totalIncome,
                color: Colors.green,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: totalExpense,
                color: Colors.red,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendChart(List<Transaction> transactions) {
    // Similar to daily but grouped by month
    return const Center(child: Text('Monthly trend chart coming soon!'));
  }

  Widget _buildCategoryComparisonChart(List<Transaction> transactions) {
    final expensesByCategory = _getExpensesByCategory(transactions);

    if (expensesByCategory.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: expensesByCategory.values.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final categories = expensesByCategory.keys.toList();
                if (value.toInt() < categories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      categories[value.toInt()]
                          .split(' ')[0], // First word only
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatAxisValue(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            expensesByCategory.entries.toList().asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: _getCategoryColor(entry.value.key),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryStats() {
    final transactions = _getFilteredTransactions();
    final totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final netAmount = totalIncome - totalExpense;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Income',
              DateFormatter.formatCurrency(totalIncome),
              Colors.green,
              Icons.trending_up,
            ),
            _buildStatItem(
              'Expense',
              DateFormatter.formatCurrency(totalExpense),
              Colors.red,
              Icons.trending_down,
            ),
            _buildStatItem(
              'Net',
              DateFormatter.formatCurrency(netAmount),
              netAmount >= 0 ? Colors.green : Colors.red,
              netAmount >= 0 ? Icons.account_balance_wallet : Icons.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String amount, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
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

  // Helper methods
  List<Transaction> _getFilteredTransactions() {
    final allTransactions = _transactionService.getAllTransactions();
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case 'week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return allTransactions.where((t) => t.date.isAfter(weekStart)).toList();
      case 'month':
        final monthStart = DateTime(now.year, now.month, 1);
        return allTransactions
            .where((t) => t.date.isAfter(monthStart))
            .toList();
      case 'year':
        final yearStart = DateTime(now.year, 1, 1);
        return allTransactions.where((t) => t.date.isAfter(yearStart)).toList();
      case 'all':
      default:
        return allTransactions;
    }
  }

  Map<String, double> _getExpensesByCategory(List<Transaction> transactions) {
    final Map<String, double> categoryTotals = {};

    for (final transaction in transactions) {
      if (!transaction.isIncome) {
        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return categoryTotals;
  }

  double _getTotalExpenses(List<Transaction> transactions) {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Color _getCategoryColor(String category, [int? index]) {
    // Beautiful gradient of red shades and complementary colors
    final colors = [
      const Color(0xFFE53E3E), // Vibrant red
      const Color(0xFFFF6B6B), // Coral red
      const Color(0xFFFF8E8E), // Light coral
      const Color(0xFFFF5722), // Deep orange-red
      const Color(0xFFD32F2F), // Dark red
      const Color(0xFFFF7043), // Orange-red
      const Color(0xFFEF5350), // Light red
      const Color(0xFFFF1744), // Accent red
      const Color(0xFFFF6F00), // Amber-red
      const Color(0xFFBF360C), // Deep red-orange
    ];

    // Use index if provided for consistent colors, otherwise use category hash
    final colorIndex = index ?? (category.hashCode % colors.length);
    return colors[colorIndex % colors.length];
  }

  String _getPeriodDisplayName() {
    switch (_selectedPeriod) {
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      case 'all':
        return 'All Time';
      default:
        return 'This Month';
    }
  }

  String _getChartTitle() {
    switch (_selectedChartType) {
      case 'expense_pie':
        return 'Expense Breakdown';
      case 'income_vs_expense':
        return 'Income vs Expense';

      case 'monthly_trend':
        return 'Monthly Trend';
      case 'category_comparison':
        return 'Category Comparison';
      default:
        return 'Analytics';
    }
  }

  String _formatAxisValue(double value) {
    if (value == 0) return '';
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}k';
    }
    return '\$${value.toInt()}';
  }
}

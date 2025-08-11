import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../utils/date_formatter.dart';

class ExpenseChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String chartType; // 'pie', 'bar', 'line'

  const ExpenseChart({
    super.key,
    required this.transactions,
    this.chartType = 'pie',
  });

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case 'bar':
        return _buildBarChart(context);
      case 'line':
        return _buildLineChart(context);
      case 'pie':
      default:
        return _buildPieChart(context);
    }
  }

  Widget _buildPieChart(BuildContext context) {
    final expensesByCategory = _getExpensesByCategory();
    
    if (expensesByCategory.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
    }

    return PieChart(
      PieChartData(
        sections: expensesByCategory.entries.map((entry) {
          final color = _getCategoryColor(entry.key);
          return PieChartSectionData(
            value: entry.value,
            title: '${((entry.value / _getTotalExpenses()) * 100).toStringAsFixed(1)}%',
            color: color,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final expensesByCategory = _getExpensesByCategory();
    
    if (expensesByCategory.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
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
                      categories[value.toInt()],
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
              getTitlesWidget: (value, meta) {
                return Text(
                  DateFormatter.formatCurrency(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: expensesByCategory.entries.toList().asMap().entries.map((entry) {
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

  Widget _buildLineChart(BuildContext context) {
    final dailyExpenses = _getDailyExpenses();
    
    if (dailyExpenses.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = dailyExpenses.keys.toList()..sort();
                if (value.toInt() < days.length) {
                  return Text(
                    '${days[value.toInt()].day}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  DateFormatter.formatCurrency(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: dailyExpenses.entries.toList().asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.value);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _getExpensesByCategory() {
    final Map<String, double> categoryTotals = {};
    
    for (final transaction in transactions) {
      if (!transaction.isIncome) {
        categoryTotals[transaction.category] = 
            (categoryTotals[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryTotals;
  }

  Map<DateTime, double> _getDailyExpenses() {
    final Map<DateTime, double> dailyTotals = {};
    
    for (final transaction in transactions) {
      if (!transaction.isIncome) {
        final date = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        dailyTotals[date] = (dailyTotals[date] ?? 0) + transaction.amount;
      }
    }
    
    return dailyTotals;
  }

  double _getTotalExpenses() {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Color _getCategoryColor(String category) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    
    return colors[category.hashCode % colors.length];
  }
}

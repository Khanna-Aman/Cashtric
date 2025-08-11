import '../models/budget.dart';
import 'transaction_service.dart';

class BudgetService {
  static BudgetService? _instance;
  static BudgetService get instance => _instance ??= BudgetService._();
  BudgetService._();

  final List<Budget> _budgets = [];
  final TransactionService _transactionService = TransactionService();
  bool _initialized = false;

  void init() {
    if (!_initialized) {
      _initializeSampleBudgets();
      _initialized = true;
    }
  }

  void _initializeSampleBudgets() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    _budgets.addAll([
      Budget(
        id: '1',
        category: 'Food',
        budgetAmount: 500.0,
        spentAmount: _calculateSpentAmount('Food'),
        startDate: startOfMonth,
        endDate: endOfMonth,
        period: 'monthly',
      ),
      Budget(
        id: '2',
        category: 'Transportation',
        budgetAmount: 200.0,
        spentAmount: _calculateSpentAmount('Transportation'),
        startDate: startOfMonth,
        endDate: endOfMonth,
        period: 'monthly',
      ),
      Budget(
        id: '3',
        category: 'Entertainment',
        budgetAmount: 150.0,
        spentAmount: _calculateSpentAmount('Entertainment'),
        startDate: startOfMonth,
        endDate: endOfMonth,
        period: 'monthly',
      ),
      Budget(
        id: '4',
        category: 'Shopping',
        budgetAmount: 300.0,
        spentAmount: _calculateSpentAmount('Shopping'),
        startDate: startOfMonth,
        endDate: endOfMonth,
        period: 'monthly',
      ),
    ]);
  }

  double _calculateSpentAmount(String category) {
    final transactions = _transactionService.getAllTransactions();
    return transactions
        .where((t) => !t.isIncome && t.category == category)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Budget> getAllBudgets() {
    // Update spent amounts with current data
    for (int i = 0; i < _budgets.length; i++) {
      _budgets[i] = _budgets[i].copyWith(
        spentAmount: _calculateSpentAmount(_budgets[i].category),
      );
    }
    return List.from(_budgets);
  }

  Budget? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      return null;
    }
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
  }

  void updateBudget(Budget updatedBudget) {
    final index =
        _budgets.indexWhere((budget) => budget.id == updatedBudget.id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
    }
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((budget) => budget.id == id);
  }

  double getTotalBudgetAmount() {
    return _budgets.fold(0.0, (sum, budget) => sum + budget.budgetAmount);
  }

  double getTotalSpentAmount() {
    return _budgets.fold(0.0, (sum, budget) => sum + budget.spentAmount);
  }

  List<Budget> getOverBudgetCategories() {
    return _budgets.where((budget) => budget.isOverBudget).toList();
  }
}

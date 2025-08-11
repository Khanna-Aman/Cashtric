import '../models/transaction.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final List<Transaction> _transactions = [];

  // Get all transactions
  List<Transaction> getAllTransactions() {
    return List.unmodifiable(_transactions);
  }

  // Get transactions sorted by date (newest first)
  List<Transaction> getTransactionsSorted() {
    final sorted = List<Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // Add transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  // Update transaction
  bool updateTransaction(String id, Transaction updatedTransaction) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      return true;
    }
    return false;
  }

  // Delete transaction
  bool deleteTransaction(String id) {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transactions.removeAt(index);
      return true;
    }
    return false;
  }

  // Get transaction by ID
  Transaction? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Calculate total balance
  double getTotalBalance() {
    double balance = 0.0;
    for (var transaction in _transactions) {
      if (transaction.isIncome) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  // Calculate total income
  double getTotalIncome() {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Calculate total expenses
  double getTotalExpenses() {
    return _transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  // Get transactions by date range
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
             t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get recent transactions (limit)
  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sorted = getTransactionsSorted();
    return sorted.take(limit).toList();
  }

  // Initialize with sample data
  void initializeSampleData() {
    if (_transactions.isNotEmpty) return;

    final sampleTransactions = [
      Transaction(
        id: '1',
        title: 'Monthly Salary',
        amount: 5000.0,
        category: 'Salary',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isIncome: true,
      ),
      Transaction(
        id: '2',
        title: 'Grocery Shopping',
        amount: 120.50,
        category: 'Food & Dining',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isIncome: false,
      ),
      Transaction(
        id: '3',
        title: 'Gas Station',
        amount: 45.00,
        category: 'Transportation',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isIncome: false,
      ),
      Transaction(
        id: '4',
        title: 'Freelance Project',
        amount: 800.0,
        category: 'Freelance',
        date: DateTime.now().subtract(const Duration(days: 5)),
        isIncome: true,
      ),
      Transaction(
        id: '5',
        title: 'Coffee Shop',
        amount: 12.50,
        category: 'Food & Dining',
        date: DateTime.now().subtract(const Duration(days: 6)),
        isIncome: false,
      ),
    ];

    for (var transaction in sampleTransactions) {
      addTransaction(transaction);
    }
  }

  // Clear all transactions (for testing)
  void clearAllTransactions() {
    _transactions.clear();
  }
}

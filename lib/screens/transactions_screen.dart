import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';
import '../utils/date_formatter.dart';
import '../widgets/transaction_list_item.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionService _transactionService = TransactionService();
  List<Transaction> _filteredTransactions = [];
  String _searchQuery = '';
  bool? _selectedType; // null = all, true = income, false = expense

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _filteredTransactions = _transactionService.getTransactionsSorted();
      _applyFilters();
    });
  }

  void _applyFilters() {
    var transactions = _transactionService.getTransactionsSorted();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      transactions = transactions.where((t) {
        return t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            t.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply type filter
    if (_selectedType != null) {
      transactions =
          transactions.where((t) => t.isIncome == _selectedType).toList();
    }

    setState(() {
      _filteredTransactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),

          // Filter Chips
          if (_selectedType != null)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedType != null)
                    FilterChip(
                      label: Text(_selectedType! ? 'Income' : 'Expense'),
                      selected: true,
                      onSelected: (bool value) {
                        if (!value) {
                          setState(() {
                            _selectedType = null;
                          });
                          _applyFilters();
                        }
                      },
                      onDeleted: () {
                        setState(() {
                          _selectedType = null;
                        });
                        _applyFilters();
                      },
                    ),
                ],
              ),
            ),

          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      _loadTransactions();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _filteredTransactions[index];
                        return TransactionListItem(
                          transaction: transaction,
                          onTap: () => _showTransactionDetails(transaction),
                          onDelete: () => _deleteTransaction(transaction.id),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "transactions_fab",
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );

          if (result == true) {
            _loadTransactions();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedType != null
                ? 'No transactions match your filters'
                : 'No transactions yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedType != null
                ? 'Try adjusting your search or filters'
                : 'Tap the + button to add your first transaction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Transactions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Type filter
              const Text('Transaction Type:'),
              RadioListTile<bool?>(
                title: const Text('All'),
                value: null,
                groupValue: _selectedType,
                onChanged: (value) {
                  setDialogState(() {
                    _selectedType = value;
                  });
                },
              ),
              RadioListTile<bool?>(
                title: const Text('Income'),
                value: true,
                groupValue: _selectedType,
                onChanged: (value) {
                  setDialogState(() {
                    _selectedType = value;
                  });
                },
              ),
              RadioListTile<bool?>(
                title: const Text('Expense'),
                value: false,
                groupValue: _selectedType,
                onChanged: (value) {
                  setDialogState(() {
                    _selectedType = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  _selectedType = null;
                });
                setState(() {
                  _selectedType = null;
                });
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear All'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the main widget state
                });
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
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
      _loadTransactions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully')),
      );
    }
  }
}

class Budget {
  final String id;
  final String category;
  final double budgetAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String period; // 'monthly', 'weekly', 'yearly'

  Budget({
    required this.id,
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
    required this.period,
  });

  double get remainingAmount => budgetAmount - spentAmount;
  double get progressPercentage => spentAmount / budgetAmount;
  bool get isOverBudget => spentAmount > budgetAmount;

  Budget copyWith({
    String? id,
    String? category,
    double? budgetAmount,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
    );
  }
}

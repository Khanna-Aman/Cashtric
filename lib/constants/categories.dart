class AppCategories {
  // Expense categories with icons
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Other Expenses',
  ];

  // Income categories
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Gift',
    'Bonus',
    'Other Income',
  ];

  // Get all categories
  static List<String> getAllCategories() {
    return [...expenseCategories, ...incomeCategories];
  }

  // Check if category is income type
  static bool isIncomeCategory(String category) {
    return incomeCategories.contains(category);
  }

  // Check if category is expense type
  static bool isExpenseCategory(String category) {
    return expenseCategories.contains(category);
  }
}

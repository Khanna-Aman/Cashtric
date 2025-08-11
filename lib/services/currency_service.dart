enum Currency {
  usd('USD', '\$', 'US Dollar'),
  inr('INR', '₹', 'Indian Rupee'),
  eur('EUR', '€', 'Euro');

  const Currency(this.code, this.symbol, this.name);

  final String code;
  final String symbol;
  final String name;
}

class CurrencyService {
  static CurrencyService? _instance;
  static CurrencyService get instance => _instance ??= CurrencyService._();
  CurrencyService._();

  Currency _currentCurrency = Currency.usd;

  Currency get currentCurrency => _currentCurrency;
  String get currencySymbol => _currentCurrency.symbol;
  String get currencyCode => _currentCurrency.code;
  String get currencyName => _currentCurrency.name;

  void init() {
    // Simple in-memory storage for now
    _currentCurrency = Currency.usd;
  }

  void setCurrency(Currency currency) {
    _currentCurrency = currency;
  }

  String formatAmount(double amount) {
    return '${_currentCurrency.symbol}${amount.toStringAsFixed(2)}';
  }

  String formatAmountWithSign(double amount, bool isPositive) {
    final formatted = formatAmount(amount.abs());
    return isPositive ? '+$formatted' : '-$formatted';
  }

  // Get all available currencies
  List<Currency> get availableCurrencies => Currency.values;
}

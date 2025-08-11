# Cashtric

**Smart Expense Tracking with AI-Powered Receipt Scanning**

Cashtric is a modern, intuitive expense tracking app built with Flutter that revolutionizes how you manage your finances. With AI-powered receipt scanning, intelligent categorization, and comprehensive budget management, Cashtric makes expense tracking effortless and insightful.

![Cashtric Logo](assets/icon/icon.png)

## Features

### AI-Powered Receipt Scanning
- **Smart OCR Technology**: Upload receipt images and automatically extract amount, merchant, date, and category
- **High Accuracy**: Advanced ML Kit text recognition with intelligent fallback systems
- **Instant Processing**: Quick and reliable data extraction from receipt images

### Comprehensive Expense Management
- **Multiple Categories**: Pre-defined categories including Food & Dining, Transportation, Shopping, Entertainment, and more
- **Custom Transactions**: Manual entry with intuitive forms and date pickers
- **Transaction History**: Complete overview of all your expenses with search and filter capabilities

### Smart Budget Management
- **Category Budgets**: Set custom budgets for any expense category
- **Visual Progress**: Clear progress bars showing budget utilization
- **Overspend Alerts**: Red indicators when budgets are exceeded
- **Budget Analytics**: Track spending patterns and budget performance

### Advanced Analytics
- **Spending Insights**: Detailed charts and graphs showing expense patterns
- **Category Breakdown**: Visual representation of spending by category
- **Trend Analysis**: Track spending trends over time
- **Export Capabilities**: Generate reports for financial planning

### Modern User Experience
- **Clean Interface**: Intuitive design with Material Design principles
- **Dark/Light Themes**: Customizable themes for comfortable viewing
- **Responsive Design**: Optimized for all screen sizes
- **Smooth Animations**: Polished user interactions and transitions

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Khanna-Aman/Cashtric.git
   cd Cashtric
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Screenshots

### Dashboard
- Overview of recent transactions
- Quick access to all features
- Budget status at a glance

### Receipt Upload
- Simple image upload interface
- Real-time processing feedback
- Automatic data extraction

### Budget Management
- Visual budget tracking
- Category-wise budget setting
- Overspend notifications

### Analytics
- Comprehensive spending charts
- Category breakdowns
- Trend analysis

## Technical Architecture

### Core Technologies
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **ML Kit**: Google's machine learning for text recognition
- **Local Storage**: Efficient data persistence

### Key Components
- **OCR Service**: Advanced text recognition and parsing
- **Transaction Service**: Complete transaction management
- **Budget Service**: Smart budget tracking and alerts
- **Theme Service**: Customizable UI themes
- **Currency Service**: Multi-currency support

### Design Patterns
- **Singleton Pattern**: Service management
- **Provider Pattern**: State management
- **Repository Pattern**: Data access layer
- **Clean Architecture**: Separation of concerns

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── transaction.dart
│   └── budget.dart
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── upload_receipt_screen.dart
│   ├── add_transaction_screen.dart
│   ├── transactions_screen.dart
│   ├── budgets_screen.dart
│   └── analytics_screen.dart
├── services/                 # Business logic
│   ├── ocr_service.dart
│   ├── transaction_service.dart
│   ├── budget_service.dart
│   ├── theme_service.dart
│   └── currency_service.dart
├── utils/                    # Utilities
│   └── date_formatter.dart
└── constants/               # App constants
    └── categories.dart
```

## Configuration

### App Icon
The app icon is located at `assets/icon/icon.png`. To update:
1. Replace the icon file
2. Run `flutter pub get`
3. Rebuild the app

### Categories
The app includes comprehensive expense categories defined in `lib/constants/categories.dart`:
```dart
class AppCategories {
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Utilities',
    // And more...
  ];
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Aman Khanna**
- GitHub: [@Khanna-Aman](https://github.com/Khanna-Aman)

## Acknowledgments

- Google ML Kit for OCR capabilities
- Flutter team for the amazing framework
- Material Design for UI guidelines

---

**Built with Flutter**

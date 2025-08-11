import 'package:intl/intl.dart';
import '../services/currency_service.dart';

class DateFormatter {
  // Format date as MM/dd/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  // Format date as MMM dd, yyyy (e.g., Jan 15, 2024)
  static String formatDateLong(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as relative time (e.g., "2 days ago")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  // Format currency using current currency service
  static String formatCurrency(double amount) {
    return CurrencyService.instance.formatAmount(amount);
  }

  // Format currency with sign
  static String formatCurrencyWithSign(double amount, bool isIncome) {
    return CurrencyService.instance.formatAmountWithSign(amount, isIncome);
  }
}

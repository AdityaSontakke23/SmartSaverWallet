import 'package:intl/intl.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date with time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  // Get month name
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  // Calculate percentage
  static double calculatePercentage(double amount, double total) {
    if (total == 0) return 0;
    return (amount / total) * 100;
  }

  // Get category color
  static String getCategoryColor(String category) {
    final categoryColors = {
      'Food': '#E57373',
      'Transport': '#64B5F6',
      'Shopping': '#9575CD',
      'Bills': '#FFB74D',
      'Entertainment': '#81C784',
      'Healthcare': '#F06292',
      'Salary': '#4DB6AC',
      'Freelance': '#A1C181',
      'Investment': '#90CAF9',
      'Other': '#BCAAA4',
    };
    
    return categoryColors[category] ?? '#BCAAA4';
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

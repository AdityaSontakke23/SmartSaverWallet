import 'package:intl/intl.dart';

class Helpers {

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(amount);
  }


  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }


  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }


  static String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }


  static double calculatePercentage(double amount, double total) {
    if (total == 0) return 0;
    return (amount / total) * 100;
  }


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


  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }


  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }


  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }


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

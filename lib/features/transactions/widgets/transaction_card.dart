import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/date_formatter.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TransactionCard({Key? key, required this.data}) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'bills':
        return Icons.receipt;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_bag;
      case 'salary':
        return Icons.account_balance;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppColors.categoryFood;
      case 'transport':
        return AppColors.categoryTransport;
      case 'bills':
        return AppColors.categoryBills;
      case 'entertainment':
        return AppColors.categoryEntertainment;
      case 'shopping':
        return AppColors.categoryShopping;
      case 'salary':
        return AppColors.categorySalary;
      default:
        return AppColors.categoryOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String category = data['category'] as String;
    final double amount = (data['amount'] as num).toDouble();
    final bool isExpense = data['type'] == 'expense';
    final Timestamp date = data['date'] as Timestamp;
    final List<String> tags = List<String>.from(data['tags'] ?? []);
    final Color categoryColor = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: categoryColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black26
                : Colors.black.withOpacity(0.08), // ✅ Lighter shadow for light mode
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(category),
            color: categoryColor,
            size: 24,
          ),
        ),
        title: Text(
          data['description'] as String,
          style: AppTextStyles.h4(context), // ✅ Already theme-aware
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category • ${DateFormatter.format(date.toDate())}', // ✅ Changed - to •
              style: AppTextStyles.bodySmall(context), // ✅ Already theme-aware
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkSurfaceColor
                                : AppColors.tealStart.withOpacity(0.1), // ✅ Light mode: teal tint
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.tealStart.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.overline(context).copyWith(
                              color: AppColors.tealStart,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(2)}',
          style: AppTextStyles.amountMedium(context).copyWith(
            color: isExpense ? AppColors.error : AppColors.success,
          ),
        ),
      ),
    );
  }
}

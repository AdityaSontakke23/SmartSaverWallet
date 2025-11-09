import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/text_styles.dart';
import '../models/transaction_model.dart';
import '../../../core/constants/colors.dart'; // ✅ Added this


class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItem({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIncome = transaction.type.toLowerCase() == AppConstants.txIncome;
    
    // ✅ Use theme-aware colors for income/expense
    final color = isIncome 
        ? AppColors.success 
        : (isDarkMode ? const Color(0xFFEF4444) : const Color(0xFFDC2626)); // error color
    
    final sign = isIncome ? '+' : '-';
    
    // ✅ Theme-aware icon color
    final iconColor = isDarkMode
        ? Colors.white.withOpacity(0.7)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 4,
      ),
      title: Text(
        transaction.description,
        style: AppTextStyles.h4(context), // ✅ Already theme-aware
      ),
      subtitle: Text(
        '${transaction.category} • ${transaction.date.toLocal().toString().split(' ')[0]}',
        style: AppTextStyles.caption(context), // ✅ Already theme-aware
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$sign\₹${transaction.amount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: color,
              fontWeight: FontWeight.w600, // ✅ Added: Make amount more prominent
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: iconColor, // ✅ Fixed: Theme-aware
            ),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

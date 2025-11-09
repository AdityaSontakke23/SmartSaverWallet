import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/constants/colors.dart';

class MonthlySummaryCard extends StatelessWidget {
  final double totalBudgeted;
  final double totalSpent;
  final double progress;

  const MonthlySummaryCard({
    Key? key,
    required this.totalBudgeted,
    required this.totalSpent,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color progressColor;
    if (progress > 0.9) {
      progressColor = Colors.red;
    } else if (progress > 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Budgeted',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                Text(
                  '₹${totalBudgeted.toStringAsFixed(0)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Spent',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                Text(
                  '₹${totalSpent.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 45,
            lineWidth: 8,
            percent: progress.clamp(0.0, 1.0),
            center: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: progressColor,
            backgroundColor: isDark ? AppColors.darkSurfaceColor : AppColors.lightSurfaceColor,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
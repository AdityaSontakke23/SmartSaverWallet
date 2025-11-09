import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/budget_model.dart';

class BudgetProgress extends StatelessWidget {
  final BudgetModel budget;
  const BudgetProgress({Key? key, required this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = budget.amount == 0
        ? 0
        : (budget.spent / budget.amount).clamp(0.0, 1.0);

    Color progressColor;
    if (progress < 0.5) {
      progressColor = AppColors.tealStart;
    } else if (progress < 0.8) {
      progressColor = AppColors.warning;
    } else {
      progressColor = AppColors.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.secondaryText(context).withOpacity(0.2),
          color: progressColor,
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text('${(progress * 100).toStringAsFixed(1)}% of budget spent',
            style: AppTextStyles.caption(context)),
      ],
    );
  }
}

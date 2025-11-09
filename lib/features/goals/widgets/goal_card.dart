import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../models/goal_model.dart';
import 'goal_progress_ring.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;
  final VoidCallback? onAddContribution;
  final VoidCallback? onDelete;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onTap,
    this.onAddContribution,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = goal.targetAmount == 0
        ? 0.0
        : (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

    // Calculate days remaining
    final daysRemaining = goal.targetDate != null
        ? goal.targetDate!.difference(DateTime.now()).inDays
        : null;

    // Determine progress color
    Color progressColor;
    if (goal.isCompleted) {
      progressColor = AppColors.success;
    } else if (progress >= 0.8) {
      progressColor = AppColors.greenEnd;
    } else if (progress >= 0.5) {
      progressColor = AppColors.tealStart;
    } else {
      progressColor = AppColors.greenStart;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCardBackground
              : AppColors.lightCardBackground,
          borderRadius: BorderRadius.circular(20),
          border: goal.isCompleted
              ? Border.all(color: AppColors.success, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with icon and delete
            Row(
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor.withOpacity(0.2),
                        progressColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getGoalIcon(goal.category),
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: AppTextStyles.h4(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (goal.category != null && goal.category!.isNotEmpty)
                        Text(
                          goal.category!,
                          style: AppTextStyles.bodySmall(context),
                        ),
                    ],
                  ),
                ),
                if (onDelete != null && !goal.isCompleted)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                    color: AppColors.error,
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress ring
            GoalProgressRing(
              progress: progress,
              size: 100,
              strokeWidth: 10,
              color: progressColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.h3(context).copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (goal.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Amount info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '₹${goal.currentAmount.toStringAsFixed(0)}',
                      style: AppTextStyles.h4(context).copyWith(
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '₹${goal.targetAmount.toStringAsFixed(0)}',
                      style: AppTextStyles.h4(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Remaining amount
            if (!goal.isCompleted) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceColor
                      : AppColors.lightSurfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${(goal.targetAmount - goal.currentAmount).toStringAsFixed(0)} remaining',
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Date info
            if (daysRemaining != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: daysRemaining < 30
                      ? AppColors.error.withOpacity(0.1)
                      : progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: daysRemaining < 30
                        ? AppColors.error.withOpacity(0.3)
                        : progressColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: daysRemaining < 30 ? AppColors.error : progressColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      daysRemaining > 0
                          ? '$daysRemaining days left'
                          : 'Deadline passed',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: daysRemaining < 30 ? AppColors.error : progressColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // ✅ ACTION BUTTONS SECTION
            if (!goal.isCompleted) ...[
              const SizedBox(height: 12),

              // If goal is 100% or more, show "Mark Complete" button prominently
              if (progress >= 1.0) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.celebration, size: 20),
                    label: const Text('Mark as Complete'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Add contribution button
              if (onAddContribution != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onAddContribution,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(progress >= 1.0 ? 'Add More' : 'Add Contribution'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: progressColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: progressColor,
                    ),
                  ),
                ),
            ],

            // If completed, show completion badge
            if (goal.isCompleted) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Goal Completed! 🎉',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getGoalIcon(String? category) {
    if (category == null || category.isEmpty) return '🎯';

    switch (category.toLowerCase()) {
      case 'house':
      case 'home':
        return '🏠';
      case 'car':
      case 'vehicle':
        return '🚗';
      case 'education':
      case 'study':
        return '🎓';
      case 'travel':
        return '✈️';
      case 'wedding':
      case 'marriage':
        return '💍';
      case 'laptop':
      case 'computer':
        return '💻';
      case 'gaming':
      case 'console':
        return '🎮';
      case 'phone':
      case 'mobile':
        return '📱';
      case 'vacation':
      case 'holiday':
        return '🏖️';
      case 'emergency':
      case 'fund':
        return '💰';
      case 'books':
        return '📚';
      case 'music':
      case 'instrument':
        return '🎸';
      case 'health':
      case 'medical':
        return '🏥';
      case 'party':
      case 'celebration':
        return '🎂';
      case 'food':
        return '🍕';
      default:
        return '🎯';
    }
  }
}

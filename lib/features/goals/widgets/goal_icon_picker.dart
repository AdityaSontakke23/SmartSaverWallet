import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class GoalIconPicker extends StatelessWidget {
  final String? selectedCategory;
  final Function(String, String) onCategorySelected;

  const GoalIconPicker({
    Key? key,
    this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  static const List<Map<String, String>> _goalCategories = [
    {'name': 'House', 'icon': '🏠'},
    {'name': 'Car', 'icon': '🚗'},
    {'name': 'Education', 'icon': '🎓'},
    {'name': 'Travel', 'icon': '✈️'},
    {'name': 'Wedding', 'icon': '💍'},
    {'name': 'Laptop', 'icon': '💻'},
    {'name': 'Gaming', 'icon': '🎮'},
    {'name': 'Phone', 'icon': '📱'},
    {'name': 'Vacation', 'icon': '🏖️'},
    {'name': 'Emergency', 'icon': '💰'},
    {'name': 'Books', 'icon': '📚'},
    {'name': 'Music', 'icon': '🎸'},
    {'name': 'Health', 'icon': '🏥'},
    {'name': 'Party', 'icon': '🎂'},
    {'name': 'Food', 'icon': '🍕'},
    {'name': 'Other', 'icon': '🎯'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _goalCategories.length,
      itemBuilder: (context, index) {
        final category = _goalCategories[index];
        final isSelected = selectedCategory == category['name'];

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onCategorySelected(category['name']!, category['icon']!);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.greenStart.withOpacity(0.15)
                  : isDark
                      ? AppColors.darkCardBackground
                      : AppColors.lightCardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.greenStart
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category['icon']!,
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name']!,
                  style: AppTextStyles.bodySmall(context).copyWith(
                    color: isSelected
                        ? AppColors.greenStart
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

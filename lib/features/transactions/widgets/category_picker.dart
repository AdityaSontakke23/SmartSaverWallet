import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/models/category.dart';

class CategoryPicker extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category) onCategorySelected;
  final String type;

  const CategoryPicker({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final isExpense = type == 'expense';
          final gradientColors = isExpense
              ? [AppColors.orangeStart, AppColors.orangeEnd]
              : [AppColors.greenStart, AppColors.greenEnd];

          // ✅ Theme-aware colors for unselected state
          final unselectedIconColor = isDarkMode
              ? Colors.white.withOpacity(0.7)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
          
          final unselectedTextColor = isDarkMode
              ? Colors.white.withOpacity(0.8)
              : Theme.of(context).colorScheme.onSurface;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.cardBackground(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
                // ✅ Add shadow for light mode
                boxShadow: !isDarkMode && !isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    size: 32,
                    color: isSelected
                        ? Colors.white // Selected: always white on gradient
                        : unselectedIconColor, // ✅ Fixed: Theme-aware
                  )
                      .animate(target: isSelected ? 1 : 0)
                      .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.2, 1.2))
                      .shake(),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: isSelected
                          ? Colors.white // Selected: always white on gradient
                          : unselectedTextColor, // ✅ Fixed: Theme-aware
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

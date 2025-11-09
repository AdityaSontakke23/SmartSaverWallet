import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class TransactionTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const TransactionTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        // ✅ Add border for light mode
        border: Theme.of(context).brightness == Brightness.light
            ? Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TypeButton(
              text: 'Income',
              isSelected: selectedType == 'income',
              onTap: () => onTypeSelected('income'),
              gradientColors: const [AppColors.greenStart, AppColors.greenEnd],
            ),
          ),
          Expanded(
            child: _TypeButton(
              text: 'Expense',
              isSelected: selectedType == 'expense',
              onTap: () => onTypeSelected('expense'),
              gradientColors: const [AppColors.orangeStart, AppColors.orangeEnd],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const _TypeButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Theme-aware unselected text color
    final unselectedTextColor = isDarkMode
        ? Colors.white.withOpacity(0.5)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.button(context).copyWith(
              color: isSelected
                  ? Colors.white // Selected: white on gradient
                  : unselectedTextColor, // ✅ Fixed: Theme-aware
            ),
          ),
        ),
      ),
    );
  }
}

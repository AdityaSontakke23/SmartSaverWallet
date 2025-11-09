import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class DateFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const DateFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return FilterChip(
      selected: isSelected,
      onSelected: onSelected,
      label: Text(label),
      labelStyle: AppTextStyles.bodySmall(context).copyWith(
        color: isSelected
            ? Colors.white
            : isDarkMode
                ? Colors.white70
                : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: isDarkMode
          ? AppColors.darkSurfaceColor
          : const Color(0xFFF9FAFB),
      selectedColor: AppColors.tealStart,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: !isSelected && !isDarkMode
            ? BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              )
            : BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

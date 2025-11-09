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
            ? Colors.white // Selected: white on teal
            : isDarkMode
                ? Colors.white70 // ✅ Dark mode: light gray
                : Theme.of(context).colorScheme.onSurface, // ✅ Light mode: dark text
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: isDarkMode
          ? AppColors.darkSurfaceColor // ✅ Dark mode: dark surface
          : const Color(0xFFF9FAFB), // ✅ Light mode: very light gray
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

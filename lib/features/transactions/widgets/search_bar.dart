import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const TransactionSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Theme-aware text color
    final textColor = isDarkMode
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    
    final hintColor = isDarkMode
        ? Colors.white54
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.5);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkSurfaceColor
            : const Color(0xFFF9FAFB), // ✅ Light mode: very light gray
        borderRadius: BorderRadius.circular(12),
        // ✅ Add border for light mode
        border: !isDarkMode
            ? Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium(context).copyWith(
          color: textColor, // ✅ Fixed: Theme-aware
        ),
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          hintStyle: AppTextStyles.bodyMedium(context).copyWith(
            color: hintColor, // ✅ Fixed: Theme-aware
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.tealStart,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

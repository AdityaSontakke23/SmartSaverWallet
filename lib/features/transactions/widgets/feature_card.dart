import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Get the main gradient color
    final gradientColor = gradient.colors.first;
    
    // ✅ Theme-aware text colors
    final titleColor = isDarkMode
        ? Colors.white
        : gradientColor.computeLuminance() > 0.5
            ? Colors.black87 // If light background, use dark text
            : Colors.white; // If dark background, use white text
    
    final subtitleColor = isDarkMode
        ? Colors.white70
        : gradientColor.computeLuminance() > 0.5
            ? Colors.black54
            : Colors.white70;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient.scale(isDarkMode ? 0.15 : 0.2), // ✅ Adjust opacity for light mode
        borderRadius: BorderRadius.circular(16),
        // ✅ Add border for light mode visibility
        border: !isDarkMode
            ? Border.all(
                color: gradientColor.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: gradientColor, // Keep gradient color for icon
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.w600,
              color: titleColor, // ✅ Fixed: Theme-aware
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.overline(context).copyWith(
              color: subtitleColor, // ✅ Fixed: Theme-aware
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

extension GradientScale on Gradient {
  Gradient scale(double opacity) {
    if (this is LinearGradient) {
      final LinearGradient gradient = this as LinearGradient;
      return LinearGradient(
        colors: gradient.colors
            .map((color) => color.withOpacity(opacity))
            .toList(),
        begin: gradient.begin,
        end: gradient.end,
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
      );
    }
    return this;
  }
}

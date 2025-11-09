import 'package:flutter/material.dart';

class AppColors {
  // ==================== DARK MODE COLORS ====================
  
  // Background Colors - Dark
  static const Color darkPrimaryBackground = Color(0xFF0F1419); // Deep navy-black
  static const Color darkCardBackground = Color(0xFF1A1F29); // Elevated dark
  static const Color darkSurfaceColor = Color(0xFF252A34); // Surface elements

  // Text Colors - Dark
  static const Color darkPrimaryText = Color(0xFFFFFFFF); // White
  static const Color darkSecondaryText = Color(0xFFB0B8C1); // Light gray
  static const Color darkAccentText = Color(0xFF00D4FF); // Cyan

  // ==================== LIGHT MODE COLORS ====================
  
  // Background Colors - Light
  static const Color lightPrimaryBackground = Color(0xFFF5F7FA); // Light gray-blue
  static const Color lightCardBackground = Color(0xFFFFFFFF); // Pure white
  static const Color lightSurfaceColor = Color(0xFFF9FAFB); // Very light gray

  // Text Colors - Light
  static const Color lightPrimaryText = Color(0xFF1A1A1A); // Almost black
  static const Color lightSecondaryText = Color(0xFF6B7280); // Medium gray
  static const Color lightAccentText = Color(0xFF0099CC); // Teal-blue

  // ==================== THEME-AWARE GETTERS ====================
  
  // These will be accessed via context
  static Color primaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryBackground
        : lightPrimaryBackground;
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCardBackground
        : lightCardBackground;
  }

  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceColor
        : lightSurfaceColor;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryText
        : lightPrimaryText;
  }

  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryText
        : lightSecondaryText;
  }

  static Color accentText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAccentText
        : lightAccentText;
  }

  // ==================== STATIC COLORS (Same in both themes) ====================
  
  // Gradient Colors - Start Points (work in both themes)
  static const Color tealStart = Color(0xFF00D4FF);
  static const Color tealEnd = Color(0xFF0099FF);
  static const Color purpleStart = Color(0xFF8B5CF6);
  static const Color purpleEnd = Color(0xFFEC4899);
  static const Color orangeStart = Color(0xFFFF6B35);
  static const Color orangeEnd = Color(0xFFFFA500);
  static const Color greenStart = Color(0xFF10B981);
  static const Color greenEnd = Color(0xFF34D399);
  static const Color blueStart = Color(0xFF4A90E2);
  static const Color blueEnd = Color(0xFF357ABD);

  // Category Colors (same in both themes)
  static const Color categoryFood = Color(0xFFFF6B35);
  static const Color categoryTransport = Color(0xFF00D4FF);
  static const Color categoryBills = Color(0xFFEF4444);
  static const Color categoryEntertainment = Color(0xFFEC4899);
  static const Color categoryShopping = Color(0xFF8B5CF6);
  static const Color categorySalary = Color(0xFF10B981);
  static const Color categoryOther = Color(0xFF6B7280);

  // Status Colors
  static const Color success = greenStart;
  static const Color warning = orangeStart;
  static const Color error = Color(0xFFEF4444);
  static const Color info = tealStart;

  // ==================== GRADIENT DEFINITIONS ====================
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [tealStart, tealEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleStart, purpleEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeStart, orangeEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [greenStart, greenEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== SHADOW DEFINITIONS ====================
  
  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get primaryShadow => [
        BoxShadow(
          color: tealStart.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}

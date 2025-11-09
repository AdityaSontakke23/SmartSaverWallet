import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Helper method to get theme-aware colors
  static Color _primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1A1A1A);
  }

  static Color _secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFB0B8C1)
        : const Color(0xFF6B7280);
  }

  // ==================== TEXT STYLES ====================
  
  static TextStyle largeTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _primaryText(context),
      );

  static TextStyle sectionHeader(BuildContext context) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _primaryText(context),
      );

  static TextStyle cardTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _primaryText(context),
      );

  static TextStyle bodyText(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _primaryText(context),
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _secondaryText(context),
      );

  static TextStyle tinyText(BuildContext context) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: _secondaryText(context),
      );

  static TextStyle buttonText(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white, // Buttons always use white text on colored background
      );

  // ==================== HELPER STYLES ====================
  
  static TextStyle balanceAmount(BuildContext context) => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: _primaryText(context),
      );

  static TextStyle statAmount(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _primaryText(context),
      );

  static TextStyle inputLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _secondaryText(context),
      );
}

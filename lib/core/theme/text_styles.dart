import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {

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

  static Color _accentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF00D4FF)
        : const Color(0xFF0099CC);
  }


  static TextStyle h1(BuildContext context) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: _primaryText(context),
        letterSpacing: -0.5,
      );

  static TextStyle h2(BuildContext context) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: _primaryText(context),
        letterSpacing: -0.5,
      );

  static TextStyle h3(BuildContext context) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _primaryText(context),
      );

  static TextStyle h4(BuildContext context) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: _primaryText(context),
      );
  static TextStyle sectionHeader(BuildContext context) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _primaryText(context),
      );


  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _primaryText(context),
        height: 1.5,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _secondaryText(context),
        height: 1.4,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _secondaryText(context),
        height: 1.3,
      );

  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Colors.white,
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _secondaryText(context),
      );

  static TextStyle overline(BuildContext context) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: _secondaryText(context),
      );

  static TextStyle amountLarge(BuildContext context) => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: _accentColor(context),
      );

  static TextStyle amountMedium(BuildContext context) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _accentColor(context),
      );

  static TextStyle amountSmall(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _primaryText(context),
      );


  static TextStyle amountIncome(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF10B981),
      );


  static TextStyle amountExpense(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFEF4444)
            : const Color(0xFFDC2626),
      );

  static TextStyle link(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _accentColor(context),
        decoration: TextDecoration.underline,
      );

  static TextStyle error(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFEF4444)
            : const Color(0xFFDC2626),
      );


  static TextStyle success(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF10B981),
      );
}

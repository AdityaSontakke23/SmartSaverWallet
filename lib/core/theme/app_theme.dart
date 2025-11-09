import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkPrimaryBackground,
    

    colorScheme: ColorScheme.dark(
      primary: AppColors.tealStart,
      secondary: AppColors.purpleStart,
      error: AppColors.error,
      surface: AppColors.darkCardBackground,
      background: AppColors.darkPrimaryBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkPrimaryText,
      onBackground: AppColors.darkPrimaryText,
      onError: Colors.white,
    ),
    

    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB0B8C1),
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),


    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),


    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.tealStart,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),


    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceColor,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.tealStart.withOpacity(0.5),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.error.withOpacity(0.5),
          width: 1,
        ),
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.darkSecondaryText,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.darkSecondaryText.withOpacity(0.5),
      ),
    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardBackground,
      selectedItemColor: AppColors.tealStart,
      unselectedItemColor: AppColors.darkSecondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),


    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.darkSecondaryText,
      ),
    ),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightPrimaryBackground,
    

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0099CC),
      secondary: Color(0xFF7C3AED),
      error: Color(0xFFDC2626),
      surface: Colors.white,
      background: Color(0xFFF5F7FA),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onBackground: Color(0xFF1A1A1A),
      onError: Colors.white,
    ),
    

    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4A4A4A),
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),


    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF1A1A1A),
      ),
      surfaceTintColor: Colors.transparent,
    ),


    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.05),
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF0099CC),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        shadowColor: const Color(0xFF0099CC).withOpacity(0.3),
      ),
    ),


    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF0099CC),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFDC2626),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFDC2626),
          width: 2,
        ),
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF6B7280),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      ),
    ),


    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0099CC),
      unselectedItemColor: Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
    ),


    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF4A4A4A),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
    ),


    iconTheme: const IconThemeData(
      color: Color(0xFF1A1A1A),
    ),


    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
    ),
  );
}

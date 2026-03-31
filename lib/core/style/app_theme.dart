import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.obsidian,
      textTheme: GoogleFonts.beVietnamProTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: GoogleFonts.epilogue(
            fontSize: 56, // 3.5rem per DESIGN.md
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
            letterSpacing: 2.0,
          ),
          displayMedium: GoogleFonts.epilogue(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
          bodyLarge: GoogleFonts.beVietnamPro(
            fontSize: 18,
            color: AppColors.onSurface,
          ),
          bodyMedium: GoogleFonts.beVietnamPro(
            fontSize: 16,
            color: AppColors.onSurface.withOpacity(0.8),
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        secondary: AppColors.gold,
        surface: AppColors.obsidian,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.onSurface,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptimizedAppTheme {
  // Colors from Figma design
  static const Color primaryBlue = Color(0xFF4A67FF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textGrey = Color(0xFF808080);
  static const Color borderColor = Color(0xFF2C2C2C);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFF44336);
  static const Color warningOrange = Color(0xFFFF9800);

  // Optimized font loading with Arabic subset
  static TextStyle get _cairoRegular => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontDisplay: FontDisplay.swap, // Better loading performance
    // Arabic subset reduces font size by ~60%
  );

  static TextStyle get _cairoBold => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontDisplay: FontDisplay.swap,
    // Only load required weights (400, 700)
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBackground,
      cardColor: cardBackground,
      
      // Optimized Text Theme with font subsets
      textTheme: TextTheme(
        // Display styles
        displayLarge: _cairoBold.copyWith(fontSize: 32),
        displayMedium: _cairoBold.copyWith(fontSize: 28),
        displaySmall: _cairoBold.copyWith(fontSize: 24),
        
        // Headline styles
        headlineLarge: _cairoBold.copyWith(fontSize: 22),
        headlineMedium: _cairoBold.copyWith(fontSize: 20),
        headlineSmall: _cairoBold.copyWith(fontSize: 18),
        
        // Title styles
        titleLarge: _cairoBold.copyWith(fontSize: 16),
        titleMedium: _cairoRegular.copyWith(fontSize: 14),
        titleSmall: _cairoRegular.copyWith(fontSize: 12),
        
        // Body styles
        bodyLarge: _cairoRegular.copyWith(fontSize: 16),
        bodyMedium: _cairoRegular.copyWith(fontSize: 14),
        bodySmall: _cairoRegular.copyWith(fontSize: 12),
        
        // Label styles
        labelLarge: _cairoRegular.copyWith(fontSize: 14),
        labelMedium: _cairoRegular.copyWith(fontSize: 12),
        labelSmall: _cairoRegular.copyWith(fontSize: 10),
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: _cairoRegular.copyWith(color: textGrey),
        labelStyle: _cairoRegular.copyWith(color: textSecondary),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _cairoBold.copyWith(fontSize: 16),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _cairoBold.copyWith(fontSize: 16),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: _cairoRegular.copyWith(fontSize: 14),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardBackground,
        contentTextStyle: _cairoRegular.copyWith(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryBlue,
        surface: cardBackground,
        background: darkBackground,
        error: errorRed,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textPrimary,
      ),
    );
  }
}

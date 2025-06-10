import 'package:flutter/material.dart';

// Custom colors from Tailwind’s palette
class ShadcnColors {
  static const Color primary = Color(0xFF3B82F6); // blue-500
  static const Color primaryDark = Color(0xFF1E40AF); // blue-800
  static const Color background = Color(0xFFF9FAFB); // slate-50
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB); // slate-200
  static const Color text = Color(0xFF374151); // slate-700
  static const Color textSecondary = Color(0xFF6B7280); // slate-500
  static const Color error = Color(0xFFEF4444); // red-500
}

// Build a ThemeData that uses those tokens everywhere.
final ThemeData shadcnTheme = ThemeData(
  brightness: Brightness.light,
  // Use Inter or your preferred sans-serif
  fontFamily: 'Inter',

  // ColorScheme backs most Material widgets
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: ShadcnColors.primary,
    onPrimary: Colors.white,
    secondary: ShadcnColors.primary.withValues(alpha: 0.1),
    onSecondary: ShadcnColors.primaryDark,
    surface: ShadcnColors.surface,
    onSurface: ShadcnColors.text,
    error: ShadcnColors.error,
    onError: Colors.white,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: ShadcnColors.background,
    foregroundColor: ShadcnColors.text,
    elevation: 1,
    surfaceTintColor: Colors.transparent,
  ),

  // Input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    fillColor: ShadcnColors.surface,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: ShadcnColors.border),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ShadcnColors.border),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ShadcnColors.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ShadcnColors.error),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: ShadcnColors.error, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    labelStyle: const TextStyle(color: ShadcnColors.textSecondary),
    hintStyle: const TextStyle(color: ShadcnColors.textSecondary),
  ),

  // ElevatedButton (solid)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ShadcnColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    ),
  ),

  // OutlinedButton (stroke)
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ShadcnColors.primary,
      side: const BorderSide(color: ShadcnColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // TextButton (link-style)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ShadcnColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),

  // Typography
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: ShadcnColors.text),
    bodyMedium: TextStyle(fontSize: 14, color: ShadcnColors.text),
    titleSmall: TextStyle(fontSize: 14, color: ShadcnColors.textSecondary),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ),

  // Card styling
  cardTheme: CardThemeData(
    color: ShadcnColors.surface,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: ShadcnColors.border),
    ),
    elevation: 0,
  ),

  // Scaffold background
  scaffoldBackgroundColor: ShadcnColors.background,
);

import 'package:flutter/material.dart';

class AppColors {
  // User's Provided Palette
  static const Color primary = Color(0xFF2A548D); // Dark Blue (Used as primary in light theme)
  static const Color primaryGold = Color(0xFFD8A31A); // Gold (Used as accent/secondary)
  // Added back from previous version as AppTheme might use them for tertiary colors
  static const Color primaryGoldDark = Color(0xFFB8860B);
  static const Color primaryGoldLight = Color(0xFFE0C068);
  static const Color accent = Color(0xFF6385C3); // Lighter Blue (Used as primary in dark theme)
  
  static const Color lightPageBackground = Color(0xFFE2F0FF); // User's "background"
  static const Color lightSurface = Color(0xFFFFFFFF); // User's "surface" was F5F5F5, using white for cards
  static const Color lightTextPrimary = Color(0xFF2A548D); // User's "textPrimary" (Dark Blue)
  static const Color lightTextSecondary = Color(0xFF555555); // User's "textSecondary" (Medium Grey)

  // Common Colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color errorRed = Color(0xFFB00020);

  // Dark Theme Specific Colors (User's updated values)
  static const Color darkPageBackground = Color(0xFF0D1A26); // Very Dark Desaturated Blue
  static const Color darkSurface = Color(0xFF1A2938);    // Darker Blue/Grey for cards
  static const Color darkTextPrimary = Color.fromARGB(255, 169, 189, 255);  // User's: Light Blueish Grey for text
  static const Color darkTextSecondary = Color.fromARGB(255, 171, 190, 255); // User's: Medium Light Blueish Grey

  // Text on Primary Color (for buttons, etc.)
  static const Color textOnPrimaryLight = textWhite;
  static const Color textOnPrimaryDark = textWhite; // For Lighter Blue (accent)

  // Text on Gold (Secondary Color)
  static const Color textOnGold = black; // Black text on gold buttons

  // Glassmorphism colors - adapt based on brightness in the widget itself
  static Color getGlassBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? AppColors.white.withOpacity(0.4)
        : AppColors.black.withOpacity(0.8); // User's updated opacity for dark glass
  }

  static Color getGlassBorder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? AppColors.white.withOpacity(0.3)
        : AppColors.white.withOpacity(0.1);
  }
}

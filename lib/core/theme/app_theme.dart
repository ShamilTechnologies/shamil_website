import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';

class AppTheme {
  // Base text theme using Google Fonts (Cairo in this case).
  // This provides the foundational styles that will be customized for light/dark themes.
  static final TextTheme _baseTextTheme = GoogleFonts.getTextTheme(
    'Cairo', // Your chosen font
  );

  // Getter for the light theme configuration.
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light, // Sets the overall brightness of the theme.
      primaryColor: AppColors.primary, // Primary brand color (Dark Blue).
      scaffoldBackgroundColor: AppColors.lightPageBackground, // Background color for Scaffolds.

      // ColorScheme defines a set of 13 colors that can be used to configure
      // the color properties of most components.
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary, // Dark Blue
        secondary: AppColors.primaryGold, // Gold
        surface: AppColors.lightSurface, // For surfaces of components like Card, BottomSheet. (White)
        background: AppColors.lightPageBackground, // Overall background. (Light Blueish)
        error: AppColors.errorRed, // Color for error indication.
        onPrimary: AppColors.textOnPrimaryLight, // Text/icon color on primary color (White on Dark Blue).
        onSecondary: AppColors.textOnGold, // Text/icon color on secondary color (Black on Gold).
        onSurface: AppColors.lightTextPrimary, // Text/icon color on surface color (Dark Blue on White).
        onBackground: AppColors.lightTextPrimary, // Text/icon color on background color.
        onError: AppColors.textWhite, // Text/icon color on error color.
        
        // --- ADDED Tertiary Colors for Light Theme ---
        tertiary: AppColors.accent, // Lighter Blue (from your AppColors)
        onTertiary: AppColors.textWhite, // Text on Lighter Blue
        // You can also define container colors if needed for more variety
        // primaryContainer: AppColors.primary.withOpacity(0.1),
        // onPrimaryContainer: AppColors.primary,
      ),

      // TextTheme defines the typography styles for the theme.
      // We take the _baseTextTheme and override specific styles with theme-appropriate colors.
      textTheme: _baseTextTheme.copyWith(
        displayLarge: _baseTextTheme.displayLarge?.copyWith(color: AppColors.lightTextPrimary),
        displayMedium: _baseTextTheme.displayMedium?.copyWith(color: AppColors.lightTextPrimary),
        displaySmall: _baseTextTheme.displaySmall?.copyWith(color: AppColors.lightTextPrimary),
        headlineLarge: _baseTextTheme.headlineLarge?.copyWith(color: AppColors.lightTextPrimary), // Added for completeness
        headlineMedium: _baseTextTheme.headlineMedium?.copyWith(color: AppColors.lightTextPrimary),
        headlineSmall: _baseTextTheme.headlineSmall?.copyWith(color: AppColors.lightTextPrimary),
        titleLarge: _baseTextTheme.titleLarge?.copyWith(color: AppColors.lightTextPrimary),
        titleMedium: _baseTextTheme.titleMedium?.copyWith(color: AppColors.lightTextPrimary), // Added for completeness
        titleSmall: _baseTextTheme.titleSmall?.copyWith(color: AppColors.lightTextPrimary),   // Added for completeness
        bodyLarge: _baseTextTheme.bodyLarge?.copyWith(color: AppColors.lightTextSecondary),     // Added for completeness
        bodyMedium: _baseTextTheme.bodyMedium?.copyWith(color: AppColors.lightTextSecondary),
        bodySmall: _baseTextTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),     // Added for completeness
        labelLarge: _baseTextTheme.labelLarge?.copyWith(color: AppColors.textOnPrimaryLight), // Button text
      ),

      // AppBarTheme customizes the appearance of AppBars.
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary, // Dark Blue AppBar background.
        elevation: 0, // No shadow.
        iconTheme: const IconThemeData(color: AppColors.textWhite), // Icons on AppBar (White).
        titleTextStyle: _baseTextTheme.titleLarge?.copyWith(color: AppColors.textWhite), // Title text style.
      ),

      // ElevatedButtonThemeData customizes the default appearance of ElevatedButtons.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Dark Blue button background.
          foregroundColor: AppColors.textOnPrimaryLight, // White text/icon on button.
          minimumSize: const Size(AppDimensions.buttonMinWidth, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          ),
          textStyle: _baseTextTheme.labelLarge, // Uses labelLarge for button text.
        ),
      ),

      // CardTheme customizes the appearance of Cards.
      cardTheme: CardTheme(
        color: AppColors.lightSurface, // White card background.
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      // Add other specific widget themes if needed (e.g., TextButtonTheme, OutlinedButtonTheme)
    );
  }

  // Getter for the dark theme configuration.
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark, // Sets the overall brightness to dark.
      primaryColor: AppColors.accent, // Lighter Blue as primary for dark theme.
      scaffoldBackgroundColor: AppColors.darkPageBackground, // Dark background for Scaffolds.

      // ColorScheme for dark theme.
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent, // Lighter Blue
        secondary: AppColors.primaryGold, // Gold
        surface: AppColors.darkSurface, // For surfaces of components (Darker Blue/Grey).
        background: AppColors.darkPageBackground, // Overall background (Very Dark Desaturated Blue).
        error: AppColors.errorRed,
        onPrimary: AppColors.textOnPrimaryDark, // Text/icon on primary (White on Lighter Blue).
        onSecondary: AppColors.textOnGold, // Text/icon on secondary (Black on Gold).
        onSurface: AppColors.darkTextPrimary, // Text/icon on surface (Light Blueish Grey).
        onBackground: AppColors.darkTextPrimary, // Text/icon on background.
        onError: AppColors.textWhite, // Text/icon on error color.

        // --- ADDED Tertiary Colors for Dark Theme ---
        tertiary: AppColors.primaryGoldDark, // Darker Gold as tertiary for dark theme
        onTertiary: AppColors.textWhite,    // Text on Darker Gold
        // primaryContainer: AppColors.accent.withOpacity(0.1),
        // onPrimaryContainer: AppColors.accent,
      ),

      // TextTheme for dark theme.
      textTheme: _baseTextTheme.copyWith(
        displayLarge: _baseTextTheme.displayLarge?.copyWith(color: AppColors.darkTextPrimary),
        displayMedium: _baseTextTheme.displayMedium?.copyWith(color: AppColors.darkTextPrimary),
        displaySmall: _baseTextTheme.displaySmall?.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge: _baseTextTheme.headlineLarge?.copyWith(color: AppColors.darkTextPrimary), // Added
        headlineMedium: _baseTextTheme.headlineMedium?.copyWith(color: AppColors.darkTextPrimary),
        headlineSmall: _baseTextTheme.headlineSmall?.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: _baseTextTheme.titleLarge?.copyWith(color: AppColors.darkTextPrimary),
        titleMedium: _baseTextTheme.titleMedium?.copyWith(color: AppColors.darkTextPrimary), // Added
        titleSmall: _baseTextTheme.titleSmall?.copyWith(color: AppColors.darkTextPrimary),   // Added
        bodyLarge: _baseTextTheme.bodyLarge?.copyWith(color: AppColors.darkTextSecondary),     // Added
        bodyMedium: _baseTextTheme.bodyMedium?.copyWith(color: AppColors.darkTextSecondary),
        bodySmall: _baseTextTheme.bodySmall?.copyWith(color: AppColors.darkTextSecondary),     // Added
        labelLarge: _baseTextTheme.labelLarge?.copyWith(color: AppColors.textOnPrimaryDark), // Button text
      ),

      // AppBarTheme for dark theme.
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface, // Dark Surface for AppBar background.
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGold), // Gold icons on dark AppBar.
        titleTextStyle: _baseTextTheme.titleLarge?.copyWith(color: AppColors.darkTextPrimary),
      ),

      // ElevatedButtonThemeData for dark theme.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent, // Lighter Blue button background.
          foregroundColor: AppColors.textOnPrimaryDark, // White text/icon on button.
          minimumSize: const Size(AppDimensions.buttonMinWidth, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          ),
          textStyle: _baseTextTheme.labelLarge,
        ),
      ),

      // CardTheme for dark theme.
      cardTheme: CardTheme(
        color: AppColors.darkSurface, // Dark Surface for card background.
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      // Add other specific widget themes if needed
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light); // Default to light for this example

  void setThemeMode(ThemeMode themeMode) {
    if (state != themeMode) {
      state = themeMode;
    }
  }

  void toggleTheme() {
    // Simple toggle between light and dark
    state = (state == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamil_web/core/theme/theme_provider.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    // Determine if the effective theme is dark
    final bool isEffectivelyDark = currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return IconButton(
      icon: Icon(
        isEffectivelyDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: Theme.of(context).appBarTheme.iconTheme?.color, // Use color from AppBarTheme
      ),
      tooltip: isEffectivelyDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}
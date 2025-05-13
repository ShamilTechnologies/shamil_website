import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamil_web/core/localization/locale_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_strings.dart'; // For keys

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = context.locale; // Get current locale from EasyLocalization

    // Simple Text Button Implementation (Alternative to Dropdown)
    return TextButton.icon(
      icon: const Icon(Icons.language, color: AppColors.white, size: 20),
      label: Text(
        currentLocale.languageCode == 'en' ? AppStrings.arabic.tr() : AppStrings.english.tr(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.white),
      ),
      onPressed: () {
         final newLocale = currentLocale.languageCode == 'en'
             ? const Locale('ar')
             : const Locale('en');
         // Use the Riverpod provider to update the state AND EasyLocalization
         ref.read(localeProvider.notifier).setLocale(context, newLocale);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );

    // --- Dropdown Implementation (Keep if you prefer dropdown) ---
    /*
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: currentLocale,
        icon: const Icon(Icons.language, color: AppColors.white), // Example color
        dropdownColor: AppColors.black, // Example dropdown background
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
        items: [
          DropdownMenuItem(
            value: const Locale('en'),
            child: Text(AppStrings.english.tr()), // Use translated names
          ),
          DropdownMenuItem(
            value: const Locale('ar'),
            child: Text(AppStrings.arabic.tr()), // Use translated names
          ),
        ],
        onChanged: (Locale? newLocale) {
          if (newLocale != null && newLocale != currentLocale) {
            // Use the Riverpod provider to update the state AND EasyLocalization
            ref.read(localeProvider.notifier).setLocale(context, newLocale);
          }
        },
      ),
    );
    */
  }
}
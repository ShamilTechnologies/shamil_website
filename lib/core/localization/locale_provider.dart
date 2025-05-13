import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

// Provider that holds the current locale state
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  // Consider loading the initial/saved locale from shared_preferences if needed
  return LocaleNotifier(const Locale('en')); // Default to English
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(super.initialLocale);

  // Sets the locale both in the state and for EasyLocalization
  void setLocale(BuildContext context, Locale newLocale) {
    if (state != newLocale) {
      state = newLocale;
      context.setLocale(newLocale).then((_) {
        print("EasyLocalization locale set to: ${newLocale.languageCode}");
      }).catchError((error) {
        print("Error setting EasyLocalization locale: $error");
      });
      print("Riverpod locale state updated to: ${newLocale.languageCode}");
    }
  }
}
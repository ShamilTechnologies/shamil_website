import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/app.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setUrlStrategy(PathUrlStrategy()); // Use path URLs (no #) - Requires server config for deep linking

  // Optional: Initialize Firebase here if needed
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true, // Use 'en' instead of 'en_US'
      child: const ProviderScope( // Riverpod Scope
         child: MyApp(),
      ),
    ),
  );
}




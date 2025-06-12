import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/app.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Ensure this is imported

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  // FIX: This is the recommended way to set the URL strategy.
  setUrlStrategy(PathUrlStrategy());

  // Optional: Initialize Firebase here if needed
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: const ProviderScope(
         child: MyApp(),
      ),
    ),
  );
}
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Helpers {
  // Launches the given URL, handling potential errors
  static Future<void> launchUrlHelper(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showSnackBar(context, 'Could not launch $url');
      }
    } catch (e) {
       _showSnackBar(context, 'Error launching URL: $e');
    }
  }

  // Internal helper to show a SnackBar
  static void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating, // Good for web
        ),
      );
    }
  }

  // Add other utility functions here if needed
  // e.g., responsive value based on screen size
  static T responsiveValue<T>(BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 801) { // Corresponds to DESKTOP breakpoint in app.dart
      return desktop;
    } else if (screenWidth >= 451) { // Corresponds to TABLET breakpoint
      return tablet ?? desktop; // Fallback to desktop if tablet is null
    } else { // Mobile
      return mobile;
    }
  }
}
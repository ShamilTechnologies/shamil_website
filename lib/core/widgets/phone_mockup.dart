// lib/core/widgets/phone_mockup.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // For potential localization in error messages
import 'package:responsive_framework/responsive_framework.dart'; // For responsive sizing

class PhoneMockup extends StatelessWidget {
  final String appInterfaceAsset;
  final double? defaultWidth; // Optional: if you want to override default responsive width
  final Color frameColor;
  final Color screenBackgroundColor;
  final Color notchColor;

  const PhoneMockup({
    super.key,
    required this.appInterfaceAsset,
    this.defaultWidth,
    this.frameColor = Colors.black,
    this.screenBackgroundColor = Colors.black, // Default to black, can be themed
    this.notchColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Get theme for fallback text style

    // Phone dimensions - these can be adjusted
    // If defaultWidth is provided, use it, otherwise use ResponsiveValue
    final double phoneWidth = defaultWidth ?? ResponsiveValue(
      context,
      defaultValue: 240.0,
      conditionalValues: [
        Condition.smallerThan(name: TABLET, value: 220.0),
        Condition.largerThan(name: DESKTOP, value: 280.0),
      ]
    ).value;

    final double phoneHeight = phoneWidth * (19.5 / 9); // iPhone 15 Pro Max aspect ratio
    final double phoneBorderRadius = phoneWidth * 0.12; // Overall corner radius of the phone frame
    
    // --- BEZEL SIZE CONTROL ---
    // This padding creates the black border (bezel) around the screen.
    // You can adjust the multiplier (e.g., 0.02 for very thin, 0.04 for medium)
    final double bezelThickness = phoneWidth * 0.035; // Example: 3.5% of phone width

    // --- SCREEN CORNER RADIUS CONTROL ---
    // This radius is for the ClipRRect that shapes the "screen" area inside the bezel.
    // It should be slightly less than phoneBorderRadius to account for the bezel.
    final double screenCornerRadius = phoneBorderRadius - bezelThickness;

    // --- IMAGE CORNER RADIUS CONTROL ---
    // This radius is for the ClipRRect that shapes the actual app interface image.
    // It should be slightly less than screenCornerRadius.
    final double imageCornerRadius = screenCornerRadius * 0.9; // Example: 90% of screen corner radius

    // Notch dimensions (Dynamic Island style)
    final double notchHeight = phoneHeight * 0.035;
    final double notchWidth = phoneWidth * 0.35;
    // Position notch from the top of the screen area (inside the bezel)
    final double notchTopPosition = bezelThickness * 0.5; // Adjust as needed

    return Container(
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        color: frameColor, // Use passed frameColor
        borderRadius: BorderRadius.circular(phoneBorderRadius),
        boxShadow: [ // Subtle shadow for the phone frame itself
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // Slightly more defined shadow
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // This padding acts as the phone's bezel.
      padding: EdgeInsets.all(bezelThickness),
      child: ClipRRect(
        // This ClipRRect rounds the "screen" area inside the bezel.
        borderRadius: BorderRadius.circular(screenCornerRadius),
        child: Container(
          color: screenBackgroundColor, // Use passed screenBackgroundColor
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // App Interface Image
              Positioned.fill(
                child: ClipRRect(
                   // This border radius rounds the actual image content.
                   borderRadius: BorderRadius.circular(imageCornerRadius),
                  child: Image.asset(
                    appInterfaceAsset,
                    fit: BoxFit.cover, // Cover to fill the screen area
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        "App Preview Unavailable".tr(), // Ensure this key is in your JSON
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Dynamic Island / Notch
              Positioned(
                top: notchTopPosition,
                child: Container(
                  width: notchWidth,
                  height: notchHeight,
                  decoration: BoxDecoration(
                    color: notchColor, // Use passed notchColor
                    borderRadius: BorderRadius.circular(notchHeight / 2), // Rounded ends for the notch
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

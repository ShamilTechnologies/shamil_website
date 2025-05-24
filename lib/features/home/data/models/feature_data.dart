import 'package:flutter/material.dart' show Color;

class FeatureData {
  final String id; // Unique identifier for the feature
  final String lottieAsset; // Path to the Lottie animation file for the feature's icon
  final String titleKey; // Localization key for the feature's title
  final String descriptionKey; // Localization key for the feature's detailed description
  final Color cardColor; // Base color for the feature card (can be theme-dependent)

  const FeatureData({
    required this.id,
    required this.lottieAsset,
    required this.titleKey,
    required this.descriptionKey,
    required this.cardColor,
  });
}
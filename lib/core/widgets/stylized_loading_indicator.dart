// lib/core/widgets/stylized_loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // For localized loading text
import 'package:flutter_animate/flutter_animate.dart'; // For animating the indicator/text

// A styled loading indicator with a message.
class StylizedLoadingIndicator extends StatelessWidget {
  final String loadingTextKey; // Localization key for the loading message
  final double size;           // Size of the CircularProgressIndicator
  final double strokeWidth;    // Stroke width of the indicator
  final Color? color;          // Optional color for the indicator (defaults to theme's primary)

  const StylizedLoadingIndicator({
    super.key,
    this.loadingTextKey = "loadingContent", // Default localization key
    this.size = 50.0,
    this.strokeWidth = 3.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color indicatorColor = color ?? theme.colorScheme.secondary; // Use secondary (Gold) or passed color

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum space needed
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              strokeWidth: strokeWidth,
              // backgroundColor: indicatorColor.withOpacity(0.2), // Optional background for the track
            ),
          )
          .animate(onPlay: (controller) => controller.repeat()) // Make it pulse subtly
          .scaleXY(end: 1.1, duration: 800.ms, curve: Curves.easeInOut)
          .then(delay: 200.ms) // Wait after scaling up
          .scaleXY(end: 1 / 1.1, duration: 800.ms, curve: Curves.easeInOut), // Scale back down

          const SizedBox(height: 20), // Space between indicator and text

          Text(
            loadingTextKey.tr(), // Localized loading message
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          )
          .animate() // Animate the text
          .fadeIn(delay: 300.ms, duration: 500.ms)
          .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}

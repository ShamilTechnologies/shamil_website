// lib/features/home/presentation/widgets/parallax_background.dart
import 'package:flutter/material.dart';

// A widget that creates a parallax scrolling effect with multiple image layers.
class ParallaxBackground extends StatelessWidget {
  final ScrollController scrollController; // Controller for the main scroll view
  final List<String> imageLayers; // List of asset paths for the image layers
  final List<double> layerSpeeds; // Speeds for each layer, e.g., [0.1 (slowest), 0.3, 0.5 (fastest)]
  final Color? overlayColor; // Optional overlay color for better text contrast on top of images

  const ParallaxBackground({
    super.key,
    required this.scrollController,
    required this.imageLayers,
    required this.layerSpeeds,
    this.overlayColor,
  }) : assert(imageLayers.length == layerSpeeds.length,
              "imageLayers and layerSpeeds lists must have the same length.");

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // Ensures the Stack and its children fill the parent container
      children: [
        // Generate each parallax layer
        ...List.generate(imageLayers.length, (index) {
          final double parallaxFactor = layerSpeeds[index]; // Speed for the current layer

          return AnimatedBuilder(
            animation: scrollController, // Rebuilds when the scrollController notifies listeners
            builder: (context, child) {
              // Calculate the vertical offset for this layer based on scroll position and its speed factor.
              // Ensures scrollController.hasClients and position.hasPixels to avoid errors before scrolling starts.
              final double scrollOffset = scrollController.hasClients && scrollController.position.hasPixels
                  ? scrollController.offset
                  : 0.0;
              
              // The offset for Transform.translate.
              // We subtract the overall scrollOffset from the layer's calculated parallax offset.
              // This keeps the top of each parallax layer aligned with the top of the ParallaxBackground container,
              // creating the effect that deeper layers move slower relative to the foreground.
              final double verticalTranslate = (scrollOffset * parallaxFactor) - scrollOffset;

              return Transform.translate(
                offset: Offset(0, verticalTranslate), // Apply only vertical translation for parallax
                child: child,
              );
            },
            // The child of AnimatedBuilder is the Image widget, which is cached
            child: Image.asset(
              imageLayers[index], // Asset path for the current layer's image
              fit: BoxFit.cover,  // Ensures the image covers the layer's area, might crop
              width: double.infinity, // Should be redundant with Positioned.fill from parent if StackFit.expand is used
              height: double.infinity,// Should be redundant
              errorBuilder: (context, error, stackTrace) {
                // Fallback UI in case an image fails to load, helpful for debugging asset paths.
                return Container(
                  color: Colors.red.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Text(
                    "Error loading parallax layer:\n${imageLayers[index]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          );
        }),
        // Add a semi-transparent overlay on top of all layers if overlayColor is provided.
        // This helps improve the readability of any text or UI elements placed on top of the parallax background.
        if (overlayColor != null)
          Positioned.fill( // Ensures the overlay covers the entire area
            child: Container(color: overlayColor),
          ),
      ],
    );
  }
}

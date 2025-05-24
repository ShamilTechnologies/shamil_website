// lib/features/home/presentation/widgets/parallax_background.dart
import 'package:flutter/material.dart';

/// A widget that creates a parallax scrolling effect for background layers.
///
/// This adds depth to your UI by moving multiple image layers at different speeds
/// as the user scrolls, creating a 3D effect.
class ParallaxBackground extends StatelessWidget {
  /// The ScrollController that drives the parallax effect.
  /// This should be the same controller used by your page's ScrollView.
  final ScrollController scrollController;

  /// List of image asset paths to be used as parallax layers.
  /// The first item will be the furthest back (slowest moving) layer.
  /// The last item will be the closest (fastest moving) layer.
  final List<String> imageLayers;
  
  /// Optional: Speeds for each layer. If not provided, a default calculation will be used.
  /// Length must match imageLayers. Values typically between 0.1 (slow) and 1.0 (moves with scroll).
  final List<double>? layerSpeeds;


  /// Optional overlay color to add a tint to all layers for better text contrast.
  final Color? overlayColor;

  /// Optional BoxFit to control how images fill the available space.
  final BoxFit fit;

  /// Creates a parallax background effect.
  // REMOVED 'const' from the constructor to allow runtime assert.
  ParallaxBackground({
    super.key,
    required this.scrollController,
    required this.imageLayers,
    this.layerSpeeds, // Made layerSpeeds optional
    this.overlayColor,
    this.fit = BoxFit.cover,
  }) : assert(imageLayers.isNotEmpty, 'At least one image layer must be provided'),
       assert(layerSpeeds == null || imageLayers.length == layerSpeeds.length,
              "If layerSpeeds is provided, it must have the same length as imageLayers.");

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // Ensure Stack and its children fill the parent
      children: [
        ...List.generate(imageLayers.length, (index) {
          // Calculate parallax factor:
          // If layerSpeeds is provided, use it. Otherwise, calculate a default.
          // Default: earlier layers (background) move slower.
          final double parallaxFactor = layerSpeeds != null
              ? layerSpeeds![index]
              : 0.2 * (index + 1) / imageLayers.length; // Example default calculation

          return AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              // Ensure scrollController.hasClients before accessing offset to prevent errors
              // when the ScrollView is not yet attached or has no scrollable content.
              final double scrollOffset = scrollController.hasClients && scrollController.position.hasPixels
                  ? scrollController.offset
                  : 0.0;
              
              // The actual vertical translation for this layer.
              // To keep the top of the parallax layers aligned with the top of this widget's container,
              // we effectively want the layer to move "less" than the main scroll.
              // If parallaxFactor is 0.2, it moves at 20% of the main scroll speed *relative to the viewport*.
              // To achieve this while the ParallaxBackground widget itself is scrolling,
              // we translate it by scrollOffset * (parallaxFactor - 1.0).
              // Example: If scrollOffset is 100px and parallaxFactor is 0.2,
              // translation is 100 * (0.2 - 1.0) = 100 * -0.8 = -80px.
              // This means the layer has "stayed behind" by 80px relative to the HeroSection's top.
              // An alternative perspective: translate by scrollOffset * parallaxFactor,
              // and then if this ParallaxBackground is inside a Positioned.fill within another
              // scrolling container (like HeroSection), the effect works.
              // The user's original code had -scrollController.offset * parallaxFactor,
              // which makes layers scroll upwards faster than the content, creating a different effect.
              // For traditional parallax where background moves slower:
              final double verticalTranslate = scrollOffset * (parallaxFactor -1.0);
              // If you want the background to appear to move up as you scroll down (layers reveal from top):
              // final double verticalTranslate = -scrollOffset * parallaxFactor;


              return Transform.translate(
                offset: Offset(0, verticalTranslate),
                child: child,
              );
            },
            child: Image.asset(
              imageLayers[index],
              fit: fit, // Use the provided BoxFit
              width: double.infinity, // Ensure image tries to fill width
              height: double.infinity, // Ensure image tries to fill height (StackFit.expand helps)
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.red.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: Text("Error loading:\n${imageLayers[index]}", textAlign: TextAlign.center),
                );
              },
            ),
          );
        }),
        // Optional color overlay, drawn on top of all image layers
        if (overlayColor != null)
          Positioned.fill(
            child: Container(
              color: overlayColor,
            ),
          ),
      ],
    );
  }
}

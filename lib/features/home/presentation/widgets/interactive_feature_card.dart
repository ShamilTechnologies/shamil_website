// lib/features/home/presentation/widgets/interactive_feature_card.dart
import 'package:flutter/material.dart';
// For hover and expand animations
import 'package:lottie/lottie.dart'; // Assuming Lottie for feature icons
import 'package:easy_localization/easy_localization.dart'; // For text localization
import 'package:shamil_web/core/constants/app_dimensions.dart'; // For consistent padding/sizing
import 'package:shamil_web/features/home/data/models/feature_data.dart'; // The data model for features

// A card widget that displays a feature with interactive hover and tap-to-expand effects.
class InteractiveFeatureCard extends StatefulWidget {
  final FeatureData feature; // Data for the feature to display
  final Duration staggerDelay; // Optional delay for staggered entrance animations

  const InteractiveFeatureCard({
    super.key,
    required this.feature,
    this.staggerDelay = Duration.zero,
  });

  @override
  State<InteractiveFeatureCard> createState() => _InteractiveFeatureCardState();
}

class _InteractiveFeatureCardState extends State<InteractiveFeatureCard> {
  bool _isHovered = false; // Tracks if the mouse is hovering over the card
  bool _isExpanded = false; // Tracks if the card is tapped and expanded

  // Computes the transformation matrix for the 3D hover effect.
  Matrix4 _getTransform() {
    if (_isHovered) {
      // Apply a perspective transform with slight rotation and scale when hovered.
      return Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Adds perspective, making rotations look 3D
        ..rotateX(0.03) // Slight tilt on the X-axis
        ..rotateY(-0.03) // Slight tilt on the Y-axis
        ..scale(1.05); // Slightly scale up the card
    }
    return Matrix4.identity(); // No transform when not hovered
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Define the height for collapsed and expanded states.
    final double collapsedHeight = 260.0;
    final double expandedHeight = 340.0; // Increased height for more description space

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), // Set hover state to true
      onExit: (_) => setState(() => _isHovered = false),  // Set hover state to false
      cursor: SystemMouseCursors.click, // Indicate that the card is clickable
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded), // Toggle expanded state on tap
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350), // Duration for all animations (transform, size)
          curve: Curves.easeInOutCubic, // Smooth easing curve for animations
          transform: _getTransform(), // Apply the 3D hover transform
          transformAlignment: Alignment.center, // Transform originates from the center
          width: _isExpanded ? 270 : 230, // Card width expands slightly
          height: _isExpanded ? expandedHeight : collapsedHeight, // Card height animates
          padding: const EdgeInsets.all(AppDimensions.paddingMedium), // Consistent internal padding
          decoration: BoxDecoration(
            // Use the cardColor from FeatureData, with opacity adjusted by theme and expansion
            color: widget.feature.cardColor.withOpacity(
                _isExpanded ? 0.9 : (theme.brightness == Brightness.dark ? 0.75 : 0.65)),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            boxShadow: [ // Dynamic shadow based on hover and expansion state
              BoxShadow(
                color: _isHovered || _isExpanded
                    ? Colors.black.withOpacity(0.22) // More prominent shadow when active
                    : Colors.black.withOpacity(0.12),
                blurRadius: _isHovered || _isExpanded ? 20 : 12,
                spreadRadius: _isHovered || _isExpanded ? 2 : 1,
                offset: _isHovered || _isExpanded ? const Offset(0, 7) : const Offset(0, 4),
              ),
            ],
            border: Border.all( // Subtle border, slightly more visible in dark mode
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.black.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align content to the start
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lottie animation for the feature icon
              Lottie.asset(
                widget.feature.lottieAsset,
                height: _isExpanded ? 65 : 80, // Icon might adjust size
                width: _isExpanded ? 65 : 80,
                fit: BoxFit.contain,
                animate: true, // Ensure Lottie animation plays
              ),
              SizedBox(height: _isExpanded ? AppDimensions.spacingSmall : AppDimensions.spacingMedium),
              // Feature title
              Text(
                widget.feature.titleKey.tr(), // Localized title
                style: theme.textTheme.titleLarge?.copyWith( // Larger title
                  fontWeight: FontWeight.w700, // Bolder
                  color: theme.colorScheme.onSurface, // Theme-aware text color
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // AnimatedSwitcher for smoothly showing/hiding the detailed description.
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Use FadeTransition and SizeTransition for a smooth appearance/disappearance.
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
                  );
                },
                child: _isExpanded
                    ? Padding( // Shown only when _isExpanded is true
                        key: ValueKey(widget.feature.id), // Unique key for AnimatedSwitcher
                        padding: const EdgeInsets.only(top: AppDimensions.spacingMedium),
                        child: Text(
                          widget.feature.descriptionKey.tr(), // Localized description
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.85),
                            fontSize: 14, // Slightly larger description text
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 6, // Allow more lines for description
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox.shrink(key: ValueKey("${widget.feature.id}_empty")), // Empty box when not expanded
              ),
            ],
          ),
        ),
      ),
    );
  }
}

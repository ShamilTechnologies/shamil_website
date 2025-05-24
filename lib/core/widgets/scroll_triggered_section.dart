// lib/core/widgets/scroll_triggered_section.dart
import 'dart:math' as math; // For math.max and math.min
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Using flutter_animate for simplicity

// A widget that animates its child when it scrolls into view.
class ScrollTriggeredSection extends StatefulWidget {
  final ScrollController scrollController; // The main scroll controller of the page
  final Widget child; // The content to be animated
  final Duration delay; // Optional delay before the animation starts after becoming visible
  final Duration duration; // Duration of the entrance animation
  final double initialOffsetY; // How far down the child starts before sliding up
  final double visibleThreshold; // Percentage of widget height that needs to be visible to trigger (0.0 to 1.0)
  final Curve curve; // Animation curve

  const ScrollTriggeredSection({
    super.key,
    required this.scrollController,
    required this.child,
    this.delay = Duration.zero, // Default no delay
    this.duration = const Duration(milliseconds: 600), // Default animation duration
    this.initialOffsetY = 60.0, // Default starting offset
    this.visibleThreshold = 0.2, // Trigger when 20% of the widget is visible
    this.curve = Curves.easeOutCubic, // Default animation curve
  });

  @override
  State<ScrollTriggeredSection> createState() => _ScrollTriggeredSectionState();
}

class _ScrollTriggeredSectionState extends State<ScrollTriggeredSection> {
  final GlobalKey _sectionKey = GlobalKey(); // Key to get the widget's position and size
  bool _isAnimated = false; // Flag to ensure animation only runs once
  bool _isVisible = false; // Tracks if the widget is currently considered visible enough to animate

  @override
  void initState() {
    super.initState();
    // Add listener after the first frame to ensure context and RenderBox are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Check if the widget is still in the widget tree
        widget.scrollController.addListener(_checkVisibilityAndAnimate);
        _checkVisibilityAndAnimate(); // Initial check in case it's already visible
      }
    });
  }

  @override
  void dispose() {
    // Remove listener if it was added
    // Note: scrollController itself is managed by HomeScreen, so we only remove our listener
    if (widget.scrollController.hasListeners) {
       // It's safer to check if the controller is still active before removing.
       // However, the controller passed is from HomeScreen, so it should outlive this.
       // A more robust way for multiple listeners is to store the listener function and remove that specific one.
       // For this case, assuming HomeScreen manages the controller's lifecycle.
       try {
         widget.scrollController.removeListener(_checkVisibilityAndAnimate);
       } catch (e) {
         // print("Error removing listener from ScrollTriggeredSection: $e");
         // This can happen if the controller was disposed before this widget.
       }
    }
    super.dispose();
  }

  // Checks if the widget is visible enough in the viewport to trigger the animation.
  void _checkVisibilityAndAnimate() {
    if (!mounted || _isAnimated || _sectionKey.currentContext == null) {
      // If not mounted, already animated, or context is null, do nothing.
      return;
    }

    final RenderBox? box = _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      // If RenderBox is not available or has no size, do nothing.
      return;
    }

    final position = box.localToGlobal(Offset.zero); // Position of the widget relative to the screen origin
    final size = box.size; // Size of the widget
    final screenHeight = MediaQuery.of(context).size.height; // Height of the viewport

    // Calculate the visible portion of the widget on the screen
    final double visibleTop = math.max(0.0, position.dy); // Top edge of visible part
    final double visibleBottom = math.min(screenHeight, position.dy + size.height); // Bottom edge of visible part
    final double visibleHeight = math.max(0.0, visibleBottom - visibleTop); // Height of the visible part

    // Calculate the percentage of the widget that is currently visible
    final double visibilityPercentage = (size.height > 0) ? (visibleHeight / size.height) : 0.0;

    // Check if the widget is visible enough to trigger the animation
    if (visibilityPercentage >= widget.visibleThreshold && !_isAnimated) {
      if (mounted) {
        setState(() {
          _isVisible = true; // Mark as visible to trigger animation
          _isAnimated = true; // Ensure animation runs only once
        });
        // No need to remove listener here if we want other scroll-triggered effects later,
        // but for a one-shot entrance, it could be removed.
        // widget.scrollController.removeListener(_checkVisibilityAndAnimate);
      }
    }
    // Optional: If you want the animation to reset and replay if it scrolls out and back in,
    // you would add logic here to set _isVisible = false and _isAnimated = false under certain conditions.
    // For a simple entrance animation, _isAnimated = true is usually sufficient.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _sectionKey, // Attach the key to the container whose visibility we are tracking
      child: widget.child
          .animate(
            target: _isVisible ? 1.0 : 0.0, // Animate when _isVisible becomes true
            delay: widget.delay, // Apply the specified delay
          )
          .fade(duration: widget.duration, curve: widget.curve) // Fade-in effect
          .slideY(begin: widget.initialOffsetY / 100, end: 0.0, duration: widget.duration, curve: widget.curve), // Slide-up effect
          // Note: flutter_animate's slideY 'begin' is often a fraction of height/width.
          // If initialOffsetY is in pixels, you might need to adjust how it's used or use .moveY().
          // For simplicity, this example assumes initialOffsetY could be a factor like 0.2 (20% of height).
          // If initialOffsetY is pixels, a better approach for slideY:
          // .moveY(begin: widget.initialOffsetY, end: 0.0, duration: widget.duration, curve: widget.curve)
    );
  }
}

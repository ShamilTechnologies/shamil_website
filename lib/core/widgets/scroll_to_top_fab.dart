// lib/core/widgets/scroll_to_top_fab.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations

// A FloatingActionButton that appears when the user scrolls down
// and allows them to quickly scroll back to the top of the page.
class ScrollToTopFAB extends StatefulWidget {
  final ScrollController scrollController; // The main scroll controller of the page
  final Duration animationDuration; // Duration for show/hide animations
  final double scrollOffsetToShow; // Scroll offset after which the button appears

  const ScrollToTopFAB({
    super.key,
    required this.scrollController,
    this.animationDuration = const Duration(milliseconds: 300),
    this.scrollOffsetToShow = 300.0, // Show button after scrolling 300 pixels
  });

  @override
  State<ScrollToTopFAB> createState() => _ScrollToTopFABState();
}

class _ScrollToTopFABState extends State<ScrollToTopFAB> {
  bool _showButton = false; // Tracks whether the button should be visible

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller to check scroll position
    widget.scrollController.addListener(_checkScrollOffset);
    // Initial check in case the page is already scrolled (e.g., on hot reload)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkScrollOffset();
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed to prevent memory leaks
    // It's good practice to check if the controller still has listeners
    // or if this specific listener is attached, but for simplicity:
    try {
      widget.scrollController.removeListener(_checkScrollOffset);
    } catch (e) {
      // print("Error removing listener from ScrollToTopFAB: $e");
    }
    super.dispose();
  }

  // Checks the current scroll offset and updates the button's visibility.
  void _checkScrollOffset() {
    if (!widget.scrollController.hasClients) return; // Do nothing if controller is not attached

    final bool shouldShow = widget.scrollController.offset > widget.scrollOffsetToShow;
    if (shouldShow != _showButton) {
      if (mounted) {
        setState(() {
          _showButton = shouldShow;
        });
      }
    }
  }

  // Scrolls the page to the top.
  void _scrollToTop() {
    if (!widget.scrollController.hasClients) return;
    widget.scrollController.animateTo(
      0, // Scroll to the top (offset 0)
      duration: const Duration(milliseconds: 600), // Duration of the scroll animation
      curve: Curves.easeInOutCubic, // Smooth animation curve
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // The FAB is wrapped in Animate to control its appearance/disappearance.
    // The 'target' drives the animation: 1.0 for visible, 0.0 for hidden.
    return Animate(
      target: _showButton ? 1.0 : 0.0, // Animate based on _showButton state
      effects: [
        // Fade effect for opacity
        FadeEffect(duration: widget.animationDuration, curve: Curves.easeInOut),
        // Slide effect to make it appear from the bottom
        SlideEffect(
          begin: const Offset(0, 2), // Start 2x its height below its final position
          end: Offset.zero,
          duration: widget.animationDuration,
          curve: Curves.easeInOutCubic,
        ),
      ],
      // The actual FloatingActionButton
      child: FloatingActionButton(
        onPressed: _scrollToTop, // Action to perform when tapped
        // Use theme colors for the FAB
        backgroundColor: theme.colorScheme.secondary, // Example: Use secondary color (Gold)
        foregroundColor: theme.colorScheme.onSecondary, // Text/icon color on secondary
        tooltip: 'Scroll to top'.tr(), // Accessibility tooltip (localize this)
        elevation: _showButton ? 6.0 : 0.0, // Show elevation only when button is visible
        child: const Icon(Icons.arrow_upward_rounded),
      ),
    );
  }
}

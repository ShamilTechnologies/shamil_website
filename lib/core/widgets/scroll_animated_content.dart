// lib/core/widgets/scroll_animated_content.dart
import 'package:flutter/material.dart';

import 'package:shamil_web/core/constants/app_dimensions.dart'; // For math.max/min if needed for more complex triggers

// A widget that animates its children (e.g., an image and text)
// with a slide transition when a certain scroll offset is reached.
class ScrollAnimatedContent extends StatefulWidget {
  final ScrollController scrollController;
  final Widget leftChild; // Widget to slide in from the left
  final Widget? rightChild; // Optional widget to slide in from the right
  final double triggerScrollOffset; // Scroll offset (in pixels) to trigger the animation
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Curve animationCurve;

  const ScrollAnimatedContent({
    super.key,
    required this.scrollController,
    required this.leftChild,
    this.rightChild,
    required this.triggerScrollOffset, // e.g., 1200.0
    this.animationDuration = const Duration(milliseconds: 800), // Slower than your example for smoother feel
    this.reverseAnimationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<ScrollAnimatedContent> createState() => _ScrollAnimatedContentState();
}

class _ScrollAnimatedContentState extends State<ScrollAnimatedContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation; // For the right child

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
    );

    // Animation for the left child: slides in from the left (-1.0 dx) to its original position (0.0 dx)
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start off-screen to the left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    // Animation for the right child (if it exists): slides in from the right (1.0 dx)
    if (widget.rightChild != null) {
      _rightSlideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Start off-screen to the right
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
    }

    // Add listener to the scroll controller
    widget.scrollController.addListener(_onScroll);

    // Initial check in case the content is already past the trigger point on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.dispose();
    super.dispose();
  }

  // Called when the scroll controller detects a scroll event
  void _onScroll() {
    if (!mounted) return; // Do nothing if the widget is no longer in the tree

    // Check if the scroll controller is attached to a ScrollPosition
    if (!widget.scrollController.hasClients) return;

    final currentOffset = widget.scrollController.offset;

    // If current scroll offset is past the trigger point, forward the animation
    if (currentOffset > widget.triggerScrollOffset) {
      if (!_animationController.isCompleted && !_animationController.isAnimating) {
        _animationController.forward();
      }
    } else { // Otherwise, reverse the animation
      if (!_animationController.isDismissed && !_animationController.isAnimating) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using a Row to place left and right children side-by-side
    // You can adjust this layout as needed (e.g., Stack, Column)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center content if row is wider
      crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
      children: [
        // Left child with SlideTransition
        Expanded( // Use Expanded to allow children to take available space
          child: SlideTransition(
            position: _leftSlideAnimation,
            child: widget.leftChild,
          ),
        ),
        // Right child with SlideTransition, if it exists
        if (widget.rightChild != null)
          const SizedBox(width: AppDimensions.paddingLarge), // Space between children
        if (widget.rightChild != null)
          Expanded(
            child: SlideTransition(
              position: _rightSlideAnimation,
              child: widget.rightChild!,
            ),
          ),
      ],
    );
  }
}

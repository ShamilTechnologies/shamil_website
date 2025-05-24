// lib/features/common/widgets/scroll_to_top_fab.dart

import 'package:flutter/material.dart';

/// A floating action button that appears when scrolling down and allows
/// the user to quickly return to the top of the page.
class ScrollToTopFAB extends StatefulWidget {
  /// The ScrollController to monitor for scroll position changes.
  final ScrollController scrollController;
  
  /// The offset threshold at which the button appears.
  final double showThreshold;
  
  /// The duration for the button's appearance/disappearance animation.
  final Duration animationDuration;
  
  /// The curve for the button's animations.
  final Curve animationCurve;
  
  /// Icon to use for the button.
  final IconData icon;
  
  /// Optional tooltip text for the button.
  final String? tooltip;
  
  /// Optional color for the button.
  final Color? backgroundColor;
  
  /// Optional color for the icon.
  final Color? iconColor;

  /// Creates a scroll-to-top floating action button.
  const ScrollToTopFAB({
    super.key,
    required this.scrollController,
    this.showThreshold = 300.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.icon = Icons.arrow_upward,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  State<ScrollToTopFAB> createState() => _ScrollToTopFABState();
}

class _ScrollToTopFABState extends State<ScrollToTopFAB> {
  bool _showButton = false;
  
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_checkScroll);
  }
  
  @override
  void dispose() {
    widget.scrollController.removeListener(_checkScroll);
    super.dispose();
  }
  
  void _checkScroll() {
    if (!mounted) return;
    
    final showButton = widget.scrollController.hasClients &&
        widget.scrollController.offset > widget.showThreshold;
    
    if (showButton != _showButton) {
      setState(() => _showButton = showButton);
    }
  }
  
  void _scrollToTop() {
    if (!widget.scrollController.hasClients) return;
    
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Final button visually shown or hidden based on scroll position
    return AnimatedOpacity(
      opacity: _showButton ? 1.0 : 0.0,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      child: AnimatedSlide(
        offset: Offset(0, _showButton ? 0 : 2), // Slide in/out from bottom
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        child: IgnorePointer(
          ignoring: !_showButton, // Prevent interaction when hidden
          child: FloatingActionButton(
            onPressed: _scrollToTop,
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.iconColor,
            tooltip: widget.tooltip,
            elevation: 4.0,
            mini: true,
            child: Icon(widget.icon),
          ),
        ),
      ),
    );
  }
}
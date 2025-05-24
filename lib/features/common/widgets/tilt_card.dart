// lib/features/common/widgets/tilt_card.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A card widget that responds to hover with a 3D tilt effect.
///
/// This creates a more engaging and interactive UI element by
/// making the card appear to tilt toward the user's cursor.
class TiltCard extends StatefulWidget {
  /// The content of the card.
  final Widget child;

  /// The maximum tilt angle in degrees.
  final double maxTiltAngle;

  /// The maximum scale factor when hovering.
  final double maxScale;

  /// The duration for the tilt animation.
  final Duration animationDuration;

  /// Whether to apply a shadow effect that changes with the tilt.
  final bool dynamicShadow;

  /// Decoration for the card.
  final BoxDecoration? decoration;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  // *** CHANGED TYPE from bool? to Clip? ***
  /// Defines how to clip the content of the card.
  /// Defaults to Clip.antiAlias if null.
  final Clip? clipBehavior;

  /// Creates a tilt card widget.
  const TiltCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 5.0,
    this.maxScale = 1.05,
    this.animationDuration = const Duration(milliseconds: 200),
    this.dynamicShadow = true,
    this.decoration,
    this.padding,
    this.clipBehavior, // Now expects a Clip? value or null
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  bool _isHovering = false;
  double _rotateX = 0;
  double _rotateY = 0;

  // Size of the card - used to calculate tilt angles
  double _cardWidth = 100; // Default, will be updated
  double _cardHeight = 100; // Default, will be updated

  // Keep track of global position for shadow angle (if needed for more advanced shadow)
  // Offset _globalPosition = Offset.zero; // Not directly used in current shadow calculation

  void _onHoverStart(PointerEvent event) {
    if (mounted) {
      setState(() {
        _isHovering = true;
      });
    }
  }

  void _onHoverEnd(PointerEvent event) {
    if (mounted) {
      setState(() {
        _isHovering = false;
        _rotateX = 0; // Reset tilt
        _rotateY = 0; // Reset tilt
      });
    }
  }

  void _onHoverUpdate(PointerEvent event) {
    if (!_isHovering || !mounted) return;

    // Get the render box to determine card dimensions
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return; // Ensure box has size

    // Update card dimensions if they have changed (e.g., due to layout changes)
    // This check prevents unnecessary rebuilds if size is stable.
    if (_cardWidth != box.size.width || _cardHeight != box.size.height) {
      _cardWidth = box.size.width;
      _cardHeight = box.size.height;
    }
    
    // Get local position of the cursor within the card
    final localPosition = box.globalToLocal(event.position);
    // _globalPosition = event.position; // Store global if needed for other effects

    // Calculate tilt angles based on cursor position relative to the card's center
    final double centerX = _cardWidth / 2;
    final double centerY = _cardHeight / 2;

    // Normalize positions to a -1.0 to 1.0 range
    // Avoid division by zero if card width/height is zero
    final double normalizedX = _cardWidth > 0 ? (localPosition.dx - centerX) / centerX : 0;
    final double normalizedY = _cardHeight > 0 ? (localPosition.dy - centerY) / centerY : 0;

    // Convert maxTiltAngle from degrees to radians for Matrix4 transformations
    final maxRadians = widget.maxTiltAngle * (math.pi / 180);

    // Update the rotation state.
    // The tilt around Y-axis is driven by horizontal mouse movement (normalizedX).
    // The tilt around X-axis is driven by vertical mouse movement (normalizedY), inverted for natural feel.
    setState(() {
      _rotateY = normalizedX.clamp(-1.0, 1.0) * maxRadians; // Clamp normalized values
      _rotateX = -normalizedY.clamp(-1.0, 1.0) * maxRadians;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construct the transformation matrix for the 3D effect
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective entry for 3D effect
      ..rotateX(_rotateX)     // Apply tilt around X-axis
      ..rotateY(_rotateY)     // Apply tilt around Y-axis
      ..scale(_isHovering ? widget.maxScale : 1.0); // Apply scale on hover

    // Determine the effective decoration for the card
    final effectiveDecoration = widget.decoration ?? BoxDecoration(
      color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16.0), // Default border radius
      boxShadow: [
        if (widget.dynamicShadow) // Only add shadow if dynamicShadow is true
          BoxShadow(
            color: Colors.black.withOpacity(_isHovering ? 0.15 : 0.08), // Shadow opacity changes on hover
            blurRadius: _isHovering ? 16.0 : 10.0, // Blur radius changes on hover
            spreadRadius: _isHovering ? 3.0 : 1.0,  // Spread radius changes on hover
            // Shadow offset changes dynamically based on tilt for a more realistic effect
            offset: _isHovering
                ? Offset(_rotateY * 10.0, -_rotateX * 10.0) // Shadow moves opposite to tilt
                : const Offset(0, 4), // Default shadow offset when not hovered
          ),
      ],
    );

    return MouseRegion(
      onEnter: _onHoverStart, // Called when mouse enters the widget area
      onExit: _onHoverEnd,   // Called when mouse exits the widget area
      onHover: _onHoverUpdate, // Continuously called while mouse hovers (REPLACED Listener)
      cursor: SystemMouseCursors.click, // Change cursor to indicate interactivity
      // Listener for onPointerMove was removed as MouseRegion's onHover provides continuous updates
      // and is generally preferred for hover effects.
      child: AnimatedContainer(
        duration: widget.animationDuration, // Duration for animations (transform, decoration changes)
        curve: Curves.easeOutCubic,        // Smooth animation curve
        transform: matrix,                 // Apply the calculated 3D transform
        transformAlignment: Alignment.center, // Ensure transform originates from the center
        decoration: effectiveDecoration,   // Apply the card's decoration (color, shadow, border radius)
        padding: widget.padding,           // Apply internal padding if provided
        // *** CORRECTED clipBehavior USAGE ***
        // Use the widget.clipBehavior (which is now Clip?) or default to Clip.antiAlias.
        clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
        child: widget.child,               // The actual content of the card
      ),
    );
  }
}

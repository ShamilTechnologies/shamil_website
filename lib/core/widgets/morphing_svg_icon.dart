// lib/core/widgets/morphing_svg_icon.dart (Conceptual)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For basic SVG display

// Note: True SVG path morphing usually requires a library like Rive or
// carefully crafted SVGs and custom Tweening logic.
// This example demonstrates a simple cross-fade between two SVGs as a placeholder.

class MorphingSvgIcon extends StatefulWidget {
  final String initialSvgAsset; // Asset path for the initial SVG state
  final String targetSvgAsset;  // Asset path for the target SVG state (e.g., on hover/tap)
  final bool animate;           // External trigger to "morph" (cross-fade in this example)
  final double size;            // Size of the icon
  final Duration duration;      // Duration of the cross-fade animation

  const MorphingSvgIcon({
    super.key,
    required this.initialSvgAsset,
    required this.targetSvgAsset,
    required this.animate,
    this.size = 24.0,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<MorphingSvgIcon> createState() => _MorphingSvgIconState();
}

class _MorphingSvgIconState extends State<MorphingSvgIcon> {
  @override
  Widget build(BuildContext context) {
    // Get the current icon color from the theme to make SVGs theme-aware (if they are monochrome)
    final Color? iconColor = Theme.of(context).iconTheme.color;

    // AnimatedCrossFade provides a simple way to switch between two widgets with a fade.
    return AnimatedCrossFade(
      duration: widget.duration,
      firstChild: SvgPicture.asset( // Widget for the initial state
        widget.initialSvgAsset,
        width: widget.size,
        height: widget.size,
        colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
        placeholderBuilder: (context) => SizedBox(width: widget.size, height: widget.size), // Placeholder
      ),
      secondChild: SvgPicture.asset( // Widget for the target state
        widget.targetSvgAsset,
        width: widget.size,
        height: widget.size,
        colorFilter: iconColor != null ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
        placeholderBuilder: (context) => SizedBox(width: widget.size, height: widget.size), // Placeholder
      ),
      // Determines which child (firstChild or secondChild) is currently visible.
      crossFadeState: widget.animate ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      // layoutBuilder allows customizing how the two children are stacked during the transition.
      // DefaultLayoutBuilder.fadeOutIn is a common choice.
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(key: bottomChildKey, child: bottomChild),
            Positioned(key: topChildKey, child: topChild),
          ],
        );
      },
    );
  }
}

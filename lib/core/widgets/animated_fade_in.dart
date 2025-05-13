import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedFadeIn extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double beginOffsetY; // 0 = no slide, positive = slide from bottom

  const AnimatedFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffsetY = 0.1, // Default slide from bottom slightly
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      delay: delay,
      effects: [
        FadeEffect(duration: duration, curve: Curves.easeOut),
        if (beginOffsetY != 0) // Only add slide if offset is non-zero
          SlideEffect(
            begin: Offset(0, beginOffsetY),
            end: Offset.zero,
            duration: duration,
            curve: Curves.easeOut,
          ),
      ],
      child: child,
    );
  }
}

// --- Usage Example (inside another widget's build method): ---
// AnimatedFadeIn(
//   delay: 300.ms,
//   child: Text("This text will fade and slide in"),
// )
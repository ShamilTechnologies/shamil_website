
import 'package:flutter/material.dart';

/// A widget that renders an animated gradient background.
/// 
/// The gradient colors and animation speed can be customized.
/// This creates a subtle moving background effect that adds
/// visual interest without overwhelming the content.
class AnimatedGradientBackground extends StatefulWidget {
  /// The colors to use in the gradient. If not provided,
  /// colors will be derived from the current theme.
  final List<Color>? colors;

  /// Duration for one complete animation cycle.
  final Duration duration;

  /// Whether the gradient animation should repeat.
  final bool repeat;

  /// Creates an animated gradient background.
  const AnimatedGradientBackground({
    super.key,
    this.colors,
    this.duration = const Duration(seconds: 10),
    this.repeat = true,
  });

  @override
  AnimatedGradientBackgroundState createState() => AnimatedGradientBackgroundState();
}

class AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignment;
  late Animation<Alignment> _bottomAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
    
    _topAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);
    
    _bottomAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    
    // Default colors based on theme if none provided
    final gradientColors = widget.colors ?? (isDark 
      ? [
          theme.colorScheme.primary.withOpacity(0.7),
          theme.colorScheme.surface.withOpacity(0.9),
          theme.colorScheme.tertiary.withOpacity(0.7),
        ]
      : [
          theme.colorScheme.primary.withOpacity(0.2),
          theme.colorScheme.surface,
          theme.colorScheme.tertiary.withOpacity(0.2),
        ]);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _topAlignment.value,
              end: _bottomAlignment.value,
              colors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
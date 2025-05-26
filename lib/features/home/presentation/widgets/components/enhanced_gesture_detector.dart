// lib/features/home/presentation/widgets/helpers/enhanced_swipe_physics.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced physics calculations for smooth card swiping
class SwipePhysics {
  
  /// Calculates the exit trajectory for a swiped card
  static Offset calculateExitTrajectory({
    required double velocity,
    required double dragDistance,
    required bool isSwipingRight,
    required double cardWidth,
  }) {
    final direction = isSwipingRight ? 1.0 : -1.0;
    final baseExitDistance = cardWidth * 1.5;
    final velocityMultiplier = (velocity / 1000.0).clamp(1.0, 3.0);
    
    final exitX = baseExitDistance * direction * velocityMultiplier;
    final exitY = -50.0 * math.sin((dragDistance.abs() / cardWidth) * math.pi / 4);
    
    return Offset(exitX, exitY);
  }
  
  /// Calculates spring-back animation values
  static Map<String, double> calculateSpringBack({
    required double currentOffset,
    required double velocity,
    required double tension,
    required double friction,
  }) {
    final dampingRatio = friction / (2.0 * math.sqrt(tension));
    final naturalFreq = math.sqrt(tension);
    
    if (dampingRatio < 1.0) {
      // Underdamped spring
      final dampedFreq = naturalFreq * math.sqrt(1.0 - dampingRatio * dampingRatio);
      final decayRate = dampingRatio * naturalFreq;
      
      return {
        'dampedFreq': dampedFreq,
        'decayRate': decayRate,
        'amplitude': currentOffset,
        'phase': math.atan2(velocity + decayRate * currentOffset, dampedFreq * currentOffset),
      };
    } else {
      // Critically damped or overdamped
      return {
        'decayRate': naturalFreq,
        'amplitude': currentOffset,
      };
    }
  }
  
  /// Calculates rotation based on drag distance and velocity
  static double calculateRotation({
    required double dragDistance,
    required double velocity,
    required double maxRotation,
    required double cardWidth,
  }) {
    final normalizedDrag = (dragDistance / cardWidth).clamp(-1.0, 1.0);
    final velocityFactor = (velocity.abs() / 2000.0).clamp(0.0, 0.5);
    
    return (normalizedDrag * maxRotation) + (velocityFactor * maxRotation * normalizedDrag.sign);
  }
  
  /// Calculates scale based on interaction state
  static double calculateInteractiveScale({
    required double dragDistance,
    required double cardWidth,
    required bool isDragging,
    required bool isAnimating,
  }) {
    if (isAnimating && !isDragging) return 1.0;
    
    final dragProgress = (dragDistance.abs() / cardWidth).clamp(0.0, 0.5);
    final scaleReduction = isDragging ? dragProgress * 0.15 : dragProgress * 0.08;
    
    return (1.0 - scaleReduction).clamp(0.7, 1.0);
  }
  
  /// Calculates opacity based on drag progress
  static double calculateInteractiveOpacity({
    required double dragDistance,
    required double cardWidth,
    required bool isDragging,
  }) {
    final dragProgress = (dragDistance.abs() / cardWidth).clamp(0.0, 1.0);
    final opacityReduction = isDragging ? dragProgress * 0.4 : dragProgress * 0.2;
    
    return (1.0 - opacityReduction).clamp(0.3, 1.0);
  }
}

/// Enhanced gesture detector specifically for card interactions
class CardSwipeDetector extends StatefulWidget {
  final Widget child;
  final Function(bool isNext)? onSwipe;
  final VoidCallback? onTap;
  final Function(double progress, double velocity)? onSwipeProgress;
  final double swipeThreshold;
  final double velocityThreshold;
  final bool enabled;

  const CardSwipeDetector({
    super.key,
    required this.child,
    this.onSwipe,
    this.onTap,
    this.onSwipeProgress,
    this.swipeThreshold = 100.0,
    this.velocityThreshold = 800.0,
    this.enabled = true,
  });

  @override
  State<CardSwipeDetector> createState() => _CardSwipeDetectorState();
}

class _CardSwipeDetectorState extends State<CardSwipeDetector> {
  double _dragStartX = 0.0;
  double _currentDragX = 0.0;
  bool _isDragging = false;

  void _handlePanStart(DragStartDetails details) {
    if (!widget.enabled) return;
    
    _dragStartX = details.localPosition.dx;
    _currentDragX = 0.0;
    _isDragging = true;
    
    // Light haptic feedback on drag start
    HapticFeedback.lightImpact();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.enabled || !_isDragging) return;
    
    _currentDragX = details.localPosition.dx - _dragStartX;
    final velocity = details.delta.dx * 10;
    
    widget.onSwipeProgress?.call(_currentDragX, velocity);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!widget.enabled || !_isDragging) return;
    
    _isDragging = false;
    final velocity = details.velocity.pixelsPerSecond.dx.abs();
    final shouldSwipe = _currentDragX.abs() > widget.swipeThreshold || 
                       velocity > widget.velocityThreshold;
    
    if (shouldSwipe) {
      final isNext = _currentDragX < 0; // Swiping left goes to next
      widget.onSwipe?.call(isNext);
      
      // Medium haptic feedback on successful swipe
      HapticFeedback.mediumImpact();
    } else {
      // Selection click for spring back
      HapticFeedback.selectionClick();
    }
    
    _currentDragX = 0.0;
  }

  void _handleTap() {
    if (!widget.enabled) return;
    
    widget.onTap?.call();
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTap: _handleTap,
      child: widget.child,
    );
  }
}

/// Animation curves optimized for card interactions
class CardAnimationCurves {
  // Exit animations - sharp and decisive
  static const Curve cardExit = Curves.easeInCubic;
  static const Curve cardExitFast = Curves.easeInQuart;
  
  // Enter animations - smooth and welcoming
  static const Curve cardEnter = Curves.easeOutCubic;
  static const Curve cardEnterBounce = Curves.elasticOut;
  
  // Spring back - natural and elastic
  static const Curve springBack = Curves.elasticOut;
  static const Curve springBackSubtle = Curves.easeOutBack;
  
  // Settle animations - gentle and final
  static const Curve settle = Curves.easeOutQuart;
  static const Curve settleSmooth = Curves.easeInOutCubic;
  
  // Interactive feedback - responsive and immediate
  static const Curve interactiveFeedback = Curves.easeOutQuart;
  static const Curve hoverFeedback = Curves.easeInOutCubic;
}

/// Animation duration constants for consistent timing
class CardAnimationDurations {
  // Core swipe animations
  static const Duration swipeExit = Duration(milliseconds: 400);
  static const Duration swipeEnter = Duration(milliseconds: 500);
  static const Duration swipeSettle = Duration(milliseconds: 600);
  
  // Interactive feedback
  static const Duration hoverResponse = Duration(milliseconds: 200);
  static const Duration tapResponse = Duration(milliseconds: 150);
  static const Duration springBack = Duration(milliseconds: 800);
  
  // Background transitions
  static const Duration backgroundGlow = Duration(milliseconds: 300);
  static const Duration indicatorUpdate = Duration(milliseconds: 400);
  
  // Micro-interactions
  static const Duration buttonHover = Duration(milliseconds: 200);
  static const Duration iconTransition = Duration(milliseconds: 250);
}

/// Enhanced card transformation utilities
class CardTransformUtils {
  
  /// Creates a 3D perspective transform for card depth
  static Matrix4 create3DTransform({
    required double offsetX,
    required double offsetY,
    required double rotation,
    required double scale,
    double perspective = 0.001,
  }) {
    return Matrix4.identity()
      ..setEntry(3, 2, perspective)
      ..translate(offsetX, offsetY)
      ..rotateZ(rotation)
      ..scale(scale);
  }
  
  /// Creates a smooth card stack transform
  static Matrix4 createStackTransform({
    required int index,
    required int activeIndex,
    required double stackOffset,
  }) {
    final distance = (index - activeIndex).abs();
    final isActive = index == activeIndex;
    
    if (isActive) return Matrix4.identity();
    
    final yOffset = distance * stackOffset;
    final scale = 1.0 - (distance * 0.05);
    
    return Matrix4.identity()
      ..translate(0.0, yOffset)
      ..scale(scale.clamp(0.8, 1.0));
  }
  
  /// Calculates shadow intensity based on card state
  static double calculateShadowIntensity({
    required double scale,
    required bool isDragging,
    required bool isAnimating,
  }) {
    double baseIntensity = 0.2;
    
    if (isDragging) {
      baseIntensity *= 1.5;
    }
    
    if (isAnimating) {
      baseIntensity *= 0.8;
    }
    
    // Scale affects shadow intensity
    final scaleMultiplier = (scale - 0.7) / 0.3; // Normalize from 0.7-1.0 to 0-1
    
    return (baseIntensity * scaleMultiplier).clamp(0.1, 0.4);
  }
}

/// Color utilities for dynamic theming
class CardColorUtils {
  
  /// Creates a dynamic gradient based on step colors
  static LinearGradient createDynamicGradient({
    required Color startColor,
    required Color endColor,
    required double intensity,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        startColor.withOpacity(intensity),
        endColor.withOpacity(intensity),
      ],
    );
  }
  
  /// Creates background glow colors
  static List<Color> createGlowColors({
    required Color primaryColor,
    required Color secondaryColor,
    required double maxOpacity,
  }) {
    return [
      primaryColor.withOpacity(maxOpacity),
      secondaryColor.withOpacity(maxOpacity * 0.5),
      Colors.transparent,
    ];
  }
  
  /// Creates glassmorphism overlay colors
  static List<Color> createGlassmorphismColors({
    double primaryOpacity = 0.1,
    double secondaryOpacity = 0.05,
  }) {
    return [
      Colors.white.withOpacity(primaryOpacity),
      Colors.white.withOpacity(secondaryOpacity),
    ];
  }
}
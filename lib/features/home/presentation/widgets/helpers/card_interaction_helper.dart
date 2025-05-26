// lib/features/home/presentation/widgets/helpers/card_interaction_helper.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class for managing card interactions and animations
class CardInteractionHelper {
  
  /// Calculates the 3D transform for a card based on its position
  static Matrix4 calculateCardTransform({
    required int index,
    required int activeIndex,
    required bool isInteracting,
    double interactionProgress = 0.0,
  }) {
    final distanceFromActive = (index - activeIndex).abs();
    final isActive = index == activeIndex;
    
    // Base scale calculation
    double scale = isActive ? 1.0 : math.max(0.85 - (distanceFromActive * 0.05), 0.7);
    
    // Rotation calculation for depth effect
    double rotation = 0.0;
    if (!isActive) {
      rotation = (index < activeIndex ? -0.02 : 0.02) * distanceFromActive;
    }
    
    // Apply interaction effects
    if (isInteracting && isActive) {
      scale *= (1.0 + interactionProgress * 0.05);
    }
    
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective
      ..rotateY(rotation)
      ..scale(scale);
  }
  
  /// Calculates the vertical offset for card stacking
  static double calculateVerticalOffset({
    required int index,
    required int activeIndex,
    required double floatingValue,
  }) {
    final distanceFromActive = (index - activeIndex).abs();
    final isActive = index == activeIndex;
    
    double baseOffset = isActive ? 0.0 : distanceFromActive * 12.0;
    
    // Add floating effect only to active card
    if (isActive) {
      baseOffset += math.sin(floatingValue * 2 * math.pi) * 8;
    }
    
    return baseOffset;
  }
  
  /// Calculates opacity for card visibility
  static double calculateOpacity({
    required int index,
    required int activeIndex,
  }) {
    final distanceFromActive = (index - activeIndex).abs();
    final isActive = index == activeIndex;
    
    return isActive ? 1.0 : math.max(0.7 - (distanceFromActive * 0.1), 0.3);
  }
  
  /// Generates haptic feedback for interactions
  static void generateHapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
  
  /// Calculates the swipe velocity for smooth animations
  static double calculateSwipeVelocity(DragEndDetails details) {
    return details.velocity.pixelsPerSecond.dx.abs();
  }
  
  /// Determines if a swipe gesture should trigger a page change
  static bool shouldChangePage({
    required double dragDistance,
    required double velocity,
    required double threshold,
  }) {
    return dragDistance.abs() > threshold || velocity > 500;
  }
  
  /// Calculates the next page index based on swipe direction
  static int calculateNextPage({
    required int currentPage,
    required double dragDistance,
    required int totalPages,
  }) {
    if (dragDistance > 0) {
      // Swiping right (previous page)
      return currentPage == 0 ? totalPages - 1 : currentPage - 1;
    } else {
      // Swiping left (next page)
      return (currentPage + 1) % totalPages;
    }
  }
  
  /// Creates a smooth bounce animation curve
  static Curve createBounceInCurve() {
    return Curves.elasticOut;
  }
  
  /// Creates a smooth slide animation curve
  static Curve createSmoothSlideCurve() {
    return Curves.easeInOutCubic;
  }
}

/// Enum for different types of haptic feedback
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// Custom page transition for smooth card animations
class CardPageTransition extends PageRouteBuilder {
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  CardPageTransition({
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOutCubic,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        )),
        child: child,
      );
    },
  );
}

/// Animation timing constants for consistent experience
class AnimationTimings {
  static const Duration veryFast = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);
  
  // Curve constants
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve snapCurve = Curves.easeOutBack;
}
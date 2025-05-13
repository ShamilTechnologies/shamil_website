import 'dart:math' as math; // Used for mathematical operations like min, max, and pi.
import 'dart:ui' as ui; // For ImageFilter if needed, not directly for smoke particles
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For Ticker
// import 'package:easy_localization/easy_localization.dart'; // Not used in this widget
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';

// Helper class for smoke particles
class SmokeParticle {
  Offset position;   // Current position of the particle on the canvas
  double radius;     // Current radius of the particle
  double opacity;    // Current opacity of the particle (0.0 to 1.0)
  Offset velocity;   // Movement vector (dx, dy) per second
  Duration lifetime; // How long this particle has existed
  final Duration maxLifetime; // Maximum duration a particle can exist before disappearing
  final double initialRadius; // Starting radius of the particle
  final double maxRadius;     // Maximum radius the particle can grow to

  SmokeParticle({
    required this.position,
    this.initialRadius = 3.0,     // Start a bit larger
    this.maxRadius = 25.0,        // Particles can grow significantly larger
    this.opacity = 0.8,           // Higher initial opacity for more visibility
    required this.velocity,
    this.maxLifetime = const Duration(milliseconds: 1800), // Particles last a bit longer
  })  : radius = initialRadius,
        lifetime = Duration.zero;

  // Updates the particle's state based on the time that has passed (timeDelta)
  void update(Duration timeDelta) {
    lifetime += timeDelta; // Increment lifetime
    // Update position based on velocity and time delta (converted to seconds)
    position += velocity * (timeDelta.inMilliseconds / 1000.0);

    // Calculate how far along the particle is in its lifespan (0.0 to 1.0)
    final double lifePercent = lifetime.inMilliseconds / maxLifetime.inMilliseconds;

    // Opacity fades from the initial opacity down to 0 over its lifetime
    opacity = math.max(0, (1.0 - lifePercent) * 0.8); // Using initial opacity for fade calculation

    // Radius grows from initialRadius to maxRadius over its lifetime
    // Using math.min to ensure it doesn't exceed maxRadius due to floating point issues
    radius = initialRadius + (maxRadius - initialRadius) * math.min(1.0, lifePercent);
  }

  // A particle is considered "dead" if its lifetime exceeds maxLifetime or its opacity is zero or less.
  bool get isDead => lifetime >= maxLifetime || opacity <= 0;
}


class RocketSeparatorSection extends StatefulWidget {
  final ScrollController scrollController;

  const RocketSeparatorSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<RocketSeparatorSection> createState() => _RocketSeparatorSectionState();
}

class _RocketSeparatorSectionState extends State<RocketSeparatorSection> with SingleTickerProviderStateMixin {
  double _rocketHorizontalPercent = 0.0;
  final GlobalKey _separatorKey = GlobalKey();

  List<SmokeParticle> _smokeParticles = [];
  Ticker? _ticker;
  double _previousRocketHorizontalPercent = 0.0;
  Duration? _lastElapsed; // To calculate deltaTime for particle updates

  // *** ROCKET SIZE CONTROL ***
  static const double rocketImageSize = 90.0; // Size of the rocket image

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);

    _ticker = createTicker((elapsed) { // 'elapsed' is total time ticker has been running
      if (mounted) {
        _updateSmokeParticles(elapsed);
      }
    });
    _ticker?.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onScroll(); // Initial scroll check to set rocket position
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _ticker?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || _separatorKey.currentContext == null) return;

    final RenderBox? separatorRenderBox = _separatorKey.currentContext!.findRenderObject() as RenderBox?;
    if (separatorRenderBox == null) return;

    final separatorOffset = separatorRenderBox.localToGlobal(Offset.zero);
    final separatorHeight = separatorRenderBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    // --- SCROLL ANIMATION SPEED CONTROL (Horizontal Movement) ---
    // These values determine the scroll range over which the rocket moves from left to right.
    // A larger difference between scrollEndPoint and scrollStartPoint makes the animation slower.
    final scrollStartPoint = separatorOffset.dy - (screenHeight * 1.5);
    final scrollEndPoint = separatorOffset.dy + separatorHeight + (screenHeight * 1.5);

    final currentScroll = widget.scrollController.offset;
    double progress = 0.0;

    if (currentScroll > scrollStartPoint && scrollEndPoint > scrollStartPoint) {
      progress = (currentScroll - scrollStartPoint) / (scrollEndPoint - scrollStartPoint);
    } else if (currentScroll <= scrollStartPoint) {
      progress = 0.0;
    } else if (currentScroll >= scrollEndPoint) {
      progress = 1.0;
    }

    final newRocketHorizontalPercent = math.min(1.0, math.max(0.0, progress));

    // Emit smoke only if the rocket has moved to the right.
    // The threshold (0.001) prevents too many emissions for tiny movements.
    // (newRocketHorizontalPercent > _previousRocketHorizontalPercent + 0.001) checks for rightward movement.
    if ((newRocketHorizontalPercent > _previousRocketHorizontalPercent + 0.001) && newRocketHorizontalPercent > 0.005) {
      _emitSmoke();
    }

    setState(() {
      _rocketHorizontalPercent = newRocketHorizontalPercent;
      _previousRocketHorizontalPercent = newRocketHorizontalPercent;
    });
  }

  // --- Smoke Emission Logic ---
  void _emitSmoke() {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate rocket's current visual center X within the padded travel area
    final double travelAreaWidth = screenWidth - (AppDimensions.paddingPageHorizontal * 2);
    final double maxRocketTravelDistance = travelAreaWidth - rocketImageSize;
    final double rocketCurrentLeftEdgeInTravelArea = (_rocketHorizontalPercent * maxRocketTravelDistance);
    final double rocketCenterXInTravelArea = rocketCurrentLeftEdgeInTravelArea + (rocketImageSize / 2);
    // Convert to global X for particle positioning
    final double globalRocketCenterX = AppDimensions.paddingPageHorizontal + rocketCenterXInTravelArea;

    // Calculate rocket's visual center Y relative to the top of the Stack (which is the separator strip)
    // Separator strip height is rocketImageSize / 2.
    // Rocket's 'bottom' is set by the Positioned widget. We need its center Y for smoke.
    // If bottom is rocketImageSize * 0.1, then bottom edge is 0.1 * H from stack bottom.
    // Center Y is (stack height) - (bottom offset) - (half rocket height)
    final double separatorStripHeight = rocketImageSize / 2;
    // This calculation of rocketCenterY is relative to the top of the Stack.
    // If rocket's bottom is at `rocketImageSize * 0.1` from the Stack's bottom,
    // then its top is at `separatorStripHeight - (rocketImageSize * 0.1) - rocketImageSize`.
    // Its center Y is `separatorStripHeight - (rocketImageSize * 0.1) - (rocketImageSize / 2)`.
    final double rocketCenterY = separatorStripHeight - (rocketImageSize * 0.1) - (rocketImageSize / 2);


    // Emitting from the visual left and vertical center of the rocket.
    const double emissionOffsetXMultiplier = -0.4; // Negative for left of rocket center
    final double emissionOffsetX = rocketImageSize * emissionOffsetXMultiplier;

    final random = math.Random();
    for (int i = 0; i < 3; i++) { // Emit a few particles for a denser look
      _smokeParticles.add(
        SmokeParticle(
          position: Offset(
            globalRocketCenterX + emissionOffsetX + (random.nextDouble() - 0.5) * 15, // Add horizontal spread
            rocketCenterY + (random.nextDouble() - 0.5) * 10, // Add vertical spread around center Y
          ),
          velocity: Offset(
            -(random.nextDouble() * 15 + 15), // Increased leftward drift
            -(random.nextDouble() * 20 + 15), // Increased upward drift
          ),
        ),
      );
    }
  }

  // --- Update Smoke Particles (called by Ticker) ---
  void _updateSmokeParticles(Duration elapsed) {
    if (!mounted) return;
    final Duration deltaTime = elapsed - (_lastElapsed ?? elapsed);
    _lastElapsed = elapsed;

    List<SmokeParticle> nextGenerationParticles = [];
    for (var p in _smokeParticles) {
      p.update(deltaTime);
      if (!p.isDead) {
        nextGenerationParticles.add(p);
      }
    }
    _smokeParticles = nextGenerationParticles;

    if (_smokeParticles.isNotEmpty || _previousRocketHorizontalPercent > 0) {
       setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final double travelAreaWidth = screenWidth - (AppDimensions.paddingPageHorizontal * 2);
    final double maxRocketTravelDistance = travelAreaWidth - rocketImageSize;
    final double rocketLeftPosition = AppDimensions.paddingPageHorizontal + (_rocketHorizontalPercent * maxRocketTravelDistance);

    final double separatorStripHeight = rocketImageSize / 2;

    return Container(
      key: _separatorKey,
      height: separatorStripHeight,
      width: double.infinity,
      color: theme.colorScheme.background,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: SmokePainter(
                particles: _smokeParticles,
              ),
            ),
          ),

          Positioned(
            left: rocketLeftPosition,
            // *** ROCKET VERTICAL POSITION CONTROL ***
            // This 'bottom' value positions the bottom edge of the rocket image
            // relative to the bottom edge of this Stack (the separator strip).
            // - A value of 0: Rocket's bottom edge sits exactly on the bottom of the separator strip.
            // - A positive value (e.g., rocketImageSize * 0.1): Moves the rocket UP.
            //   The bottom of the rocket will be 10% of its height ABOVE the bottom of the strip.
            // - A negative value (e.g., -rocketImageSize * 0.1): Moves the rocket DOWN.
            //   The bottom of the rocket will be 10% of its height BELOW the bottom of the strip (overlapping section below).
            // To make it "a little down" from the previous (0.25), let's try 0.1 or 0.05.
            bottom: rocketImageSize * 0.1, // Rocket's bottom is 10% of its height above the separator's bottom.

            child: Transform.rotate(
              angle: -math.pi *1.77, // Points right and very slightly up
              child: Image.asset(
                AppAssets.rocketImagePng,
                width: rocketImageSize,
                height: rocketImageSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.rocket_launch_outlined,
                    size: rocketImageSize,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  );
                },
              ).animate(
                 onPlay: (controller) => controller.repeat(reverse: true),
              ).shake(hz: 1.2, duration: 5000.ms, rotation: 0.02)
               .then(delay: 2500.ms)
               .moveY(end: -3, duration: 2500.ms, curve: Curves.easeInOutSine)
               .then(delay:2500.ms)
               .moveY(end: 3, duration: 2500.ms, curve: Curves.easeInOutSine),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Custom Painter for Smoke ---
class SmokePainter extends CustomPainter {
  final List<SmokeParticle> particles;

  SmokePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      paint.color = Colors.grey.shade300.withOpacity(particle.opacity * 0.5);
      canvas.drawCircle(particle.position, particle.radius, paint);

      paint.color = Colors.grey.shade400.withOpacity(particle.opacity * 0.7);
      canvas.drawCircle(particle.position, particle.radius * 0.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SmokePainter oldDelegate) {
    return true;
  }
}

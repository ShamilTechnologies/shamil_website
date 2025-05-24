// lib/features/home/presentation/widgets/enhanced_rocket_separator_section.dart
import 'dart:math' as math;
import 'dart:ui' as ui; // For ui.Gradient
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For Ticker
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';

// --- Enhanced SmokeParticle Class ---
// Defines the properties and behavior of each individual smoke particle.
class EnhancedSmokeParticle {
  // Initial configuration - set once when the particle is created.
  final Offset initialPosition;
  final double initialRadius;
  final double maxRadius;
  final Offset initialVelocity;
  final Duration maxLifetime;
  final double rotationSpeed;
  final Color baseColor;
  final bool useGradient;

  // Calculated final properties based on initial setup by the factory constructor.
  final math.Random random;
  final int puffCount;
  final List<Offset> puffOffsets;
  final List<double> puffRadiiMultipliers;
  final List<double> puffOpacities;

  // Mutable state - these change over the particle's lifetime for animation.
  Offset position;
  double radius;
  double opacity;
  Duration lifetime;
  Offset currentVelocity;
  double rotation;

  EnhancedSmokeParticle._internal({
    required this.initialPosition,
    required this.initialRadius,
    required this.maxRadius,
    required double initialOpacityParam,
    required this.initialVelocity,
    required this.maxLifetime,
    required this.rotationSpeed,
    required this.baseColor,
    required this.useGradient,
    required this.random,
    required this.puffCount,
    required this.puffOffsets,
    required this.puffRadiiMultipliers,
    required this.puffOpacities,
    required double initialRotation,
  })  : position = initialPosition,
        radius = initialRadius,
        opacity = initialOpacityParam,
        lifetime = Duration.zero,
        currentVelocity = initialVelocity,
        rotation = initialRotation;

  factory EnhancedSmokeParticle({
    required Offset position,
    double initialRadius = 4.0,
    double maxRadius = 35.0,
    double initialOpacity = 0.0,
    required Offset velocity,
    Duration maxLifetime = const Duration(milliseconds: 2500),
    double rotationSpeed = 0.0,
    Color baseColor = Colors.white,
    bool useGradient = true,
  }) {
    final randomInstance = math.Random();
    final puffCountValue = 3 + randomInstance.nextInt(3);

    final puffOffsetsValue = List.generate(
        puffCountValue,
        (index) => Offset(
            (randomInstance.nextDouble() - 0.5) * maxRadius * 0.3,
            (randomInstance.nextDouble() - 0.5) * maxRadius * 0.3));
    final puffRadiiMultipliersValue = List.generate(
        puffCountValue, (index) => 0.5 + randomInstance.nextDouble() * 0.5);
    final puffOpacitiesValue = List.generate(
        puffCountValue, (index) => 0.5 + randomInstance.nextDouble() * 0.3);
    final initialRotationValue = (randomInstance.nextDouble() - 0.5) * math.pi;

    return EnhancedSmokeParticle._internal(
      initialPosition: position,
      initialRadius: initialRadius,
      maxRadius: maxRadius,
      initialOpacityParam: initialOpacity,
      initialVelocity: velocity,
      maxLifetime: maxLifetime,
      rotationSpeed: rotationSpeed,
      baseColor: baseColor,
      useGradient: useGradient,
      random: randomInstance,
      puffCount: puffCountValue,
      puffOffsets: puffOffsetsValue,
      puffRadiiMultipliers: puffRadiiMultipliersValue,
      puffOpacities: puffOpacitiesValue,
      initialRotation: initialRotationValue,
    );
  }

  void update(Duration timeDelta) {
    lifetime += timeDelta;
    position += currentVelocity * (timeDelta.inMilliseconds / 1000.0);
    rotation += rotationSpeed * (timeDelta.inMilliseconds / 1000.0);
    final double lifePercent = lifetime.inMilliseconds / maxLifetime.inMilliseconds;

    if (lifePercent < 0.15) {
      opacity = math.min(1.0, lifePercent / 0.15) * 0.7;
    } else if (lifePercent < 0.7) {
      opacity = 0.7 - (lifePercent - 0.15) * 0.3;
    } else {
      double startOpacityForFadeOut = 0.7 - (0.55 * 0.3); // Opacity at 70% life
      opacity = math.max(0, startOpacityForFadeOut * (1.0 - (lifePercent - 0.7) / 0.3) );
    }
    radius = initialRadius + (maxRadius - initialRadius) * (1 - math.pow(1 - math.min(1.0, lifePercent), 2)).toDouble();
    currentVelocity = Offset(currentVelocity.dx * 0.97, currentVelocity.dy * 0.97 - 0.8);
  }

  bool get isDead => lifetime >= maxLifetime || opacity <= 0.005;
}

// CustomPainter to draw the smoke particles.
class EnhancedSmokePainter extends CustomPainter {
  final List<EnhancedSmokeParticle> particles;
  // Removed glowColor as the rocket itself doesn't have a separate glow anymore,
  // and collective smoke glow was also removed for simplicity.
  // final Color? glowColor; 

  EnhancedSmokePainter({required this.particles /*, this.glowColor*/});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gradientPaint = Paint();
    final Paint simplePaint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      if (particle.opacity <= 0) continue;
      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      if (particle.useGradient) {
        final shader = ui.Gradient.radial(
          Offset.zero, particle.radius,
          [
            particle.baseColor.withOpacity(particle.opacity * 0.75),
            particle.baseColor.withOpacity(particle.opacity * 0.45),
            particle.baseColor.withOpacity(particle.opacity * 0.1),
            Colors.transparent,
          ],
          [0.0, 0.3, 0.7, 1.0],
        );
        gradientPaint.shader = shader;
        gradientPaint.style = PaintingStyle.fill;
        gradientPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, particle.radius * 0.4);
        canvas.drawCircle(Offset.zero, particle.radius, gradientPaint);
      } else {
        simplePaint.color = particle.baseColor.withOpacity(particle.opacity);
        simplePaint.maskFilter = MaskFilter.blur(BlurStyle.normal, particle.radius * 0.3);
        canvas.drawCircle(Offset.zero, particle.radius, simplePaint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedSmokePainter oldDelegate) => true;
}

// The main widget for the rocket separator section.
class EnhancedRocketSeparatorSection extends StatefulWidget {
  final ScrollController scrollController;
  const EnhancedRocketSeparatorSection({super.key, required this.scrollController});
  @override
  State<EnhancedRocketSeparatorSection> createState() => _EnhancedRocketSeparatorSectionState();
}

class _EnhancedRocketSeparatorSectionState extends State<EnhancedRocketSeparatorSection> with SingleTickerProviderStateMixin {
  double _rocketHorizontalPercent = 0.0;
  final GlobalKey _separatorKey = GlobalKey();
  final List<EnhancedSmokeParticle> _smokeParticles = [];
  Ticker? _ticker;
  double _previousRocketHorizontalPercent = 0.0;
  Duration? _lastElapsed;

  // *** ROCKET SIZE CONTROL ***
  static const double rocketImageSize = 90.0; // Current size

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _ticker = createTicker((elapsed) {
      if (mounted) _updateSmokeParticles(elapsed);
    })..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
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
    final separatorHeight = separatorRenderBox.size.height; // Height of the separator strip
    final screenHeight = MediaQuery.of(context).size.height;

    // --- SCROLL ANIMATION SPEED CONTROL (Horizontal Movement) ---
    // To make the animation very slow, increase the difference between scrollEndPoint and scrollStartPoint.
    // This means the rocket animates over a larger scroll distance.
    // Example: Animate over approximately 5 times the screen height.
    final scrollStartPoint = separatorOffset.dy - (screenHeight * 2.5); // Start even earlier
    final scrollEndPoint = separatorOffset.dy + separatorHeight + (screenHeight * 2.5); // End even later

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

    if ((newRocketHorizontalPercent > _previousRocketHorizontalPercent + 0.001) && newRocketHorizontalPercent > 0.005) {
      final speedFactor = (newRocketHorizontalPercent - _previousRocketHorizontalPercent);
      final particleCount = math.min(5, 1 + (speedFactor * 30).toInt()); // Max 5 particles
      _emitSmoke(particleCount);
    } else if (_rocketHorizontalPercent > 0.01 && _smokeParticles.isEmpty && math.Random().nextDouble() < 0.02) { // Very low chance for idle smoke
      _emitSmoke(1);
    }
    setState(() {
      _rocketHorizontalPercent = newRocketHorizontalPercent;
      _previousRocketHorizontalPercent = newRocketHorizontalPercent;
    });
  }

  void _emitSmoke(int count) {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final random = math.Random();
    final theme = Theme.of(context);

    final double travelAreaWidth = screenWidth - (AppDimensions.paddingPageHorizontal * 2);
    final double maxRocketTravelDistance = travelAreaWidth - rocketImageSize;
    final double rocketCurrentLeftEdgeInTravelArea = (_rocketHorizontalPercent * maxRocketTravelDistance);
    final double rocketCenterXInTravelArea = rocketCurrentLeftEdgeInTravelArea + (rocketImageSize / 2);
    final double globalRocketCenterX = AppDimensions.paddingPageHorizontal + rocketCenterXInTravelArea;

    // --- ROCKET Y POSITION FOR SMOKE EMISSION ---
    // The rocket's 'bottom' is now -rocketImageSize * 0.2 from the bottom of the Stack (separator strip).
    // We need the rocket's visual center Y relative to the top of the Stack.
    final double separatorStripHeight = rocketImageSize * 0.25; // Height of the separator strip
    // If rocket's bottom is at `-rocketImageSize * 0.2` from Stack's bottom,
    // its top is at `separatorStripHeight - (-rocketImageSize * 0.2) - rocketImageSize`.
    // Its center Y is `separatorStripHeight - (-rocketImageSize * 0.2) - (rocketImageSize / 2)`.
    final double rocketCenterY = separatorStripHeight + (rocketImageSize * 0.2) - (rocketImageSize / 2);


    // --- EMISSION POINT: Upper-behind-left of the rocket ---
    final double emissionOffsetX = -rocketImageSize * 0.40; // Slightly less behind
    final double emissionOffsetY = -rocketImageSize * 0.20; // More distinctly above rocket's Y center

    final List<Color> smokeColors = [
      Colors.grey.shade100, Colors.grey.shade200,
      theme.colorScheme.onSurface.withOpacity(0.2),
    ];

    for (int i = 0; i < count; i++) {
      _smokeParticles.add(
        EnhancedSmokeParticle(
          position: Offset(
            globalRocketCenterX + emissionOffsetX + (random.nextDouble() - 0.5) * 20,
            rocketCenterY + emissionOffsetY + (random.nextDouble() - 0.5) * 15,
          ),
          velocity: Offset(
            -(random.nextDouble() * 10 + 15), // Slower backward thrust for slower rocket
            -(random.nextDouble() * 15 + 15), // Slower upward thrust
          ),
          initialRadius: 3.0 + random.nextDouble() * 4.0,
          maxRadius: 22.0 + random.nextDouble() * 18.0, // Slightly smaller max for realism
          rotationSpeed: (random.nextDouble() - 0.5) * 2.0,
          maxLifetime: Duration(milliseconds: 1600 + random.nextInt(1000)), // 1.6s to 2.6s
          baseColor: smokeColors[random.nextInt(smokeColors.length)],
          useGradient: random.nextDouble() > 0.15,
          initialOpacity: 0.0,
        ),
      );
    }
    if (_smokeParticles.length > 70) { // Reduced max particles
      _smokeParticles.removeRange(0, _smokeParticles.length - 70);
    }
  }

  void _updateSmokeParticles(Duration elapsed) {
    if (!mounted) return;
    final Duration deltaTime = elapsed - (_lastElapsed ?? elapsed);
    _lastElapsed = elapsed;
    _smokeParticles.removeWhere((p) {
      p.update(deltaTime);
      return p.isDead;
    });
    if (_smokeParticles.isNotEmpty) {
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
    
    // --- SEPARATOR STRIP HEIGHT CONTROL ---
    // Make the separator strip very thin, almost invisible, so the rocket truly floats between sections.
    // The rocket will be positioned relative to this.
    final double separatorStripHeight = rocketImageSize * 0.25; // Reduced further

    Widget rocketImageWithIdleAnimation = Image.asset(
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
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
       .moveY(end: -2.0, duration: 3000.ms, curve: Curves.easeInOutSine) // Even subtler bob
       .then(delay: 3000.ms)
       .moveY(end: 2.0, duration: 3000.ms, curve: Curves.easeInOutSine)
       .then(delay: 250.ms)
       .shake(hz: 0.7, duration: 6000.ms, rotation: 0.01); // Very subtle and slow shake

    return Container(
      key: _separatorKey,
      height: separatorStripHeight, // The visible height of the separator strip
      width: double.infinity,
      color: theme.colorScheme.surface, // Background of the separator strip
      child: Stack(
        clipBehavior: Clip.none, // Allow rocket and smoke to draw outside these bounds
        children: [
          // Smoke is painted first, so it's behind the rocket
          Positioned.fill(
            child: CustomPaint(
              painter: EnhancedSmokePainter(particles: _smokeParticles),
            ),
          ),
          // Rocket image, positioned and rotated
          Positioned(
            left: rocketLeftPosition,
            // *** ROCKET VERTICAL POSITION CONTROL ***
            // This 'bottom' value positions the bottom edge of the rocket image
            // relative to the bottom edge of this Stack (the separator strip).
            // A negative value makes it hang below the strip.
            // To make it appear "more up" from the absolute bottom of the page (between sections),
            // and considering the strip is now very short, we might want its center
            // to be roughly on the strip, or its bottom edge slightly below.
            bottom: -rocketImageSize * 0.2, // Rocket hangs slightly below the thin separator strip

            child: Transform.rotate(
              // *** ROCKET ROTATION CONTROL ***
              // Angle to make the rocket point to the right and slightly up.
              angle: -math.pi *1.77, // Approx -90 + 8 = -82 degrees
              child: rocketImageWithIdleAnimation,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Enhanced SmokePainter ---
// (SmokePainter class remains largely the same as the previous version, 
// focusing on drawing particles with gradients and rotation)
class SmokePainter extends CustomPainter {
  final List<EnhancedSmokeParticle> particles;

  SmokePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gradientPaint = Paint();

    for (final particle in particles) {
      if (particle.opacity <= 0) continue;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      if (particle.useGradient) {
        final shader = ui.Gradient.radial(
          Offset.zero,
          particle.radius,
          [ 
            Colors.white.withOpacity(particle.opacity * 0.8),       
            Colors.grey.shade300.withOpacity(particle.opacity * 0.5), 
            Colors.grey.shade400.withOpacity(particle.opacity * 0.2), 
            Colors.transparent,                                     
          ],
          [0.0, 0.25, 0.6, 1.0], 
        );
        gradientPaint.shader = shader;
        gradientPaint.style = PaintingStyle.fill;
        gradientPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, particle.radius * 0.5);
        canvas.drawCircle(Offset.zero, particle.radius, gradientPaint);
      } else { 
        final simplePaint = Paint()
            ..color = particle.baseColor.withOpacity(particle.opacity)
            ..style = PaintingStyle.fill
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.radius * 0.3);
        canvas.drawCircle(Offset.zero, particle.radius, simplePaint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedSmokePainter oldDelegate) => true;
}

// lib/features/provider/presentation/widgets/provider_cta_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // For Shamil colors

// Re-using Particle definitions from ProviderHeroSection for consistency
// If this becomes common, move ParticlePainter and FloatingParticle to a shared location.
class FloatingParticle {
  Offset position;
  double radius;
  Color color;
  double speed;
  double opacity;
  double angle; // Added for varied movement, consistent with Hero section

  FloatingParticle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}

class ParticlePainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final Animation<double> animation;
  final math.Random random = math.Random(); // Instance of random

  ParticlePainter({required this.particles, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    if (size.isEmpty) return; // Avoid painting if size is not yet determined

    for (var particle in particles) {
      // Update particle position: gentle drift
      double dx = math.cos(particle.angle) * particle.speed * 0.1;
      double dy = math.sin(particle.angle) * particle.speed * 0.1;

      // Ensure particle.position is updated correctly
      double newX = (particle.position.dx + dx);
      double newY = (particle.position.dy - dy);

      // Wrap around logic for particles
      if (newX < 0) {
        newX = size.width + newX; // Wrap from left to right
      } else if (newX > size.width) {
        newX = newX % size.width; // Wrap from right to left
      }

      if (newY < 0) {
        newY = size.height + newY; // Wrap from top to bottom
      } else if (newY > size.height) {
        newY = newY % size.height; // Wrap from bottom to top
      }
      particle.position = Offset(newX, newY);
      
      // Corrected: Use the calculated dynamicPulseOpacity for the particle's final opacity
      final double dynamicPulseOpacity = (0.4 + (math.sin(animation.value * math.pi * 2 + particle.angle) + 1) / 5);
      // *** ERROR FIX: Changed pulseValue to dynamicPulseOpacity ***
      paint.color = particle.color.withOpacity(particle.opacity * dynamicPulseOpacity); 
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}


class ProviderCtaSection extends StatefulWidget {
  final AnimationController floatingParticlesController;

  const ProviderCtaSection({
    super.key,
    required this.floatingParticlesController,
  });

  @override
  State<ProviderCtaSection> createState() => _ProviderCtaSectionState();
}

class _ProviderCtaSectionState extends State<ProviderCtaSection> with TickerProviderStateMixin {
  List<FloatingParticle> _particles = [];
  final int _numParticles = 20; // Fewer particles for CTA
  final math.Random _random = math.Random();
  late AnimationController _pulseController;


  @override
  void initState() {
    super.initState();
     _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure that MediaQuery.of(context).size is available and valid
        final mediaQueryData = MediaQuery.of(context);
        if (mediaQueryData.size.width > 0 && mediaQueryData.size.height > 0) {
            _initParticles(mediaQueryData.size);
        }
        // No need to call setState here if ParticlePainter repaints based on controller
        // and _particles list is not rebuilt frequently after this initial setup.
        // However, if _initParticles itself needs to trigger a rebuild of the CustomPaint
        // because the _particles list has changed, then setState is needed.
      }
    });
  }

  void _initParticles(Size size) {
   if (!mounted || size.isEmpty) return; // Check if size is valid
    _particles = List.generate(_numParticles, (index) {
      return FloatingParticle(
        position: Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height),
        radius: _random.nextDouble() * 1.2 + 0.3, // Even smaller
        color: _random.nextBool()
            ? AppColors.primary.withOpacity(0.15)
            : AppColors.primaryGold.withOpacity(0.15),
        speed: _random.nextDouble() * 0.2 + 0.05, // Very slow
        opacity: _random.nextDouble() * 0.3 + 0.05, // Very subtle
        angle: _random.nextDouble() * 2 * math.pi, // Add angle
      );
    });
    // This setState is important to ensure the CustomPaint widget rebuilds
    // with the newly initialized _particles list.
    if(mounted) {
      setState((){});
    }
  }

   @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);
    const shamilBlue = AppColors.primary;
    const shamilGold = AppColors.primaryGold;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.brightness == Brightness.dark
              ? [shamilBlue.withOpacity(0.9), shamilGold.withOpacity(0.75), shamilBlue.withOpacity(0.9)]
              : [shamilBlue, Color.lerp(shamilBlue, shamilGold, 0.6)!, shamilGold],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Conditionally build CustomPaint only if particles are initialized and size is available
          LayoutBuilder( // Use LayoutBuilder to get constraints for CustomPaint
            builder: (context, constraints) {
              // Check if constraints are valid and particles are initialized
              if (_particles.isNotEmpty && constraints.biggest.isFinite && constraints.biggest.width > 0 && constraints.biggest.height > 0) {
                 // Optional: Re-initialize particles if the size changes significantly,
                 // or if they were initialized with a zero size.
                bool shouldReinitialize = false;
                if (_particles.isNotEmpty) {
                    // A simple check: if the first particle's initial random position is now out of bounds,
                    // it might indicate the canvas size was 0 or very small during the first _initParticles call.
                    final firstParticle = _particles.first;
                    if (firstParticle.position.dx > constraints.maxWidth || firstParticle.position.dx < 0 ||
                        firstParticle.position.dy > constraints.maxHeight || firstParticle.position.dy < 0) {
                       // This condition might be too sensitive. A better check would be if the
                       // size used for the *last* _initParticles call is different from current constraints.
                       // For simplicity now, we'll rely on the initial initState call with MediaQuery.
                    }
                }


                return CustomPaint(
                  size: constraints.biggest, // Ensure CustomPaint uses available space
                  painter: ParticlePainter(particles: _particles, animation: widget.floatingParticlesController),
                  child: const SizedBox.expand(),
                );
              }
              // Return an empty SizedBox if particles are not ready or constraints are not valid
              return const SizedBox.expand(); 
            }
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ProviderStrings.ctaTitle.tr(),
                textAlign: TextAlign.center,
                style: Helpers.responsiveValue(
                  context,
                  mobile: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  desktop: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
              const SizedBox(height: AppDimensions.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                child: Text(
                  ProviderStrings.ctaSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: AppDimensions.spacingLarge * 1.5),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final pulseScale = 1.0 + (_pulseController.value * 0.03);
                  return Transform.scale(
                    scale: pulseScale,
                    child: CustomButton(
                      text: ProviderStrings.getStartedToday.tr(),
                      onPressed: () { /* TODO: Handle Get Started CTA */ },
                      backgroundColor: AppColors.white,
                      foregroundColor: shamilBlue,
                      elevation: 10,
                      icon: const Icon(Icons.rocket_launch_rounded, size: 22),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8,0.8)),
              const SizedBox(height: AppDimensions.spacingLarge * 1.5),
              Wrap(
                spacing: AppDimensions.paddingLarge,
                runSpacing: AppDimensions.paddingMedium,
                alignment: WrapAlignment.center,
                children: [
                  _buildTrustIndicator(theme, Icons.shield_outlined, ProviderStrings.uptimeIndicator.tr()),
                  _buildTrustIndicator(theme, Icons.support_agent_rounded, ProviderStrings.supportIndicator.tr()),
                  _buildTrustIndicator(theme, Icons.people_alt_outlined, ProviderStrings.trustedByIndicator.tr()),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicator(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(width: AppDimensions.spacingSmall),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}

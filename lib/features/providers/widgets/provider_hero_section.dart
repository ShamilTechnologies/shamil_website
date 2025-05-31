// lib/features/provider/presentation/widgets/provider_hero_section.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

// Particle Data and Painter (can be in a separate file if used elsewhere)
// For this hero section, we might simplify or use a different particle effect
// than the one in ProviderCtaSection if the design calls for it.
// For now, let's assume a subtle particle effect.
class HeroParticle {
  Offset position;
  double radius;
  Color color;
  double speed;
  double opacity;
  double angle;

  HeroParticle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}

class HeroParticlePainter extends CustomPainter {
  final List<HeroParticle> particles;
  final Animation<double> animation; // Expected to be a continuous animation value (e.g., from a repeating controller)
  final math.Random random = math.Random();

  HeroParticlePainter({required this.particles, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    if (size.isEmpty) return;

    for (var particle in particles) {
      // Update particle position: very slow, almost imperceptible drift
      double dx = math.cos(particle.angle + animation.value * 0.5) * particle.speed * 0.05;
      double dy = math.sin(particle.angle + animation.value * 0.5) * particle.speed * 0.05;

      particle.position = Offset(
        (particle.position.dx + dx + size.width) % size.width, // Ensure wrapping
        (particle.position.dy + dy + size.height) % size.height, // Ensure wrapping
      );

      // Subtle opacity pulse
      final double pulseOpacity = (0.5 + (math.sin(animation.value * math.pi + particle.angle * 2) + 1) / 4);
      paint.color = particle.color.withOpacity(particle.opacity * pulseOpacity);
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeroParticlePainter oldDelegate) => true;
}


class ProviderHeroSection extends StatefulWidget {
  final AnimationController floatingParticlesController; // This controller will drive the particle animation

  const ProviderHeroSection({
    super.key,
    required this.floatingParticlesController,
  });

  @override
  State<ProviderHeroSection> createState() => _ProviderHeroSectionState();
}

class _ProviderHeroSectionState extends State<ProviderHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _ringRotationController;
  late AnimationController _buttonPulseController;
  late AnimationController _gradientAnimationController; // For background gradient animation

  List<HeroParticle> _particles = [];
  final int _numParticles = 20; // Fewer, more subtle particles
  final math.Random _random = math.Random();

  // Define gradient animation
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;


  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Slightly faster shimmer for CTA
    )..repeat(reverse: true);

    _ringRotationController = AnimationController(
        vsync: this, 
        duration: const Duration(seconds: 45) // Slower, more majestic rotation
    )..repeat();

    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // Slightly faster pulse
    )..repeat(reverse: true);

    _gradientAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Duration for one cycle of gradient animation
    )..repeat(reverse: true);

    // Define alignment tweens for the gradient
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
      ]
    ).animate(_gradientAnimationController);

    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
        TweenSequenceItem(tween: AlignmentTween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      ]
    ).animate(_gradientAnimationController);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final mediaQueryData = MediaQuery.of(context);
        if (mediaQueryData.size.width > 0 && mediaQueryData.size.height > 0) {
             _initParticles(mediaQueryData.size);
        }
        setState(() {}); 
      }
    });
  }

  void _initParticles(Size size) {
    if (!mounted || size.isEmpty) return;
    _particles = List.generate(_numParticles, (index) {
      return HeroParticle(
        position: Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height),
        radius: _random.nextDouble() * 1.5 + 0.5, // Small and subtle
        color: Colors.white.withOpacity(0.5), // Subtle white particles
        speed: _random.nextDouble() * 0.2 + 0.05, // Very slow drift
        opacity: _random.nextDouble() * 0.2 + 0.1, // More transparent
        angle: _random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _ringRotationController.dispose();
    _buttonPulseController.dispose();
    _gradientAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = isMobile ? screenHeight * 0.90 : screenHeight; // Full height on desktop

    const shamilBlue = AppColors.primary;
    const shamilGold = AppColors.primaryGold;
    final Color midGradientColor = Color.lerp(shamilBlue, shamilGold, 0.55)!;

    return AnimatedBuilder(
      animation: _gradientAnimationController, // Listen to gradient animation
      builder: (context, child) {
        return Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                shamilBlue.withOpacity(0.9),
                midGradientColor.withOpacity(0.8),
                shamilGold.withOpacity(0.75),
              ],
              begin: _topAlignmentAnimation.value, // Animated alignment
              end: _bottomAlignmentAnimation.value, // Animated alignment
            ),
          ),
          child: child, // The Stack with content
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating Particles
          if (_particles.isNotEmpty)
            CustomPaint(
              painter: HeroParticlePainter(
                  particles: _particles,
                  animation: widget.floatingParticlesController), // Use the passed controller
              child: const SizedBox.expand(),
            ),

          // Decorative Rotating Rings - more subtle and layered
          for (int i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: _ringRotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _ringRotationController.value * 2 * math.pi * (i == 0 ? 0.2 : (i == 1 ? -0.15 : 0.1)),
                  child: Container(
                    width: (isMobile ? 280.0 : 550.0) + (i * (isMobile ? 100 : 200)),
                    height: (isMobile ? 280.0 : 550.0) + (i * (isMobile ? 100 : 200)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.02 + (0.03 * (2-i)/2)), // Very subtle
                        width: 0.5 + i * 0.5, 
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Central Visual Element (Briefcase Icon within rings) - Right side on desktop
          if (!isMobile)
            Positioned(
              right: Helpers.responsiveValue(context, mobile: 0.0, tablet: 50.0, desktop: 100.0),
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildVisualElement(theme, isMobile),
              ),
            ),

          // Main Content - Centered or Left-aligned
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Helpers.responsiveValue(context, mobile: AppDimensions.paddingMedium, desktop: AppDimensions.paddingExtraLarge + 20),
              vertical: AppDimensions.paddingLarge,
            ),
            child: Align(
              alignment: isMobile ? Alignment.center : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 400 : 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    // "For Service Providers" Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5)
                      ),
                      child: Text(
                        ProviderStrings.joinOurNetwork.tr(), // Assuming this is "For Service Providers"
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, duration: 400.ms),
                    
                    const SizedBox(height: AppDimensions.spacingMedium),

                    // Main Title with Shimmer
                    AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          final shimmerValue = _shimmerController.value;
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [
                                  Colors.white,
                                  shamilGold.withOpacity(0.9),
                                  Colors.white,
                                ],
                                stops: [ shimmerValue - 0.4, shimmerValue, shimmerValue + 0.4],
                                begin: const Alignment(-2.0, -1.0), 
                                end: const Alignment(2.0, 1.0),
                                tileMode: TileMode.clamp, // Clamp to avoid repeating within text
                              ).createShader(bounds);
                            },
                            child: Text(
                              ProviderStrings.heroTitle.tr(),
                              textAlign: isMobile ? TextAlign.center : TextAlign.left,
                              style: Helpers.responsiveValue(
                                context,
                                mobile: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                                desktop: theme.textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1),
                              ),
                            ),
                          );
                        }).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, duration: 500.ms),
                    
                    const SizedBox(height: AppDimensions.spacingLarge),

                    // Subtitle
                    Text(
                      ProviderStrings.heroSubtitle.tr(),
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: Helpers.responsiveValue(
                        context,
                        mobile: theme.textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.85), height: 1.6),
                        desktop: theme.textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.85), height: 1.6, fontSize: 20),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, duration: 500.ms),
                    
                    const SizedBox(height: AppDimensions.spacingExtraLarge + 10),

                    // Action Buttons
                    Wrap(
                      spacing: AppDimensions.paddingMedium,
                      runSpacing: AppDimensions.paddingMedium,
                      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                      children: [
                        _buildGlowingButton(
                          text: ProviderStrings.startFreeTrial.tr(),
                          onPressed: () { /* TODO: Implement Start Free Trial action */ },
                          icon: Icons.play_circle_fill_rounded,
                          isPrimary: true,
                          theme: theme,
                        ).animate(delay: 800.ms).fadeIn().scale(begin: const Offset(0.8,0.8)),
                        _buildGlowingButton(
                          text: ProviderStrings.contactSales.tr(),
                          onPressed: () { /* TODO: Implement Contact Sales action */ },
                          icon: Icons.headset_mic_rounded,
                          isPrimary: false,
                          theme: theme,
                        ).animate(delay: 1000.ms).fadeIn().scale(begin: const Offset(0.8,0.8)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Visual element for mobile (centered if no right-aligned element)
           if (isMobile)
            Positioned(
              bottom: heroHeight * 0.1, // Adjust as needed
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5, // Make it more of a background element on mobile
                child: _buildVisualElement(theme, isMobile, sizeFactor: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVisualElement(ThemeData theme, bool isMobile, {double sizeFactor = 1.0}) {
    final double baseSize = Helpers.responsiveValue(context, mobile: 120.0, tablet: 180.0, desktop: 220.0) * sizeFactor;
    return AnimatedBuilder(
      animation: _ringRotationController, // Can use a different controller or combine
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_ringRotationController.value * 2 * math.pi * 0.5) * (isMobile ? 5 : 10) ), // Gentle float
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer subtle ring
              Container(
                width: baseSize,
                height: baseSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scaleXY(end: 1.05, duration: 3000.ms, curve: Curves.easeInOutSine),
              // Inner main ring with icon
              Container(
                width: baseSize * 0.7,
                height: baseSize * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                   boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                ),
                child: Icon(
                  Icons.business_center, // Briefcase icon from image
                  color: Colors.white.withOpacity(0.7),
                  size: baseSize * 0.35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildGlowingButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    required bool isPrimary,
    required ThemeData theme,
  }) {
    const shamilGold = AppColors.primaryGold;
    final Color primaryButtonColor = shamilGold;
    final Color secondaryButtonBorderColor = Colors.white.withOpacity(0.7);
    final Color secondaryButtonTextColor = Colors.white;

    return AnimatedBuilder(
      animation: _buttonPulseController,
      builder: (context, child) {
        final pulseValue = _buttonPulseController.value;
        final double glowOpacity = isPrimary ? (0.3 + pulseValue * 0.25) : (0.2 + pulseValue * 0.15);
        final double glowBlurRadius = isPrimary ? (18 + pulseValue * 10) : (12 + pulseValue * 8);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
            boxShadow: [
              BoxShadow(
                color: (isPrimary ? primaryButtonColor : AppColors.primary).withOpacity(glowOpacity),
                blurRadius: glowBlurRadius,
                spreadRadius: 0, 
              ),
            ],
          ),
          child: CustomButton(
            text: text,
            onPressed: onPressed,
            icon: Icon(icon, size: 18), // Slightly smaller icon
            backgroundColor: isPrimary ? primaryButtonColor : Colors.black.withOpacity(0.25),
            foregroundColor: isPrimary ? AppColors.textOnGold : secondaryButtonTextColor,
            side: isPrimary ? null : BorderSide(color: secondaryButtonBorderColor, width: 1.5),
            elevation: 0, 
          ),
        );
      },
    );
  }
}

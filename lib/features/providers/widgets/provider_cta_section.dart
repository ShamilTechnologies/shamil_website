import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Ensure setup is correct
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart'; // Ensure ProviderStrings are defined
import 'package:shamil_web/core/widgets/custom_button.dart'; // Ensure this is working
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

class FloatingParticle {
  Offset position;
  double radius;
  Color color;
  double speed;
  double opacity;
  double angle;

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

  ParticlePainter({required this.particles, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    if (size.isEmpty || particles.isEmpty) return;

    for (var particle in particles) {
      double dx = math.cos(particle.angle) * particle.speed * 0.1;
      double dy = math.sin(particle.angle) * particle.speed * 0.1;
      double newX = particle.position.dx + dx;
      double newY = particle.position.dy - dy;

      if (newX < -particle.radius) newX = size.width + particle.radius;
      if (newX > size.width + particle.radius) newX = -particle.radius;
      if (newY < -particle.radius) newY = size.height + particle.radius;
      if (newY > size.height + particle.radius) newY = -particle.radius;
      particle.position = Offset(newX, newY);

      final double dynamicPulseOpacity = (0.5 + (math.sin(animation.value * 2 * math.pi + particle.angle * 2) + 1) / 4).clamp(0.1, 1.0);
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
  final int _numParticles = 25;
  final math.Random _random = math.Random();
  late AnimationController _pulseButtonController;
  Size? _lastKnownSize;

  @override
  void initState() {
    super.initState();
    print("[ProviderCtaSection] initState");
    _pulseButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  void _initParticles(Size size) {
    print("[ProviderCtaSection] _initParticles called with size: $size");
    if (!mounted || size.isEmpty || (_lastKnownSize == size && _particles.isNotEmpty)) {
      if(size.isEmpty) print("[ProviderCtaSection] _initParticles: Skipped due to empty size.");
      return;
    }
    _lastKnownSize = size;

    _particles = List.generate(_numParticles, (index) {
      return FloatingParticle(
        position: Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height),
        radius: _random.nextDouble() * 1.5 + 0.5,
        color: _random.nextBool()
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.primaryGold.withOpacity(0.2),
        speed: _random.nextDouble() * 0.25 + 0.05,
        opacity: _random.nextDouble() * 0.4 + 0.1,
        angle: _random.nextDouble() * 2 * math.pi,
      );
    });
    print("[ProviderCtaSection] Particles initialized: ${_particles.length}");
  }

  @override
  void dispose() {
    print("[ProviderCtaSection] dispose");
    _pulseButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const shamilBlue = AppColors.primary;
    const shamilGold = AppColors.primaryGold;
    print("[ProviderCtaSection] build called");

    return Container(
      key: const ValueKey("ProviderCtaSectionContainer"),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * 1.2,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.brightness == Brightness.dark
              ? [shamilBlue.withOpacity(0.85), shamilGold.withOpacity(0.7), shamilBlue.withOpacity(0.85)]
              : [shamilBlue, Color.lerp(shamilBlue, shamilGold, 0.55)!, shamilGold],
          begin: const FractionalOffset(0.0, 0.5),
          end: const FractionalOffset(1.0, 0.5),
          stops: const [0.0, 0.5, 1.0],
          transform: const GradientRotation(math.pi / 40),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.hasBoundedWidth && constraints.hasBoundedHeight && constraints.biggest.width > 0 && constraints.biggest.height > 0) {
                  if(_particles.isEmpty || _lastKnownSize != constraints.biggest) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) { // Check mounted again inside post frame callback
                           _initParticles(constraints.biggest);
                           // Potentially call setState if _initParticles doesn't trigger repaint via animation listener
                           // For now, relying on ParticlePainter's animation repaint
                           if (_particles.isNotEmpty) setState(() {});
                        }
                    });
                  }
                  if (_particles.isNotEmpty) {
                    return CustomPaint(
                      size: constraints.biggest,
                      painter: ParticlePainter(particles: _particles, animation: widget.floatingParticlesController),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ProviderStrings.ctaTitle.tr(),
                textAlign: TextAlign.center,
                style: Helpers.responsiveValue(
                  context,
                  mobile: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5) ?? TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                  desktop: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -1) ?? TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
              const SizedBox(height: AppDimensions.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                child: Text(
                  ProviderStrings.ctaSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6,
                      ) ?? TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9), height: 1.6),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: AppDimensions.spacingLarge * 1.8),
              AnimatedBuilder(
                animation: _pulseButtonController,
                builder: (context, child) {
                  final pulseScale = 1.0 + (_pulseButtonController.value * 0.035);
                  return Transform.scale(
                    scale: pulseScale,
                    child: child,
                  );
                },
                child: CustomButton(
                  text: ProviderStrings.getStartedToday.tr(),
                  onPressed: () { print("Get Started Today CTA Pressed"); /* TODO: Handle Get Started CTA */ },
                  backgroundColor: AppColors.white,
                  foregroundColor: shamilBlue,
                  elevation: 12,
                  icon: const Icon(Icons.rocket_launch_rounded, size: 24),
                  // REMOVED 'padding' parameter
                  // REMOVED 'textStyle' parameter
                ),
              ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.elasticOut),
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
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
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
        Icon(icon, color: Colors.white.withOpacity(0.85), size: 18),
        const SizedBox(width: AppDimensions.spacingSmall - 2),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.85)) ?? TextStyle(color: Colors.white.withOpacity(0.85)),
        ),
      ],
    );
  }
}
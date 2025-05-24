// lib/features/home/presentation/widgets/hero_section.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart';

/// Enhanced Hero Section with viral design elements
/// Features: Animated gradient backgrounds, floating particles, 
/// interactive elements, and premium visual effects
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  
  // Banner rotation system
  final List<String> _bannerImages = [
    AppAssets.heroBanner1,
    AppAssets.heroBanner2,
    AppAssets.heroBanner3,
  ];

  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  bool _hasImages = true;

  // Animation controllers for premium effects
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _textAnimationController;
  
  // Floating particles data
  final List<FloatingParticle> _particles = [];
  final int _particleCount = 20;

  @override
  void initState() {
    super.initState();
    _initializeImageSystem();
    _initializeAnimations();
    _initializeParticles();
  }

  /// Initialize banner image rotation system
  void _initializeImageSystem() {
    if (_bannerImages.isEmpty || _bannerImages.any((path) => path.isEmpty)) {
      _hasImages = false;
      if (kDebugMode) {
        print("ERROR: HeroSection banner images not properly configured");
      }
    } else {
      _startBannerTimer();
    }
  }

  /// Initialize all animation controllers
  void _initializeAnimations() {
    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Pulse animation for interactive elements
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Text animation controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start text animations
    _textAnimationController.forward();
  }

  /// Initialize floating particles for background effect
  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(FloatingParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * 0.5 + 0.2,
        opacity: random.nextDouble() * 0.3 + 0.1,
      ));
    }
  }

  void _startBannerTimer() {
    if (!_hasImages) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted && _bannerImages.isNotEmpty) {
        final newIndex = (_currentBannerIndex + 1) % _bannerImages.length;
        if (kDebugMode) {
          print("Updating banner: $_currentBannerIndex -> $newIndex");
        }
        setState(() {
          _currentBannerIndex = newIndex;
        });
      } else {
        timer.cancel();
        setState(() => _hasImages = false);
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _particleController.dispose();
    _pulseController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double heroHeight = screenHeight * 0.95;

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        children: [
          // Enhanced animated background
          _buildAnimatedBackground(theme),
          
          // Floating particles overlay
          _buildFloatingParticles(),
          
          // Main content with enhanced animations
          _buildMainContent(theme, isMobile, heroHeight),
          
          // Scroll indicator at bottom
          _buildScrollIndicator(theme),
        ],
      ),
    );
  }

  /// Build animated background with multiple layers
  Widget _buildAnimatedBackground(ThemeData theme) {
    final Color overlayColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.6);

    Widget backgroundWidget = !_hasImages
        ? Container(
            key: const ValueKey<String>('fallback_background'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.secondary.withOpacity(0.6),
                ],
              ),
            ),
          )
        : Container(
            key: ValueKey<int>(_currentBannerIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_bannerImages[_currentBannerIndex]),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(overlayColor, BlendMode.darken),
                onError: (exception, stackTrace) {
                  if (kDebugMode) {
                    print("ERROR loading banner: ${_bannerImages[_currentBannerIndex]}");
                  }
                },
              ),
            ),
          );

    return Positioned.fill(
      child: Stack(
        children: [
          // Main background
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 2000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.1, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
                  child: child,
                ),
              );
            },
            child: backgroundWidget,
          ),
          
          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build floating particles animation
  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlesPainter(
              particles: _particles,
              animationValue: _particleController.value,
            ),
          );
        },
      ),
    );
  }

  /// Build main content with enhanced animations
  Widget _buildMainContent(ThemeData theme, bool isMobile, double heroHeight) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: isMobile ? 40 : 60,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Enhanced title with gradient text
              _buildEnhancedTitle(theme, isMobile),
              
              SizedBox(height: isMobile ? 16 : 24),
              
              // Enhanced subtitle
              _buildEnhancedSubtitle(theme, isMobile),
              
              SizedBox(height: isMobile ? 32 : 48),
              
              // Enhanced action buttons
              _buildEnhancedActionButtons(theme, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  /// Build enhanced title with gradient and animation effects
  Widget _buildEnhancedTitle(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _textAnimationController.value)),
          child: Opacity(
            opacity: _textAnimationController.value,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: Text(
                AppStrings.heroTitle.tr(),
                style: Helpers.responsiveValue(
                  context,
                  mobile: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                  desktop: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    ).animate(delay: 300.ms).shimmer(duration: 2000.ms, color: Colors.white54);
  }

  /// Build enhanced subtitle with typing effect
  Widget _buildEnhancedSubtitle(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _textAnimationController.value)),
          child: Opacity(
            opacity: _textAnimationController.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                AppStrings.heroSubtitle.tr(),
                style: Helpers.responsiveValue(
                  context,
                  mobile: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                  desktop: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    ).animate(delay: 600.ms).fadeIn(duration: 800.ms);
  }

  /// Build enhanced action buttons with hover effects
  Widget _buildEnhancedActionButtons(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _textAnimationController.value)),
          child: Opacity(
            opacity: _textAnimationController.value,
            child: ResponsiveRowColumn(
              layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              rowSpacing: AppDimensions.spacingLarge,
              columnSpacing: AppDimensions.spacingLarge,
              children: [
                // Primary App Store Button with glow effect
                ResponsiveRowColumnItem(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.4),
                          blurRadius: 20 + (_pulseController.value * 10),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: "App Store",
                      onPressed: () => Helpers.launchUrlHelper(context, _appStoreUrl),
                      icon: const Icon(Icons.apple),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                // Secondary Google Play Button with different glow
                ResponsiveRowColumnItem(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 15 + (_pulseController.value * 8),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: "Google Play",
                      onPressed: () => Helpers.launchUrlHelper(context, _playStoreUrl),
                      icon: const Icon(Icons.shop),
                      isSecondary: true,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate(delay: 900.ms).slideY(begin: 0.3, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  /// Build scroll indicator at bottom
  Widget _buildScrollIndicator(ThemeData theme) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.6 + (_pulseController.value * 0.4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scroll to explore",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ).animate(delay: 1500.ms).fadeIn(duration: 1000.ms)
         .then(delay: 500.ms)
         .moveY(begin: 0, end: 10, duration: 2000.ms, curve: Curves.easeInOut)
         .then()
         .moveY(begin: 10, end: 0, duration: 2000.ms, curve: Curves.easeInOut),
      ),
    );
  }
}

/// Floating particle data class
class FloatingParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  FloatingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

/// Custom painter for floating particles
class ParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;

  ParticlesPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed * 0.01;
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = math.Random().nextDouble();
      }

      // Add horizontal drift
      particle.x += math.sin(animationValue * 2 * math.pi + particle.y * 10) * 0.001;

      // Keep particles within bounds
      if (particle.x < 0) particle.x = 1.0;
      if (particle.x > 1) particle.x = 0.0;

      // Draw particle
      paint.color = Colors.white.withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
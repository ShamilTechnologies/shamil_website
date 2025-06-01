// lib/features/home/presentation/widgets/hero_section.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart'; // Assuming this contains launchUrlHelper
import 'package:shamil_web/core/widgets/custom_button.dart'; // Ensure CustomButton is up-to-date
import 'package:responsive_framework/responsive_framework.dart';
// 🐛 FIX: Added foundation import for listEquals
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, listEquals; // Import kIsWeb and listEquals

// ✨ Enhanced Hero Section - More Viral & Engaging ✨
// This section aims to create a captivating first impression with dynamic visuals and smooth interactions.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  // 🖼️ Banner Image System
  final List<String> _bannerImages = [
    AppAssets.heroBanner1,
    AppAssets.heroBanner2,
    AppAssets.heroBanner3,
  ];
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  // 🛡️ Robustness: Tracks if banner images are validly configured
  bool _hasValidImages = true;

  // 🚀 Animation Controllers
  late AnimationController _particleController; // For background particles
  late AnimationController _pulseController; // For button pulsing effects
  late AnimationController _textEntryController; // For staggered text & button entry animations

  // ✨ Floating Particles Configuration
  final List<FloatingParticle> _particles = [];
  // 💡 Performance: Adjust particle count based on platform
  final int _particleCount = kIsWeb ? 35 : 20;
  Size _particleCanvasSize = Size.zero; // To store canvas size for particle initialization

  // 🔗 URLs for App Store & Play Store Buttons
  // TODO: 🎯 Replace with your actual app store URLs!
  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

  @override
  void initState() {
    super.initState();
    _validateAndInitializeImageSystem();
    _initializeAnimations();
    // Particles are initialized in `_buildFloatingParticles` via LayoutBuilder once canvas size is known.
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _particleController.dispose();
    _pulseController.dispose();
    _textEntryController.dispose();
    super.dispose();
  }

  /// 🛡️ Validates banner image paths and initializes the rotation system.
  void _validateAndInitializeImageSystem() {
    _hasValidImages = _bannerImages.isNotEmpty &&
        _bannerImages.every((path) => path.isNotEmpty && path.startsWith('assets/'));

    if (!_hasValidImages) {
      if (kDebugMode) {
        print(
            "🖼️ ERROR: HeroSection banner images are missing or incorrectly configured in AppAssets.dart. Falling back to gradient background.");
      }
    } else {
      _startBannerTimer();
    }
  }

  /// ⚙️ Initializes all animation controllers.
  void _initializeAnimations() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _textEntryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _textEntryController.forward();
      }
    });
  }

  /// ✨ Initializes floating particles once the canvas size is available.
  void _initializeParticles(Size size) {
    if (_particles.isNotEmpty || size.isEmpty || !mounted) return;

    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(FloatingParticle(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height,
        size: random.nextDouble() * 2.5 + 1.5,
        speed: random.nextDouble() * 0.3 + 0.1,
        initialOpacity: random.nextDouble() * 0.25 + 0.05,
        color: Colors.white.withOpacity(random.nextDouble() * 0.4 + 0.15),
      ));
    }
  }

  /// ⏱️ Starts or restarts the banner image rotation timer.
  void _startBannerTimer() {
    if (!_hasValidImages) return;

    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted && _bannerImages.isNotEmpty) {
        setState(() {
          _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double heroHeight = isMobile ? screenHeight * 0.88 : screenHeight * 0.92;

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        children: [
          _buildAnimatedBackground(theme),
          _buildFloatingParticles(),
          _buildMainContent(theme, isMobile),
          _buildScrollIndicator(theme, isMobile),
        ],
      ),
    );
  }

  /// 🎨 Builds the animated background (image slideshow or fallback gradient).
  Widget _buildAnimatedBackground(ThemeData theme) {
    final Color overlayColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.30)
        : Colors.black.withOpacity(0.50);

    Widget backgroundContent;

    if (_hasValidImages) {
      backgroundContent = AnimatedSwitcher(
        duration: const Duration(milliseconds: 1800),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.03, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(_currentBannerIndex),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_bannerImages[_currentBannerIndex]),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(overlayColor, BlendMode.darken),
              onError: (exception, stackTrace) {
                if (kDebugMode) {
                  print("🖼️ ERROR loading banner: ${_bannerImages[_currentBannerIndex]} - $exception");
                }
                if (mounted) {
                  // Check if it's already false to avoid unnecessary setState calls in a loop
                  if (_hasValidImages) {
                    setState(() => _hasValidImages = false);
                  }
                }
              },
            ),
          ),
        ),
      );
    } else {
      // Fallback gradient
      backgroundContent = Container(
        key: const ValueKey<String>('fallback_gradient_background'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.brightness == Brightness.light
                ? [
                    theme.colorScheme.primary.withOpacity(0.8),
                    theme.colorScheme.primary.withOpacity(0.6),
                    theme.colorScheme.secondary.withOpacity(0.4)
                  ]
                : [
                    const Color(0xFF0A121F),
                    const Color(0xFF101C2C),
                    theme.colorScheme.primary.withOpacity(0.25)
                  ],
          ),
        ),
      );
    }

    return Positioned.fill(
      child: Stack(
        children: [
          backgroundContent,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.03),
                  Colors.black.withOpacity(0.20),
                ],
                stops: const [0.0, 0.65, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✨ Builds the floating particles overlay.
  Widget _buildFloatingParticles() {
    return LayoutBuilder(builder: (context, constraints) {
      if (_particles.isEmpty && constraints.maxWidth > 0 && constraints.maxHeight > 0) {
        _particleCanvasSize = constraints.biggest;
        // Call _initializeParticles only if the size is determined and particles are not yet initialized.
        // This prevents multiple calls if LayoutBuilder rebuilds for other reasons.
        WidgetsBinding.instance.addPostFrameCallback((_) {
           if(mounted && _particles.isEmpty && _particleCanvasSize.width > 0 && _particleCanvasSize.height > 0) {
            _initializeParticles(_particleCanvasSize);
            // Potentially call setState if _initializeParticles itself doesn't trigger a repaint of AnimatedBuilder consumers
            // However, AnimatedBuilder should pick up changes if _particles list instance changes or controller ticks.
            // For safety, if _initializeParticles populates a list that is final and passed, a setState might be needed here.
            // But since _particles is a state variable and _particleController ticks, it should be fine.
           }
        });
      }
      if (_particles.isEmpty || _particleCanvasSize.isEmpty) return const SizedBox.shrink();

      return AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            size: _particleCanvasSize,
            painter: ParticlesPainter(
              particles: _particles,
              animationValue: _particleController.value,
              canvasSize: _particleCanvasSize,
            ),
          );
        },
      );
    });
  }

  /// 📝 Builds the main content (title, subtitle, buttons) with entry animations.
  Widget _buildMainContent(ThemeData theme, bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: isMobile ? AppDimensions.paddingLarge : AppDimensions.paddingExtraLarge,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildEnhancedTitle(theme, isMobile)
                  .animate(controller: _textEntryController)
                  .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),
              SizedBox(height: isMobile ? AppDimensions.spacingSmall : AppDimensions.spacingMedium),
              _buildEnhancedSubtitle(theme, isMobile)
                  .animate(controller: _textEntryController)
                  .fadeIn(delay: 150.ms, duration: 600.ms)
                  .slideY(begin: 0.3, delay: 150.ms, curve: Curves.easeOutCubic),
              SizedBox(height: isMobile ? AppDimensions.spacingMedium * 1.5 : AppDimensions.spacingLarge * 1.5),
              _buildEnhancedActionButtons(theme, isMobile)
                  .animate(controller: _textEntryController)
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.3, delay: 300.ms, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }

  /// ✨ Builds the enhanced title with gradient text and refined styling.
  Widget _buildEnhancedTitle(ThemeData theme, bool isMobile) {
    return Text(
      AppStrings.heroTitle.tr(),
      style: Helpers.responsiveValue(
        context,
        mobile: theme.textTheme.displaySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          height: 1.15,
          shadows: [
            Shadow(blurRadius: 8.0, color: Colors.black.withOpacity(0.3), offset: const Offset(2, 2)),
          ],
        ),
        desktop: theme.textTheme.displayMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
          height: 1.15,
          shadows: [
            Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.3), offset: const Offset(2, 3)),
          ],
        ),
      ),
      textAlign: TextAlign.center,
    )
        .animate()
        .then(delay: 800.ms) // Delay shimmer
        .shimmer(
          duration: 2500.ms,
          colors: [Colors.white, Colors.grey.shade400, Colors.white.withOpacity(0.7), Colors.grey.shade400, Colors.white],
          stops: const [0.2, 0.4, 0.5, 0.6, 0.8], // Finer control over shimmer gradient
          angle: 30 * (math.pi / 180),
          blendMode: BlendMode.srcIn, // srcIn usually looks better for text shimmer
        );
  }

  /// ✨ Builds the enhanced subtitle with a soft backdrop for readability.
  Widget _buildEnhancedSubtitle(ThemeData theme, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppDimensions.paddingSmall : AppDimensions.paddingMedium,
          vertical: isMobile ? AppDimensions.paddingExtraSmall * 1.5 : AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35), // Slightly more pronounced backdrop
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge * 1.2),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5), // Thinner, more subtle border
      ),
      child: Text(
        AppStrings.heroSubtitle.tr(),
        style: Helpers.responsiveValue(
          context,
          mobile: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.95), // Brighter text for better contrast
            height: 1.5, // Increased line height for readability
            fontWeight: FontWeight.w400,
          ),
          desktop: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white.withOpacity(0.95),
            height: 1.5,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// ✨ Builds enhanced action buttons using the updated `CustomButton`.
  Widget _buildEnhancedActionButtons(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulseEffect = _pulseController.value * 0.015;

        return ResponsiveRowColumn(
          layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: MainAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowSpacing: AppDimensions.spacingMedium,
          columnSpacing: AppDimensions.spacingSmall * 1.5,
          children: [
            ResponsiveRowColumnItem(
              child: Transform.scale(
                scale: 1.0 + pulseEffect,
                child: CustomButton(
                  text: "App Store", // TODO: Localize
                  onPressed: () => Helpers.launchUrlHelper(context, _appStoreUrl),
                  icon: const Icon(Icons.apple, size: 20),
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, Color.lerp(theme.colorScheme.primary, theme.colorScheme.secondary, 0.6)!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  foregroundColor: Colors.white,
                  hoverScale: 1.07,
                  shimmerEffect: true,
                  animationDuration: const Duration(milliseconds: 150),
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              child: Transform.scale(
                scale: 1.0 + pulseEffect,
                child: CustomButton(
                  text: "Google Play", // TODO: Localize
                  onPressed: () => Helpers.launchUrlHelper(context, _playStoreUrl),
                  icon: const Icon(Icons.shop_outlined, size: 18),
                  isSecondary: true,
                  backgroundColor: Colors.black.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.6), width: 1.2),
                  hoverScale: 1.07,
                  shimmerEffect: false,
                  animationDuration: const Duration(milliseconds: 150),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 👇 Builds the scroll-down indicator with a subtle animation.
  Widget _buildScrollIndicator(ThemeData theme, bool isMobile) {
    return Positioned(
      bottom: isMobile ? AppDimensions.paddingMedium : AppDimensions.paddingLarge,
      left: 0,
      right: 0,
      child: Center(
        child: IgnorePointer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Scroll to Discover More", // TODO: Localize
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSmall * 0.75),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingExtraSmall),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.65),
                  size: 16,
                ),
              ),
            ],
          )
          .animate(delay: 1800.ms)
          .fadeIn(duration: 1000.ms, curve: Curves.easeOut)
          .then(delay: 200.ms)
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .slideY(begin: 0, end: 6, duration: 2000.ms, curve: Curves.easeInOutSine),
        ),
      ),
    );
  }
}

/// 🧊 Floating Particle Data Class
class FloatingParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double initialOpacity;
  final Color color;

  FloatingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.initialOpacity,
    required this.color,
  });
}

/// ✨ Custom Painter for Floating Particles - Refined for Performance and Aesthetics
class ParticlesPainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final double animationValue;
  final Size canvasSize;

  ParticlesPainter({
    required this.particles,
    required this.animationValue,
    required this.canvasSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty || canvasSize.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random();

    for (final particle in particles) {
      particle.y -= particle.speed * 0.7;
      particle.x += math.sin(particle.y / 70 + particle.size * 5) * particle.speed * 0.15;

      if (particle.y < -particle.size) {
        particle.y = canvasSize.height + particle.size;
        particle.x = random.nextDouble() * canvasSize.width;
      }
      if (particle.x < -particle.size) particle.x = canvasSize.width + particle.size;
      if (particle.x > canvasSize.width + particle.size) particle.x = -particle.size;

      double fadeEffectOpacity = 1.0;
      double fadeInThreshold = canvasSize.height * 0.10;
      double fadeOutThreshold = canvasSize.height * 0.10;

      if (particle.y > canvasSize.height - fadeInThreshold) {
        fadeEffectOpacity = (canvasSize.height - particle.y) / fadeInThreshold;
      } else if (particle.y < fadeOutThreshold) {
        fadeEffectOpacity = particle.y / fadeOutThreshold;
      }
      
      final double globalPulse = 0.7 + (math.sin(animationValue * 2 * math.pi + particle.size) + 1) / 2 * 0.3;
      final double combinedOpacity = (particle.initialOpacity * fadeEffectOpacity * globalPulse).clamp(0.0, 1.0);

      paint.color = particle.color.withOpacity(combinedOpacity);
      
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    // 🐛 FIX: Corrected listEquals import and usage
    return oldDelegate.animationValue != animationValue ||
           !listEquals(oldDelegate.particles, particles) || 
           oldDelegate.canvasSize != canvasSize;
  }
}
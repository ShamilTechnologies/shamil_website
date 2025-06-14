// lib/features/home/presentation/widgets/shamil_ai_showcase_section.dart
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
// Assuming you have assets for mockups
import 'package:shamil_web/core/widgets/custom_button.dart';
// Assuming this exists and is styled

// Placeholder AppStrings - replace with your actual localization keys
class _AppStringsPlaceholder {
  static const String aiShowcaseTitle = 'aiShowcaseTitle';
  static const String aiShowcaseDescription = 'aiShowcaseDescription';
  static const String aiShowcaseCta = 'aiShowcaseCta';
  static const String aiShowcaseSubtitle = 'aiShowcaseSubtitle';
}

//region Shamil Brand Colors (defined locally for this section for clarity and to fix errors)
const Color _shamilBlue = Color(0xFF2A548D); // Main Shamil Blue
const Color _shamilGold = Color(0xFFD8A31A); // Main Shamil Gold
const Color _shamilDarkBlue = Color(0xFF1A3A5C); // Darker shade of Shamil Blue
const Color _shamilLightBlue = Color(0xFF6385C3); // Lighter, accent Shamil Blue

const Color _shamilDeepBlue = Color(0xFF0A192F); // A darker shade for background
const Color _shamilAccentBlue = Color(0xFF6385C3); // Re-alias for consistency if used
const Color _shamilGoldAccent = Color(0xFFD8A31A); // Re-alias for consistency if used
//endregion

class ShamilAiShowcaseSection extends StatefulWidget {
  const ShamilAiShowcaseSection({super.key});

  @override
  State<ShamilAiShowcaseSection> createState() =>
      _ShamilAiShowcaseSectionState();
}

class _ShamilAiShowcaseSectionState extends State<ShamilAiShowcaseSection>
    with TickerProviderStateMixin {

  // 🎮 Animation Controllers
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late AnimationController _entryController;

  // 🌟 AI Particles
  final List<AiParticle> _aiParticles = [];
  static const int _particleCount = 20;
  bool _particlesHaveBeenInitialized = false; // To ensure one-time initialization

  // 🎯 Interactive States
  bool _isHovering = false;
  double _mouseX = 0;
  double _mouseY = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Note: _generateAiParticles is now called within _buildAiParticleSystem's LayoutBuilder
  }

  void _initializeAnimations() {
    _floatController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  void _generateAiParticles(Size canvasSize, Brightness currentBrightness) {
    final random = math.Random();
    // Ensure particles are only generated once if _particlesHaveBeenInitialized is used effectively
    if (_aiParticles.isNotEmpty && _particlesHaveBeenInitialized) return; 
    
    _aiParticles.clear(); // Clear before generating if this can be called multiple times
                        // though the flag should prevent it.

    for (int i = 0; i < _particleCount; i++) {
      _aiParticles.add(AiParticle(
        id: i,
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.5 + 0.5,
        speed: random.nextDouble() * 0.3 + 0.05,
        color: currentBrightness == Brightness.dark
            ? (random.nextBool() ? _shamilGoldAccent.withOpacity(0.3) : _shamilAccentBlue.withOpacity(0.3))
            : (random.nextBool() ? _shamilGold.withOpacity(0.5) : _shamilBlue.withOpacity(0.5)),
      ));
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _gradientController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).between(MOBILE, TABLET);
    final Brightness currentBrightness = theme.brightness;

    double sectionHeight = isMobile ? 850 : (isTablet ? 750 : 700);
     if (ResponsiveBreakpoints.of(context).largerThan(DESKTOP)) {
        sectionHeight = 750;
    }

    return MouseRegion(
      onEnter: (_) { if (mounted) setState(() => _isHovering = true);},
      onExit: (_) { if (mounted) setState(() => _isHovering = false);},
      onHover: (event) {
        if (mounted) {
          setState(() {
          if (size.width > 0) _mouseX = event.localPosition.dx / size.width;
          if (size.height > 0) _mouseY = event.localPosition.dy / size.height;
        });
        }
      },
      child: Container(
        width: double.infinity,
        height: sectionHeight,
        decoration: const BoxDecoration(), 
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _buildAnimatedBackground(theme, currentBrightness),
            _buildAiParticleSystem(currentBrightness),
            _buildMainContent(theme, isMobile, isTablet, currentBrightness),
            _buildFloatingElements(theme, isMobile, currentBrightness),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme, Brightness currentBrightness) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + (_gradientController.value * 1.0),
                -1.0 + (_gradientController.value * 0.5),
              ),
              end: Alignment(
                1.0 - (_gradientController.value * 1.0),
                1.0 - (_gradientController.value * 0.5),
              ),
              colors: currentBrightness == Brightness.dark
                  ? [ 
                      _shamilDeepBlue.withOpacity(0.95),
                      _shamilBlue.withOpacity(0.6),
                      _shamilDarkBlue.withOpacity(0.8),
                      Colors.black.withOpacity(0.85),
                    ]
                  : [ 
                      AppColors.lightPageBackground, 
                      _shamilLightBlue.withOpacity(0.1),
                      _shamilBlue.withOpacity(0.15),
                      _shamilGold.withOpacity(0.03),
                    ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiParticleSystem(Brightness currentBrightness) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size currentLayoutSize = constraints.biggest;

        if (!_particlesHaveBeenInitialized && currentLayoutSize.width > 0 && currentLayoutSize.height > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _generateAiParticles(currentLayoutSize, currentBrightness);
              // Check if setState is still needed after _generateAiParticles if it doesn't modify state that forces a rebuild
              // Forcing a rebuild here if _particlesHaveBeenInitialized was the only guard
              if(!_particlesHaveBeenInitialized) { // Additional check to be absolutely sure
                 setState(() {
                    _particlesHaveBeenInitialized = true;
                 });
              }
            }
          });
          // Return an empty container or a placeholder while particles are being initialized in the post-frame callback
          return const SizedBox.shrink(); 
        }

        // If particles are not initialized yet (e.g., first frame before callback finishes) or list is empty, return empty.
        if (!_particlesHaveBeenInitialized || _aiParticles.isEmpty) {
          return const SizedBox.shrink();
        }

        // If particles are ready, build the AnimatedBuilder and CustomPaint.
        return AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              size: currentLayoutSize,
              painter: AiParticlePainter(
                particles: _aiParticles,
                progress: _particleController.value,
                mouseX: _mouseX,
                mouseY: _mouseY,
                isHovering: _isHovering,
                themeBrightness: currentBrightness,
              ),
            );
          },
        );
      }
    );
  }

  Widget _buildMainContent(ThemeData theme, bool isMobile, bool isTablet, Brightness currentBrightness) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingPageHorizontal,
            vertical: isMobile ? AppDimensions.paddingSmall : AppDimensions.paddingMedium,
          ),
          child: ResponsiveRowColumn(
            layout: isMobile
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowSpacing: isMobile ? AppDimensions.paddingMedium : AppDimensions.paddingLarge,
            columnSpacing: AppDimensions.paddingMedium,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: isMobile ? 1 : 4,
                columnOrder: 1,
                child: _buildTextContent(theme, isMobile, isTablet, currentBrightness),
              ),
              ResponsiveRowColumnItem(
                rowFlex: isMobile ? 1 : 5,
                columnOrder: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: isMobile ? AppDimensions.paddingMedium : 0),
                  child: _build3DDeviceShowcase(theme, isMobile, isTablet, currentBrightness),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(ThemeData theme, bool isMobile, bool isTablet, Brightness currentBrightness) {
    double titleScaleFactor = isMobile ? 0.75 : (isTablet ? 0.85 : 0.95);
    double descriptionScaleFactor = isMobile ? 0.8 : (isTablet ? 0.9 : 0.95);
    
    Color primaryTextColor = currentBrightness == Brightness.dark ? Colors.white : _shamilDeepBlue;
    Color secondaryTextColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.85) : _shamilDarkBlue.withOpacity(0.85);
    Color goldAccentTextColor = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.9) : _shamilGold.withOpacity(0.95);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildAiBadge(theme, currentBrightness)
            .animate(controller: _entryController) 
            .fadeIn(duration: 700.ms, delay: 100.ms)
            .slideX(begin: -0.25, curve: Curves.easeOutCubic, delay: 100.ms)
            .then(delay: 200.ms)
            .shimmer(duration: 1800.ms, color: _shamilGoldAccent.withOpacity(currentBrightness == Brightness.dark ? 0.6: 0.8)),
        const SizedBox(height: AppDimensions.spacingMedium),
        ShaderMask(
           shaderCallback: (bounds) => LinearGradient(
            colors: currentBrightness == Brightness.dark 
                ? [_shamilGoldAccent, _shamilAccentBlue, _shamilGoldAccent.withOpacity(0.7)]
                : [_shamilGold, _shamilBlue, _shamilGold.withOpacity(0.8)],
            stops: const [0.0, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Shamil: Your AI-Powered Service Companion".tr(gender: _AppStringsPlaceholder.aiShowcaseTitle),
            style: (isMobile
                    ? theme.textTheme.headlineLarge 
                    : theme.textTheme.displaySmall)
                ?.copyWith(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: (isMobile
                      ? theme.textTheme.headlineLarge?.fontSize
                      : theme.textTheme.displaySmall?.fontSize)! *
                  titleScaleFactor,
              height: 1.1,
              letterSpacing: -0.5,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ).animate(controller: _entryController)
            .fadeIn(delay: 200.ms, duration: 800.ms)
            .slideY(begin: 0.20, curve: Curves.easeOutCubic, delay: 200.ms),
        const SizedBox(height: AppDimensions.spacingSmall + 4),
        Text(
          "Harness the power of AI to find, book, and manage services like never before. Shamil learns your preferences to offer personalized recommendations and streamline your entire service experience."
              .tr(gender: _AppStringsPlaceholder.aiShowcaseDescription),
          style: theme.textTheme.titleMedium?.copyWith(
            color: secondaryTextColor,
            height: 1.55,
            fontWeight: FontWeight.w400,
            fontSize: theme.textTheme.titleMedium!.fontSize! * descriptionScaleFactor,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(controller: _entryController)
            .fadeIn(delay: 300.ms, duration: 800.ms)
            .slideY(begin: 0.20, curve: Curves.easeOutCubic, delay: 300.ms),
        const SizedBox(height: AppDimensions.spacingSmall),
         Text(
          "Available on all your devices.".tr(gender: _AppStringsPlaceholder.aiShowcaseSubtitle),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: goldAccentTextColor,
            fontWeight: FontWeight.w500,
            fontSize: theme.textTheme.bodyLarge!.fontSize! * descriptionScaleFactor,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(controller: _entryController)
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .slideX(begin: -0.20, curve: Curves.easeOutCubic, delay: 400.ms),
        const SizedBox(height: AppDimensions.spacingLarge),
        _buildFeaturePills(theme, isMobile, currentBrightness).animate(controller: _entryController)
          .fadeIn(delay:500.ms, duration: 700.ms),
        const SizedBox(height: AppDimensions.paddingLarge),
        _buildCtaButtons(theme, isMobile, currentBrightness),
      ],
    );
  }

  Widget _buildAiBadge(ThemeData theme, Brightness currentBrightness) {
    Color badgeTextColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.95) : _shamilDeepBlue;
    Color iconColor = currentBrightness == Brightness.dark ? _shamilGoldAccent : _shamilGold;
    List<Color> gradientPillColors = currentBrightness == Brightness.dark 
      ? [_shamilGoldAccent.withOpacity(0.1), _shamilAccentBlue.withOpacity(0.1)]
      : [_shamilGold.withOpacity(0.15), _shamilBlue.withOpacity(0.15)];
    Color borderColor = currentBrightness == Brightness.dark 
      ? _shamilGoldAccent.withOpacity(0.3) 
      : _shamilGold.withOpacity(0.4);
    Color shadowColor = currentBrightness == Brightness.dark 
      ? _shamilGoldAccent.withOpacity(0.2) 
      : _shamilGold.withOpacity(0.3);


    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulseExtra = _pulseController.value * 0.05;
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientPillColors[0].withOpacity(gradientPillColors[0].opacity + pulseExtra), gradientPillColors[1].withOpacity(gradientPillColors[1].opacity + pulseExtra)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
            border: Border.all(
              color: borderColor.withOpacity(borderColor.opacity + pulseExtra * 1.5),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(shadowColor.opacity + pulseExtra),
                blurRadius: 12 + (pulseExtra * 40), 
                spreadRadius: -3,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: iconColor,
                size: 14,
              ).animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 2800.ms, end: 1)
                  .then(delay: 400.ms)
                  .scaleXY(end: 1.05, duration: 1100.ms, curve: Curves.easeInOut)
                  .then()
                  .scaleXY(end: 1.0, duration: 1100.ms, curve: Curves.easeInOut),
              const SizedBox(width: 8),
              Text(
                "Powered by Advanced AI",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: badgeTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

 Widget _buildFeaturePills(ThemeData theme, bool isMobile, Brightness currentBrightness) {
    final features = [
      {"icon": Icons.insights_rounded, "text": "Smart Learning"},
      {"icon": Icons.online_prediction_rounded, "text": "Instant Predictions"},
      {"icon": Icons.verified_user_outlined, "text": "Secure & Private"},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return _FeaturePill(
          icon: feature["icon"] as IconData,
          text: feature["text"] as String,
          delay: Duration(milliseconds: 600 + (index * 100)),
          pulseController: _pulseController,
          currentBrightness: currentBrightness,
        );
      }).toList(),
    );
  }


  Widget _buildCtaButtons(ThemeData theme, bool isMobile, Brightness currentBrightness) {
    Color primaryButtonFgColor = currentBrightness == Brightness.dark ? _shamilDeepBlue : AppColors.primary;
    Color secondaryButtonFgColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.9) : _shamilDeepBlue.withOpacity(0.9);
    Color secondaryButtonBgColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.08) : _shamilBlue.withOpacity(0.08);
    Color secondaryButtonBorderColor = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.6) : _shamilGold.withOpacity(0.7);

    return Wrap(
      spacing: AppDimensions.paddingSmall,
      runSpacing: AppDimensions.paddingSmall,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        CustomButton(
          text: "Experience AI Magic".tr(gender: _AppStringsPlaceholder.aiShowcaseCta),
          icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
          onPressed: () { /* Navigate or action */ },
          gradient: LinearGradient(
            colors: currentBrightness == Brightness.dark
                ? [_shamilGoldAccent, _shamilGoldAccent.withOpacity(0.75)]
                : [_shamilGold, _shamilGold.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
          foregroundColor: primaryButtonFgColor,
          shimmerEffect: true,
          hoverScale: 1.03,
          animationDuration: const Duration(milliseconds: 150),
        ).animate(controller: _entryController)
            .fadeIn(delay: 600.ms, duration: 700.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutBack, delay: 600.ms),

        CustomButton(
          text: "Watch Demo".tr(),
          icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
          onPressed: () { /* Navigate or action */ },
          isSecondary: true,
          backgroundColor: secondaryButtonBgColor,
          foregroundColor: secondaryButtonFgColor,
          side: BorderSide(color: secondaryButtonBorderColor, width: 1.0),
          hoverScale: 1.03,
          animationDuration: const Duration(milliseconds: 150),
        ).animate(controller: _entryController)
            .fadeIn(delay: 700.ms, duration: 700.ms)
            .slideY(begin: 0.3, curve: Curves.easeOutBack, delay: 700.ms),
      ],
    );
  }

  Widget _build3DDeviceShowcase(ThemeData theme, bool isMobile, bool isTablet, Brightness currentBrightness) {
    double laptopScale = isMobile ? 0.60 : (isTablet ? 0.70 : 0.85);
    double phoneScale = isMobile ? 0.55 : (isTablet ? 0.65 : 0.75);
    Offset phoneOffset = isMobile
        ? const Offset(3, -12)
        : (isTablet ? const Offset(12, -22) : const Offset(25, -35));
    Offset tabletOffset = isMobile
        ? const Offset(-3, -8)
        : (isTablet ? const Offset(-12, -18) : const Offset(-25, -28));


    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _rotationController, _entryController]),
      builder: (context, child) {
        final floatY = math.sin(_floatController.value * 2 * math.pi) * (isMobile ? 3 : 6);
        final floatX = math.cos(_floatController.value * 2 * math.pi) * (isMobile ? 1.5 : 3);
        final mouseRotateY = _isHovering ? (_mouseX - 0.5) * 0.08 : 0;
        final mouseRotateX = _isHovering ? (_mouseY - 0.5) * -0.08 : 0;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(mouseRotateX + 0.015)
            ..rotateY(mouseRotateY - 0.025)
            ..translate(floatX, floatY),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _buildDeviceGlow(currentBrightness),
              Positioned(
                child: Transform.scale(
                  scale: laptopScale,
                  child: _Enhanced3DLaptop(
                    screenContent: _buildAiInterface(theme, currentBrightness),
                    isHovering: _isHovering,
                    currentBrightness: currentBrightness,
                  ),
                ),
              ).animate(controller: _entryController)
                  .fadeIn(delay: 400.ms, duration: 800.ms)
                  .slideX(begin: 0.20, curve: Curves.easeOutCubic, delay: 400.ms),
              Positioned(
                bottom: isMobile ? -15 : (isTablet ? -25 : -35),
                right: isMobile ? -8 : (isTablet ? -15: -25),
                child: Transform.translate(
                  offset: phoneOffset,
                  child: Transform.scale(
                    scale: phoneScale,
                    child: _Enhanced3DPhone(
                      screenContent: _buildMobileAiInterface(theme, currentBrightness),
                      isHovering: _isHovering,
                       currentBrightness: currentBrightness,
                    ),
                  ),
                ),
              ).animate(controller: _entryController)
                  .fadeIn(delay: 600.ms, duration: 800.ms)
                  .slideX(begin: 0.30, curve: Curves.easeOutCubic, delay: 600.ms)
                  .slideY(begin: 0.10, delay: 600.ms),
              Positioned(
                bottom: isMobile ? -12 : (isTablet ? -20: -30),
                left: isMobile ? -8 : (isTablet ? -15: -25),
                child: Transform.translate(
                  offset: tabletOffset,
                   child: Transform.scale(
                    scale: phoneScale * 0.92,
                    child: _Enhanced3DTablet(
                      screenContent: _buildTabletAiInterface(theme, currentBrightness),
                      isHovering: _isHovering,
                      currentBrightness: currentBrightness,
                    ),
                  ),
                )
              ).animate(controller: _entryController)
                  .fadeIn(delay: 700.ms, duration: 800.ms)
                  .slideX(begin: -0.30, curve: Curves.easeOutCubic, delay: 700.ms)
                  .slideY(begin: 0.08, delay: 700.ms),
            ],
          ),
        );
      },
    );
  }


  Widget _buildDeviceGlow(Brightness currentBrightness) {
    Color goldColor = currentBrightness == Brightness.dark ? _shamilGoldAccent : _shamilGold;
    Color blueColor = currentBrightness == Brightness.dark ? _shamilAccentBlue : _shamilLightBlue;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double baseRadius = 180;
        final double pulseAddition = _pulseController.value * 35;
        return Container(
          width: baseRadius + pulseAddition,
          height: baseRadius + pulseAddition,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                goldColor.withOpacity(0.06 + (_pulseController.value * 0.04)),
                blueColor.withOpacity(0.03 + (_pulseController.value * 0.02)),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements(ThemeData theme, bool isMobile, Brightness currentBrightness) {
    if (isMobile) return const SizedBox.shrink();
    
    Color goldColor = currentBrightness == Brightness.dark ? _shamilGoldAccent : _shamilGold;
    Color blueColor = currentBrightness == Brightness.dark ? _shamilAccentBlue : _shamilLightBlue;
    Color iconFgColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.9) : _shamilDeepBlue.withOpacity(0.9);


    final elements = [
      {'icon': Icons.insights_rounded, 'color': goldColor, 'delay': 0.0, 'h_align': -0.85, 'v_align': -0.65, 'size': 45.0},
      {'icon': Icons.auto_graph_rounded, 'color': blueColor, 'delay': 0.3, 'h_align': 0.75, 'v_align': -0.45, 'size': 55.0},
      {'icon': Icons.psychology_alt_rounded, 'color': goldColor, 'delay': 0.6, 'h_align': -0.75, 'v_align': 0.55, 'size': 50.0},
      {'icon': Icons.hub_outlined, 'color': blueColor, 'delay': 0.8, 'h_align': 0.65, 'v_align': 0.65, 'size': 40.0},
    ];

    return Stack(
      children: elements.map((el) {
        return Align(
          alignment: Alignment(el['h_align'] as double, el['v_align'] as double),
          child: _FloatingAiElement(
            icon: el['icon'] as IconData,
            color: el['color'] as Color,
            iconForegroundColor: iconFgColor,
            controller: _floatController,
            delay: el['delay'] as double,
            size: el['size'] as double,
            entryController: _entryController, 
            entryDelay: Duration(milliseconds: 900 + ((el['delay'] as double) * 400).toInt()),
            currentBrightness: currentBrightness,
          ),
        );
      }).toList(),
    );
  }


  Widget _buildAiInterface(ThemeData theme, Brightness currentBrightness) {
    Color bgColor1 = currentBrightness == Brightness.dark ? _shamilDarkBlue.withOpacity(0.7) : _shamilBlue.withOpacity(0.1);
    Color bgColor2 = currentBrightness == Brightness.dark ? _shamilBlue.withOpacity(0.6) : _shamilLightBlue.withOpacity(0.1);
    Color patternColor = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.03) : _shamilGold.withOpacity(0.05);
    Color iconColor = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.8) : _shamilGold;
    Color textColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.75) : _shamilDarkBlue.withOpacity(0.8);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [bgColor1, bgColor2],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: AiInterfacePatternPainter(color: patternColor),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart_rounded, color: iconColor, size: 36)
                    .animate(onPlay: (c)=>c.repeat(reverse:true)).scaleXY(end:1.05, duration: 1600.ms, curve: Curves.easeInOut),
                const SizedBox(height: 6),
                Text("AI Analytics", style: TextStyle(color: textColor, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAiInterface(ThemeData theme, Brightness currentBrightness) {
     Color bgColor1 = currentBrightness == Brightness.dark ? _shamilAccentBlue.withOpacity(0.7) : _shamilLightBlue.withOpacity(0.2);
     Color bgColor2 = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.5) : _shamilGold.withOpacity(0.2);
     Color iconColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.9) : _shamilDeepBlue;


     return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor1, bgColor2],
        ),
      ),
      child: Center(
        child: Icon(Icons.chat_bubble_outline_rounded, color: iconColor, size: 30),
      ),
    );
  }

   Widget _buildTabletAiInterface(ThemeData theme, Brightness currentBrightness) {
    Color bgColor1 = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.6) : _shamilGold.withOpacity(0.25);
    Color bgColor2 = currentBrightness == Brightness.dark ? _shamilAccentBlue.withOpacity(0.4) : _shamilLightBlue.withOpacity(0.15);
    Color iconColor = currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.85) : _shamilDeepBlue;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [bgColor1, bgColor2],
        ),
      ),
      child: Center(
        child: Icon(Icons.insights_rounded, color: iconColor, size: 36),
      ),
    );
  }
}

// Data class for AI Particle
class AiParticle {
  final int id;
  double x;
  double y;
  final double size;
  final double speed;
  final Color color;

  AiParticle({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

// Custom Painter for AI Particles
class AiParticlePainter extends CustomPainter {
  final List<AiParticle> particles;
  final double progress;
  final double mouseX;
  final double mouseY;
  final bool isHovering;
  final Brightness themeBrightness;

  AiParticlePainter({
    required this.particles,
    required this.progress,
    required this.mouseX,
    required this.mouseY,
    required this.isHovering,
    required this.themeBrightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    if (size.isEmpty) return;

    for (final particle in particles) {
      particle.y -= particle.speed * 0.004; 
      if (particle.y < 0) {
        particle.y = 1.0;
        particle.x = math.Random().nextDouble();
      }

      double waveX = math.sin(particle.y * 12 + particle.id + progress * math.pi * 1.5) * 0.008;
      double currentX = particle.x + waveX;

      double effectiveMouseX = mouseX;
      double effectiveMouseY = mouseY;

      if (isHovering && size.width > 0 && size.height > 0) {
          final dx = currentX - effectiveMouseX;
          final dy = particle.y - effectiveMouseY;
          final distance = math.sqrt(dx * dx + dy * dy);
          const interactionRadius = 0.12; 

          if (distance < interactionRadius) {
              final repulsionFactor = (interactionRadius - distance) / interactionRadius;
              currentX += dx * repulsionFactor * 0.03; 
              particle.y += dy * repulsionFactor * 0.03;
          }
      }
      
      currentX = currentX.clamp(0.0, 1.0);
      particle.y = particle.y.clamp(0.0, 1.0);

      final center = Offset(currentX * size.width, particle.y * size.height);
      final double themeBasedOpacityFactor = themeBrightness == Brightness.dark ? 0.6 : 0.9; 
      final baseOpacity = (0.15 + (particle.id % 3) * 0.04) * themeBasedOpacityFactor; 

      final pulse = math.sin(progress * math.pi * 2 + particle.id) * 0.5 + 0.5;
      final glowRadius = particle.size * (1.8 + pulse * 0.8); 
      final glowOpacity = baseOpacity * (0.15 + pulse * 0.25); 

      paint.shader = RadialGradient(
        colors: [
          particle.color.withOpacity(glowOpacity * 0.35), 
          particle.color.withOpacity(glowOpacity * 0.12),
          particle.color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0]
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
      canvas.drawCircle(center, glowRadius, paint);

      paint.shader = null;
      paint.color = particle.color.withOpacity(baseOpacity * (0.4 + pulse * 0.25)); 
      canvas.drawCircle(center, particle.size * (0.6 + pulse * 0.12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant AiParticlePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.mouseX != mouseX ||
      oldDelegate.mouseY != mouseY ||
      oldDelegate.isHovering != isHovering ||
      oldDelegate.themeBrightness != themeBrightness;
}


// Custom Painter for AI Interface Pattern
class AiInterfacePatternPainter extends CustomPainter {
  final Color color;
  AiInterfacePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4) 
      ..strokeWidth = 0.25 
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = color.withOpacity(0.5)..style = PaintingStyle.fill;

    final random = math.Random(DateTime.now().millisecond);
    int linesToDraw = (size.width * size.height / 9000).clamp(3, 12).toInt();

    for (int i = 0; i < linesToDraw; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final angle = random.nextDouble() * 2 * math.pi;
      final length = random.nextDouble() * (size.width * 0.07) + 4;
      final endX = (startX + math.cos(angle) * length).clamp(0.0, size.width);
      final endY = (startY + math.sin(angle) * length).clamp(0.0, size.height);

      paint.maskFilter = ui.MaskFilter.blur(BlurStyle.normal, 0.4);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      
      if (random.nextDouble() > 0.5) { 
         fillPaint.maskFilter = ui.MaskFilter.blur(BlurStyle.normal, 0.2);
         canvas.drawCircle(Offset(startX, startY), 0.7, fillPaint); 
         if (random.nextDouble() > 0.7) {
           canvas.drawCircle(Offset(endX, endY), 0.7, fillPaint);
         }
      }
    }
  }
  @override
  bool shouldRepaint(covariant AiInterfacePatternPainter oldDelegate) => false;
}


// Widget for Feature Pills
class _FeaturePill extends StatefulWidget {
  final IconData icon;
  final String text;
  final Duration delay;
  final AnimationController pulseController;
  final Brightness currentBrightness;


  const _FeaturePill({
    required this.icon,
    required this.text,
    required this.delay,
    required this.pulseController,
    required this.currentBrightness,
  });

  @override
  State<_FeaturePill> createState() => _FeaturePillState();
}

class _FeaturePillState extends State<_FeaturePill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color pillTextColor = widget.currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.85) : _shamilDeepBlue.withOpacity(0.9);
    Color pillIconColor = widget.currentBrightness == Brightness.dark ? _shamilGoldAccent : _shamilGold;
    Color pillHoverTextColor = widget.currentBrightness == Brightness.dark ? Colors.white : _shamilDeepBlue;
    Color pillHoverIconColor = widget.currentBrightness == Brightness.dark ? _shamilGoldAccent : _shamilGold;

    List<Color> pillGradientColors = _isHovered 
      ? (widget.currentBrightness == Brightness.dark 
          ? [_shamilGoldAccent.withOpacity(0.2), _shamilAccentBlue.withOpacity(0.2)]
          : [_shamilGold.withOpacity(0.25), _shamilBlue.withOpacity(0.25)])
      : (widget.currentBrightness == Brightness.dark
          ? [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.03)]
          : [_shamilBlue.withOpacity(0.05), _shamilLightBlue.withOpacity(0.03)]);
    
    Color pillBorderColor = _isHovered 
      ? (widget.currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.6) : _shamilGold.withOpacity(0.7))
      : (widget.currentBrightness == Brightness.dark ? Colors.white.withOpacity(0.1) : _shamilBlue.withOpacity(0.2));
    
    Color pillShadowColor = _isHovered 
      ? (widget.currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.2) : _shamilGold.withOpacity(0.25))
      : (widget.currentBrightness == Brightness.dark ? Colors.black.withOpacity(0.08) : _shamilBlue.withOpacity(0.1));


    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isHovered ? 1.025 : 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: pillGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
            border: Border.all(color: pillBorderColor, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: pillShadowColor,
                blurRadius: _isHovered ? 10 : 4,
                offset: _isHovered ? const Offset(0,2) : const Offset(0,1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? pillHoverIconColor : pillIconColor,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                widget.text,
                style: TextStyle(
                  color: _isHovered ? pillHoverTextColor : pillTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: widget.delay)
      .fadeIn(duration: 500.ms)
      .slideX(begin: (widget.text.hashCode % 2 == 0) ? -0.1 : 0.1, curve: Curves.easeOut);
  }
}

// Enhanced 3D Laptop Widget
class _Enhanced3DLaptop extends StatelessWidget {
  final Widget screenContent;
  final bool isHovering;
  final Brightness currentBrightness;


  const _Enhanced3DLaptop({required this.screenContent, required this.isHovering, required this.currentBrightness});

  @override
  Widget build(BuildContext context) {
    Color frameTopColor = currentBrightness == Brightness.dark ? const Color(0xFF16181C) : Colors.grey.shade300;
    Color frameBottomColor = currentBrightness == Brightness.dark ? const Color(0xFF222529) : Colors.grey.shade400;
    Color baseShadowColor = currentBrightness == Brightness.dark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.2);
    Color accentGlowColor = currentBrightness == Brightness.dark ? _shamilAccentBlue.withOpacity(0.08) : _shamilLightBlue.withOpacity(0.1);


    return AnimatedContainer(
      duration: const Duration(milliseconds: 250), 
      width: 400,
      height: 260,
      transform: Matrix4.identity()
        ..setEntry(3,2,0.0007) 
        ..rotateX(isHovering ? -0.035 : -0.05) 
        ..rotateY(isHovering ? 0.020 : 0.003),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: frameTopColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: baseShadowColor, blurRadius: 18, offset: const Offset(0,10)), 
          BoxShadow(color: accentGlowColor, blurRadius: 22, spreadRadius: -8), 
        ]
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: const EdgeInsets.all(7), 
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3), 
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.5), 
                child: screenContent
              ),
            )
          ),
          Container(
            height: 20, 
            decoration: BoxDecoration(
              color: frameBottomColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [frameTopColor.withOpacity(0.8), frameBottomColor], 
                stops: [0.0, 0.5] 
              )
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced 3D Phone Widget
class _Enhanced3DPhone extends StatelessWidget {
  final Widget screenContent;
  final bool isHovering;
  final Brightness currentBrightness;

  const _Enhanced3DPhone({required this.screenContent, required this.isHovering, required this.currentBrightness});

  @override
  Widget build(BuildContext context) {
    Color phoneBodyColor = currentBrightness == Brightness.dark ? const Color(0xFF0F0F0F) : Colors.grey.shade100;
    Color phoneBorderColor = currentBrightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade300;
    Color shadowColor = currentBrightness == Brightness.dark ? Colors.black.withOpacity(0.30) : Colors.black.withOpacity(0.15);
    Color accentGlow = currentBrightness == Brightness.dark ? _shamilGoldAccent.withOpacity(0.06) : _shamilGold.withOpacity(0.08);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 160, 
      height: 320, 
      transform: Matrix4.identity()
        ..setEntry(3,2,0.0008)
        ..rotateY(isHovering ? -0.10 : -0.03) 
        ..rotateZ(isHovering ? 0.025 : 0.05),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: phoneBodyColor,
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: phoneBorderColor, width: 2.0), 
         boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 16, offset: const Offset(5,8)),
          BoxShadow(color: accentGlow, blurRadius: 20, spreadRadius: -9), 
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22), 
        child: Stack(
          children: [
            Positioned.fill(child: screenContent),
            Positioned(
              top: 10, left: 40, right: 40, 
              child: Container(height: 16, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}

// Enhanced 3D Tablet Widget
class _Enhanced3DTablet extends StatelessWidget {
  final Widget screenContent;
  final bool isHovering;
  final Brightness currentBrightness;


  const _Enhanced3DTablet({required this.screenContent, required this.isHovering, required this.currentBrightness});

  @override
  Widget build(BuildContext context) {
    Color tabletBodyColor = currentBrightness == Brightness.dark ? const Color(0xFF1A1A1A) : Colors.grey.shade200;
    Color tabletBorderColor = currentBrightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade400;
    Color shadowColor = currentBrightness == Brightness.dark ? Colors.black.withOpacity(0.28) : Colors.black.withOpacity(0.12);
    Color accentGlow = currentBrightness == Brightness.dark ? _shamilAccentBlue.withOpacity(0.05) : _shamilLightBlue.withOpacity(0.07);


    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 250, 
      height: 185, 
      transform: Matrix4.identity()
        ..setEntry(3,2,0.0008)
        ..rotateY(isHovering ? 0.10 : 0.03) 
        ..rotateZ(isHovering ? -0.025 : -0.05),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: tabletBodyColor,
        borderRadius: BorderRadius.circular(14), 
        border: Border.all(color: tabletBorderColor, width: 3.5), 
         boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 18, offset: const Offset(-5,7)),
          BoxShadow(color: accentGlow, blurRadius: 22, spreadRadius: -11),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), 
        child: screenContent,
      ),
    );
  }
}


// Floating AI Element Widget
class _FloatingAiElement extends StatelessWidget {
  final IconData icon;
  final Color color; 
  final Color iconForegroundColor; 
  final AnimationController controller;
  final double delay;
  final double size;
  final AnimationController entryController;
  final Duration entryDelay;
  final Brightness currentBrightness;


  const _FloatingAiElement({
    required this.icon,
    required this.color,
    required this.iconForegroundColor,
    required this.controller,
    required this.delay,
    this.size = 50.0,
    required this.entryController,
    required this.entryDelay,
    required this.currentBrightness,
  });

  @override
  Widget build(BuildContext context) {
    double gradientOpacity1 = currentBrightness == Brightness.dark ? 0.35 : 0.20;
    double gradientOpacity2 = currentBrightness == Brightness.dark ? 0.15 : 0.08;
    double shadowOpacity = currentBrightness == Brightness.dark ? 0.30 : 0.15;


    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final individualProgress = (controller.value + delay) % 1.0;
        final yOffset = math.sin(individualProgress * 2 * math.pi) * 10;
        final scaleEffect = 0.97 + (math.sin(individualProgress * 2 * math.pi + math.pi / 2) * 0.03);

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Transform.scale(
            scale: scaleEffect,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(gradientOpacity1), 
                    color.withOpacity(gradientOpacity2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0], 
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(shadowOpacity), 
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconForegroundColor, 
                  size: size * 0.40,
                ),
              ),
            ),
          ),
        );
      },
    )
    .animate(controller: entryController, delay: entryDelay)
    .fadeIn(duration: 700.ms) 
    .scale(begin: const Offset(0.4, 0.4), curve: Curves.elasticOut, duration: 700.ms);
  }
}

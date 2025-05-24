// lib/features/home/presentation/widgets/mobile_app_pages_section.dart

import 'dart:math' as math;
import 'dart:ui' show lerpDouble; // For explicit lerpDouble import

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:easy_localization/easy_localization.dart'; // Uncomment if used
// import 'package:shamil_web/core/constants/app_strings.dart'; // Uncomment if used
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:responsive_framework/responsive_framework.dart';

//region Data Models
// Ensure these definitions are available. If they are in separate files, import them.
// Placing them here for completeness based on the errors.

enum AppScreenPosition { left, center, right }

class ShamildAppScreen {
  final String title;
  final String subtitle;
  final String screenImage;
  final Color color;
  final AppScreenPosition position;

  ShamildAppScreen({
    required this.title,
    required this.subtitle,
    required this.screenImage,
    required this.color,
    required this.position,
  });
}
//endregion

/// 📱 SHAMIL MOBILE APP SHOWCASE SECTION 📱
/// Features three phones with a smooth scroll-based separation animation.
/// Phones emerge from behind the center phone, creating a dynamic and engaging reveal.
class MobileAppPagesSection extends StatefulWidget {
  final ScrollController scrollController;

  const MobileAppPagesSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<MobileAppPagesSection> createState() => _MobileAppPagesSectionState();
}

class _MobileAppPagesSectionState extends State<MobileAppPagesSection>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _floatingController;
  late AnimationController _entryAnimationController;

  double _scrollProgress = 0.0;
  final GlobalKey _sectionKey = GlobalKey();

  final List<ShamildAppScreen> _appScreens = [
    ShamildAppScreen(
      title: 'Face Analysis',
      subtitle: 'Scan your face to see it in its full glory',
      screenImage: AppAssets.shamilScreen1,
      color: const Color(0xFF2A548D),
      position: AppScreenPosition.left,
    ),
    ShamildAppScreen(
      title: 'Smart Booking',
      subtitle: 'Book beauty services instantly',
      screenImage: AppAssets.shamilScreen2,
      color: const Color(0xFFD8A31A),
      position: AppScreenPosition.center,
    ),
    ShamildAppScreen(
      title: 'Your Results',
      subtitle: 'Discover your perfect look',
      screenImage: AppAssets.shamilScreen3,
      color: const Color(0xFF2A548D),
      position: AppScreenPosition.right,
    ),
  ];

  static const double _behindCenterScale = 0.75;
  static const double _finalSideScale = 0.85;
  static const double _centerScale = 1.0;
  static const double _targetXSeparationDesktop = 220.0;
  static const double _targetXSeparationMobileFactor = 0.55;
  static const double _floatingOffsetAmount = 5.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
    _setupScrollListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entryAnimationController.forward();
      }
    });
  }

  void _initializeAnimationControllers() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _entryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _setupScrollListener() {
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return;
    final RenderBox? renderBox = _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final sectionOffsetGlobal = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final currentScroll = widget.scrollController.offset;

    final animationStartThreshold = sectionOffsetGlobal.dy - screenHeight * 0.80;
    final animationEndThreshold = sectionOffsetGlobal.dy - screenHeight * 0.25;

    double calculatedProgress = 0.0;
    if (animationEndThreshold > animationStartThreshold) {
      if (currentScroll >= animationEndThreshold) {
        calculatedProgress = 1.0;
      } else if (currentScroll > animationStartThreshold) {
        calculatedProgress = (currentScroll - animationStartThreshold) / (animationEndThreshold - animationStartThreshold);
      }
    }

    if (mounted) {
      setState(() {
        _scrollProgress = math.min(1.0, math.max(0.0, calculatedProgress));
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _floatingController.dispose();
    _entryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Container(
      key: _sectionKey,
      decoration: _buildSectionBackground(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: isMobile ? 60 : 100,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildSectionHeader(theme, isMobile)
                  .animate(controller: _entryAnimationController)
                  .fadeIn(delay: 100.ms, duration: 500.ms)
                  .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic),
                SizedBox(height: isMobile ? 40 : 80),
                SizedBox(
                  height: isMobile ? 400 : 600,
                  child: _buildPhonesDisplay(theme, isMobile),
                ),
                SizedBox(height: isMobile ? 40 : 60),
                _buildCallToAction(theme, isMobile)
                  .animate(controller: _entryAnimationController)
                  .fadeIn(delay: 300.ms, duration: 500.ms)
                  .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildSectionBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: theme.brightness == Brightness.light
            ? [ const Color(0xFFFDFDFD), const Color(0xFFF8FBFF), const Color(0xFFFFFFFF)]
            : [ const Color(0xFF0F1419), const Color(0xFF1A2332), const Color(0xFF0F1419)],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, bool isMobile) {
    // Content remains the same
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient( colors: [ const Color(0xFF2A548D).withOpacity(0.1), const Color(0xFFD8A31A).withOpacity(0.1)],),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A548D).withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2A548D), shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text("✨ Mobile Experience", style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF2A548D), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient( colors: [Color(0xFF2A548D), Color(0xFFD8A31A), Color(0xFF2A548D)], stops: [0.0, 0.5, 1.0],).createShader(bounds),
          child: Text( "Scan your face to see it in its full glory",
            style: (isMobile ? theme.textTheme.headlineLarge : theme.textTheme.displaySmall)?.copyWith( color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2,),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text( "Experience the power of AI-driven beauty analysis with our cutting-edge face scanning technology.",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7), height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPhonesDisplay(ThemeData theme, bool isMobile) {
    // Accessing elements known to exist in _appScreens.
    // If _appScreens could be modified to not contain these, add error handling or nullable types.
    final ShamildAppScreen leftScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.left);
    final ShamildAppScreen centerScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.center);
    final ShamildAppScreen rightScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.right);

    // Using indexOf is safe if the objects are guaranteed to be in the list.
    final int leftScreenIndex = _appScreens.indexOf(leftScreen);
    final int centerScreenIndex = _appScreens.indexOf(centerScreen);
    final int rightScreenIndex = _appScreens.indexOf(rightScreen);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Container(
              width: isMobile? 280 : 420,
              height: isMobile? 280 : 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2A548D).withOpacity(0.02 + (_floatingController.value * 0.025)),
                    const Color(0xFFD8A31A).withOpacity(0.01 + (_floatingController.value * 0.015)),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0]
                ),
              ),
            );
          },
        ),
        _buildAnimatedPhone(leftScreen, leftScreenIndex, theme, isMobile),
        _buildAnimatedPhone(rightScreen, rightScreenIndex, theme, isMobile),
        _buildAnimatedPhone(centerScreen, centerScreenIndex, theme, isMobile),
      ],
    );
  }

  Widget _buildAnimatedPhone(
    ShamildAppScreen screen,
    int animationIndex,
    ThemeData theme,
    bool isMobile,
  ) {
    final double easedScrollProgress = Curves.easeInOutCubic.transform(_scrollProgress);
    
    double xOffset = 0.0;
    double currentScale = 1.0;
    double currentOpacity = 1.0;

    final double targetX = isMobile 
        ? _targetXSeparationDesktop * _targetXSeparationMobileFactor 
        : _targetXSeparationDesktop;

    // Calculate transformations based on screen position and scroll progress
    switch (screen.position) { // This was the location of "Undefined name 'AppScreenPosition'"
      case AppScreenPosition.left:
        xOffset = lerpDouble(0, -targetX, easedScrollProgress)!;
        currentScale = lerpDouble(_behindCenterScale, _finalSideScale, easedScrollProgress)!;
        currentOpacity = lerpDouble(0.0, 1.0, easedScrollProgress)!;
        break;
      case AppScreenPosition.center:
        xOffset = 0.0;
        currentScale = _centerScale;
        currentOpacity = 1.0;
        break;
      case AppScreenPosition.right:
        xOffset = lerpDouble(0, targetX, easedScrollProgress)!;
        currentScale = lerpDouble(_behindCenterScale, _finalSideScale, easedScrollProgress)!;
        currentOpacity = lerpDouble(0.0, 1.0, easedScrollProgress)!;
        break;
    }

    final floatOffsetY = math.sin((_floatingController.value * 2 * math.pi) + (animationIndex * (math.pi / 2.5))) * _floatingOffsetAmount;

    Widget phoneWidget = _buildPhoneMockup(screen, theme, isMobile);

    phoneWidget = Opacity(
      opacity: currentOpacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: currentScale,
        child: phoneWidget,
      ),
    );
    
    phoneWidget = Transform.translate(
      offset: Offset(xOffset, floatOffsetY),
      child: phoneWidget,
    );

    return phoneWidget.animate(
      autoPlay: false, 
      controller: _entryAnimationController,
    )
    .fadeIn(delay: (150 + animationIndex * 80).ms, duration: 350.ms)
    .slideY(delay: (150 + animationIndex * 80).ms, begin: 0.15, duration: 350.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildPhoneMockup(ShamildAppScreen screen, ThemeData theme, bool isMobile) {
    final phoneWidth = isMobile ? 170.0 : 230.0; 
    final phoneHeight = phoneWidth * 2.12; 
    final borderRadius = phoneWidth * 0.12;

    return Container(
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.brightness == Brightness.light
              ? [Colors.grey.shade400, Colors.grey.shade600]
              : [const Color(0xFF3A3D40), const Color(0xFF1E1F21)],
        ),
        boxShadow: [
          BoxShadow( color: Colors.black.withOpacity(0.30), blurRadius: 28, spreadRadius: -6, offset: const Offset(0, 18)),
          BoxShadow( color: screen.color.withOpacity(0.12), blurRadius: 30, spreadRadius: -8, offset: const Offset(0, 12)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(phoneWidth * 0.025),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius * 0.88),
          child: Container(
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildScreenContent(screen, theme, phoneWidth),
                _buildPhoneNotch(phoneWidth),
                _buildScreenReflection(phoneWidth, phoneHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenContent(ShamildAppScreen screen, ThemeData theme, double phoneWidth) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(screen.screenImage),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            debugPrint('Error loading screen image: ${screen.screenImage}, $exception');
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.25), screen.color.withOpacity(0.55)],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(phoneWidth * 0.075),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: phoneWidth * 0.1),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(phoneWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45), 
                  borderRadius: BorderRadius.circular(phoneWidth * 0.035),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text( screen.title, style: TextStyle( color: Colors.white, fontSize: phoneWidth * 0.078, fontWeight: FontWeight.bold, letterSpacing: 0.4,)),
                    SizedBox(height: phoneWidth * 0.015),
                    Text( screen.subtitle, style: TextStyle( color: Colors.white.withOpacity(0.88), fontSize: phoneWidth * 0.048, height: 1.35)),
                  ],
                ),
              ),
              SizedBox(height: phoneWidth * 0.06),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildPhoneNotch(double phoneWidth) {
    return Positioned(
      top: phoneWidth * 0.04, 
      left: phoneWidth * 0.32,
      right: phoneWidth * 0.32,
      child: Container(
        height: phoneWidth * 0.06,
        decoration: BoxDecoration( color: Colors.black, borderRadius: BorderRadius.circular(phoneWidth * 0.03)),
      ),
    );
  }

  Widget _buildScreenReflection(double phoneWidth, double phoneHeight) {
    return Positioned(
      top: 0, left: 0,  
      child: Transform.rotate(
        angle: -math.pi / 5,
        origin: Offset(-phoneWidth * 0.1, -phoneHeight * 0.05),
        child: Opacity(
          opacity: 0.07,
          child: Container(
            width: phoneWidth * 0.7, height: phoneHeight * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [ Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.03), Colors.transparent],
                stops: const [0.0, 0.35, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCallToAction(ThemeData theme, bool isMobile) {
    // Content remains the same
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient( colors: theme.brightness == Brightness.light 
            ? [const Color(0xFF2A548D).withOpacity(0.03), const Color(0xFFD8A31A).withOpacity(0.02)]
            : [const Color(0xFF2A548D).withOpacity(0.08), const Color(0xFFD8A31A).withOpacity(0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all( color: const Color(0xFF2A548D).withOpacity(theme.brightness == Brightness.light ? 0.1 : 0.2), width: 1),
      ),
      child: Column(
        children: [
          Text( "Ready to discover your beauty potential?",
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)?.copyWith( fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface,),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text( "Download Shamil and start your personalized beauty journey today.",
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
            children: [
              _ShamildDownloadButton(text: "App Store", icon: Icons.apple, onPressed: () { /* TODO: Link */ }),
              _ShamildDownloadButton(text: "Google Play", icon: Icons.shop_outlined, onPressed: () { /* TODO: Link */ }, isPrimary: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShamildDownloadButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ShamildDownloadButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  State<_ShamildDownloadButton> createState() => _ShamildDownloadButtonState();
}

class _ShamildDownloadButtonState extends State<_ShamildDownloadButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2A548D);
    final secondaryColor = const Color(0xFFD8A31A);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.04 : 1.0),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon( widget.icon, size: 20, color: widget.isPrimary ? Colors.white : (_isHovered ? secondaryColor : primaryColor)),
          label: Text(widget.text, style: const TextStyle(fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary ? (_isHovered ? primaryColor.withOpacity(0.88) : primaryColor) : Colors.transparent,
            foregroundColor: widget.isPrimary ? Colors.white : (_isHovered ? secondaryColor : primaryColor),
            side: widget.isPrimary ? null : BorderSide( color: _isHovered ? secondaryColor : primaryColor, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: _isHovered ? 8 : (widget.isPrimary ? 4 : 0),
            shadowColor: primaryColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
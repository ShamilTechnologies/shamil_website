// lib/features/home/presentation/widgets/mobile_app_pages_section.dart

import 'dart:math' as math; // 📐 Math functions for calculations
import 'dart:ui' show lerpDouble; // 💧 For smooth interpolation of double values

import 'package:flutter/material.dart'; // 🧱 Flutter's material design widgets
import 'package:flutter_animate/flutter_animate.dart'; // ✨ For declarative animations
// import 'package:easy_localization/easy_localization.dart'; // Uncomment if used for localization 🌍
// import 'package:shamil_web/core/constants/app_strings.dart'; // Uncomment if used for string constants 📜
import 'package:shamil_web/core/constants/app_dimensions.dart'; // 📏 For consistent spacing and sizing
import 'package:shamil_web/core/constants/app_assets.dart'; // 🖼️ For asset paths (images, etc.)
import 'package:responsive_framework/responsive_framework.dart'; // 📱 For responsive UI design

//region Data Models 🧩
// Ensure these definitions are available. If they are in separate files, import them.
// Placing them here for completeness based on the errors.

// Enum to define the position of the app screen in the showcase 📍
enum AppScreenPosition { left, center, right }

// Data class for each app screen displayed in the showcase 📱🖼️
class ShamildAppScreen {
  final String title; // Screen title 📝
  final String subtitle; // Screen subtitle/description 📄
  final String screenImage; // Asset path for the screen image 🏞️
  final Color color; // Accent color associated with the screen 🎨
  final AppScreenPosition position; // Position in the layout (left, center, right) ↔️

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
/// Phones emerge from behind the center phone, creating a dynamic and engaging reveal. ✨💨
class MobileAppPagesSection extends StatefulWidget {
  final ScrollController scrollController; // Controller to listen to scroll events 📜🖱️

  const MobileAppPagesSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<MobileAppPagesSection> createState() => _MobileAppPagesSectionState();
}

class _MobileAppPagesSectionState extends State<MobileAppPagesSection>
    with TickerProviderStateMixin {
  // Animation controllers ⚙️⌛
  late AnimationController _floatingController; // For subtle floating animation of phones 둥실둥실
  late AnimationController _entryAnimationController; // For initial entry animation of the section 🎬

  double _scrollProgress = 0.0; // Tracks scroll progress for animations (0.0 to 1.0) 📊
  final GlobalKey _sectionKey = GlobalKey(); // Key to get section's position and size 🗝️

  // Data for the app screens to be displayed 📲🖼️🎨
  final List<ShamildAppScreen> _appScreens = [
    ShamildAppScreen(
      title: 'Passes Page', // Title for the left phone
      subtitle: 'This page allows users to manage all their reservations and subscriptions.', // Subtitle
      screenImage: AppAssets.shamilScreen1, // Image asset
      color: const Color(0xFF2A548D), // Accent color (Shamil Blue)
      position: AppScreenPosition.left, // Positioned to the left
    ),
    ShamildAppScreen(
      title: 'Explore Page', // Title for the center phone
      subtitle: 'screen where users can discover all available services and subscriptions around them.', // Subtitle
      screenImage: AppAssets.shamilScreen2, // Image asset
      color: const Color(0xFFD8A31A), // Accent color (Shamil Gold)
      position: AppScreenPosition.center, // Positioned in the center
    ),
    ShamildAppScreen(
      title: 'Community Page', // Title for the right phone
      subtitle: 'this page helps users connect with the community. ', // Subtitle
      screenImage: AppAssets.shamilScreen3, // Image asset
      color: const Color(0xFF2A548D), // Accent color (Shamil Blue)
      position: AppScreenPosition.right, // Positioned to the right
    ),
  ];

  // --- Animation & Layout Constants ---
  static const double _behindCenterScale = 0.76; // 🤏 Scale of phones when behind the center one
  static const double _finalSideScale = 0.85; // 📏 Final scale of side phones when separated
  static const double _centerScale = 1.05; // 🎯 Scale of the center phone
  // MODIFIED: Increased separation for better spacing ↔️
  static const double _targetXSeparationDesktop = 240.0; // Previously 220.0. Horizontal separation on desktop 🖥️
  // MODIFIED: Adjusted mobile factor for better spacing on smaller screens ↔️
  static const double _targetXSeparationMobileFactor = 0.65; // Previously 0.55. Factor for mobile separation 📱
  static const double _floatingOffsetAmount = 4.0; // ↕️ Amount of vertical float for phones

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers(); // Initialize animation controllers 🚀
    _setupScrollListener(); // Setup listener for scroll events 👂📜
    // Trigger entry animation after the first frame is built 🖼️➡️🎬
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entryAnimationController.forward();
      }
    });
  }

  // Method to initialize animation controllers ⚙️⌛
  void _initializeAnimationControllers() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4), // Duration of one float cycle
      vsync: this, // Required for animations
    )..repeat(reverse: true); // Repeat animation back and forth 🔄

    _entryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600), // Duration of entry animation
      vsync: this,
    );
  }

  // Method to setup scroll listener and initial scroll check 👂📜
  void _setupScrollListener() {
    widget.scrollController.addListener(_onScroll); // Listen to scroll changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll(); // Initial check for scroll position
    });
  }

  // Callback for scroll events to update animation progress 📊🖱️
  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return; // Exit if widget not mounted or key context is null
    final RenderBox? renderBox = _sectionKey.currentContext!.findRenderObject() as RenderBox?; // Get RenderBox of the section
    if (renderBox == null) return; // Exit if RenderBox not found

    final sectionOffsetGlobal = renderBox.localToGlobal(Offset.zero); // Section's position on screen
    final screenHeight = MediaQuery.of(context).size.height; // Height of the screen
    final currentScroll = widget.scrollController.offset; // Current scroll offset

    // Define start and end points for scroll-based animation 🏁
    final animationStartThreshold = sectionOffsetGlobal.dy - screenHeight * 0.80; // When 80% of section is visible from bottom
    final animationEndThreshold = sectionOffsetGlobal.dy - screenHeight * 0.25; // When 25% of section is visible from bottom

    double calculatedProgress = 0.0; // Initialize progress
    // Calculate progress if within animation thresholds
    if (animationEndThreshold > animationStartThreshold) {
      if (currentScroll >= animationEndThreshold) {
        calculatedProgress = 1.0; // Animation complete
      } else if (currentScroll > animationStartThreshold) {
        // Interpolate progress
        calculatedProgress = (currentScroll - animationStartThreshold) / (animationEndThreshold - animationStartThreshold);
      }
    }

    // Update state with clamped progress value (0.0 to 1.0)
    if (mounted) {
      setState(() {
        _scrollProgress = math.min(1.0, math.max(0.0, calculatedProgress));
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll); // Clean up scroll listener 🧹
    _floatingController.dispose(); // Clean up floating animation controller 🧹
    _entryAnimationController.dispose(); // Clean up entry animation controller 🧹
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme 🎨
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE); // Check if on mobile 📱

    return Container(
      key: _sectionKey, // Assign key to track section's position
      decoration: _buildSectionBackground(theme), // Apply background decoration 🖼️✨
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal, // Horizontal padding ↔️
          vertical: isMobile ? 60 : 100, // Vertical padding based on device type ↕️
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200), // Max width for content 📏
            child: Column(
              children: [
                // Section Header (Title and Subtitle) 🗣️
                _buildSectionHeader(theme, isMobile)
                  .animate(controller: _entryAnimationController) // Animate header on entry
                  .fadeIn(delay: 100.ms, duration: 500.ms) // Fade in effect
                  .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic), // Slide in effect
                SizedBox(height: isMobile ? 40 : 80), // Spacing based on device type

                // Phones Display Area 📱📱📱
                SizedBox(
                  height: isMobile ? 400 : 600, // Height of the phone display area
                  child: _buildPhonesDisplay(theme, isMobile), // Build the phone mockups
                ),
                SizedBox(height: isMobile ? 30 : 50), // Spacing

                // Call To Action (CTA) button section 📢🔘
                _buildCallToAction(theme, isMobile)
                  .animate(controller: _entryAnimationController) // Animate CTA on entry
                  .fadeIn(delay: 300.ms, duration: 500.ms) // Fade in effect
                  .slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOutCubic), // Slide in effect
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the background decoration for the section 🖼️✨
  BoxDecoration _buildSectionBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient( // Gradient background
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: theme.brightness == Brightness.light // Different colors for light/dark theme
            ? [ const Color(0xFFFDFDFD), const Color(0xFFF8FBFF), const Color(0xFFFFFFFF)] // Light theme gradient
            : [ const Color(0xFF0F1419), const Color(0xFF1A2332), const Color(0xFF0F1419)], // Dark theme gradient
      ),
    );
  }

  // Builds the header part of the section (Title, Subtitle) 🗣️📜
  Widget _buildSectionHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Badge with "Mobile Experience" text ✨🏷️
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient( colors: [ const Color(0xFF2A548D).withOpacity(0.1), const Color(0xFFD8A31A).withOpacity(0.1)],), // Subtle gradient
            borderRadius: BorderRadius.circular(20), // Rounded corners
            border: Border.all(color: const Color(0xFF2A548D).withOpacity(0.2), width: 1), // Border
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Takes minimum space
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2A548D), shape: BoxShape.circle)), // Small dot
              const SizedBox(width: 8),
              Text("✨ Mobile Experience", style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF2A548D), fontWeight: FontWeight.w600)), // Text
            ],
          ),
        ),
        const SizedBox(height: 24), // Spacing

        // Main title with ShaderMask for gradient text effect 🎨📝
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient( colors: [Color(0xFF2A548D), Color(0xFFD8A31A), Color(0xFF2A548D)], stops: [0.0, 0.5, 1.0],).createShader(bounds),
          child: Text( "Main App Screens", // Section title
            style: (isMobile ? theme.textTheme.headlineLarge : theme.textTheme.displaySmall)?.copyWith( color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2,),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16), // Spacing

        // Subtitle / Description 📄
        Container(
          constraints: const BoxConstraints(maxWidth: 600), // Max width for subtitle
          child: Text( "Explore the core features of the Shamil app through these interactive screens designed to enhance your beauty journey.", // Subtitle text
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7), height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Builds the display area for the phone mockups 📱📱📱💨
  Widget _buildPhonesDisplay(ThemeData theme, bool isMobile) {
    // Get screen data for left, center, and right positions
    final ShamildAppScreen leftScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.left);
    final ShamildAppScreen centerScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.center);
    final ShamildAppScreen rightScreen = _appScreens.firstWhere((s) => s.position == AppScreenPosition.right);

    // Get indices for animation staggering (optional, but good for complex animations)
    final int leftScreenIndex = _appScreens.indexOf(leftScreen);
    final int centerScreenIndex = _appScreens.indexOf(centerScreen);
    final int rightScreenIndex = _appScreens.indexOf(rightScreen);

    return Stack( // Use Stack to layer phones and background elements
      alignment: Alignment.center, // Align children to the center
      children: [
        // Animated background glow ✨🍥
        AnimatedBuilder(
          animation: _floatingController, // Driven by floating animation
          builder: (context, child) {
            return Container(
              width: isMobile? 280 : 420, // Size of the glow area
              height: isMobile? 280 : 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Circular glow
                gradient: RadialGradient( // Radial gradient for soft glow
                  colors: [
                    const Color(0xFF2A548D).withOpacity(0.02 + (_floatingController.value * 0.025)), // Shamil Blue glow
                    const Color(0xFFD8A31A).withOpacity(0.01 + (_floatingController.value * 0.015)), // Shamil Gold glow
                    Colors.transparent, // Fade to transparent
                  ],
                  stops: const [0.0, 0.4, 1.0] // Gradient stops
                ),
              ),
            );
          },
        ),
        // Build and animate each phone mockup 📱💨
        _buildAnimatedPhone(leftScreen, leftScreenIndex, theme, isMobile), // Left phone
        _buildAnimatedPhone(rightScreen, rightScreenIndex, theme, isMobile), // Right phone
        _buildAnimatedPhone(centerScreen, centerScreenIndex, theme, isMobile), // Center phone (drawn last to be on top initially)
      ],
    );
  }

  // Builds a single animated phone mockup 📱💨✨
  Widget _buildAnimatedPhone(
    ShamildAppScreen screen, // Data for the screen
    int animationIndex, // Index for staggering animations
    ThemeData theme, // Current theme
    bool isMobile, // Mobile or desktop view
  ) {
    // Eased scroll progress for smoother animation
    final double easedScrollProgress = Curves.easeInOutCubic.transform(_scrollProgress);
    
    double xOffset = 0.0; // Horizontal offset for separation
    double currentScale = 1.0; // Current scale of the phone
    double currentOpacity = 1.0; // Current opacity of the phone

    // Target horizontal separation based on device type
    final double targetX = isMobile 
        ? _targetXSeparationDesktop * _targetXSeparationMobileFactor 
        : _targetXSeparationDesktop;

    // Calculate transformations based on screen position and scroll progress 📐💨
    switch (screen.position) { 
      case AppScreenPosition.left: // Left phone
        xOffset = lerpDouble(0, -targetX, easedScrollProgress)!; // Moves from center to left
        currentScale = lerpDouble(_behindCenterScale, _finalSideScale, easedScrollProgress)!; // Scales up
        currentOpacity = lerpDouble(0.0, 1.0, easedScrollProgress)!; // Fades in
        break;
      case AppScreenPosition.center: // Center phone
        xOffset = 0.0; // Stays in the center
        currentScale = _centerScale; // Full scale
        currentOpacity = 1.0; // Fully opaque
        break;
      case AppScreenPosition.right: // Right phone
        xOffset = lerpDouble(0, targetX, easedScrollProgress)!; // Moves from center to right
        currentScale = lerpDouble(_behindCenterScale, _finalSideScale, easedScrollProgress)!; // Scales up
        currentOpacity = lerpDouble(0.0, 1.0, easedScrollProgress)!; // Fades in
        break;
    }

    // Vertical floating offset 둥실둥실
    final floatOffsetY = math.sin((_floatingController.value * 2 * math.pi) + (animationIndex * (math.pi / 2.5))) * _floatingOffsetAmount;

    // Build the basic phone mockup widget 📱
    Widget phoneWidget = _buildPhoneMockup(screen, theme, isMobile);

    // Apply opacity and scale transformations based on scroll progress and position ✨
    phoneWidget = Opacity(
      opacity: currentOpacity.clamp(0.0, 1.0), // Clamp opacity to valid range
      child: Transform.scale(
        scale: currentScale,
        child: phoneWidget,
      ),
    );
    
    // Apply horizontal separation and vertical float transformations ↔️↕️
    phoneWidget = Transform.translate(
      offset: Offset(xOffset, floatOffsetY),
      child: phoneWidget,
    );

    // Apply entry animation to the phone widget 🎬💨
    return phoneWidget.animate(
      autoPlay: false, // Controlled by _entryAnimationController
      controller: _entryAnimationController,
    )
    .fadeIn(delay: (150 + animationIndex * 80).ms, duration: 350.ms) // Staggered fade in
    .slideY(delay: (150 + animationIndex * 80).ms, begin: 0.15, duration: 350.ms, curve: Curves.easeOutCubic); // Staggered slide in
  }

  // Builds the visual representation of a phone mockup 📱🖼️
  Widget _buildPhoneMockup(ShamildAppScreen screen, ThemeData theme, bool isMobile) {
    final phoneWidth = isMobile ? 170.0 : 230.0; // Width based on device
    final phoneHeight = phoneWidth * 2.12; // Aspect ratio for phone height
    final borderRadius = phoneWidth * 0.12; // Border radius for phone frame

    return Container( // Outer frame of the phone
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient( // Gradient for phone frame material
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.brightness == Brightness.light
              ? [Colors.grey.shade400, Colors.grey.shade600] // Light theme frame
              : [const Color(0xFF3A3D40), const Color(0xFF1E1F21)], // Dark theme frame
        ),
        boxShadow: [ // Shadows for depth and realism 🕶️
          BoxShadow( color: Colors.black.withOpacity(0.30), blurRadius: 28, spreadRadius: -6, offset: const Offset(0, 18)), // Main shadow
          BoxShadow( color: screen.color.withOpacity(0.12), blurRadius: 30, spreadRadius: -8, offset: const Offset(0, 12)), // Accent color shadow
        ],
      ),
      child: Padding( // Padding for the screen bezel
        padding: EdgeInsets.all(phoneWidth * 0.025),
        child: ClipRRect( // Clip the screen content to rounded corners
          borderRadius: BorderRadius.circular(borderRadius * 0.88), // Inner screen radius
          child: Container(
            color: Colors.black, // Screen background color (usually black)
            child: Stack( // Stack for screen content, notch, reflection
              fit: StackFit.expand,
              children: [
                _buildScreenContent(screen, theme, phoneWidth), // Actual app screen image and overlay 🖼️📄
                _buildPhoneNotch(phoneWidth), // Phone notch/dynamic island 🤳
                _buildScreenReflection(phoneWidth, phoneHeight), // Subtle screen reflection ✨
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the content displayed on the phone screen (image and text overlay) 🖼️📄🔍
  Widget _buildScreenContent(ShamildAppScreen screen, ThemeData theme, double phoneWidth) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage( // Background image for the screen
          image: AssetImage(screen.screenImage),
          fit: BoxFit.cover, // Cover the area
          onError: (exception, stackTrace) { // Error handling for image loading
            debugPrint('Error loading screen image: ${screen.screenImage}, $exception');
          },
        ),
      ),
      child: Container( // Gradient overlay on top of the image
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.25), screen.color.withOpacity(0.55)], // Darken bottom for text
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Padding( // Padding for text content on the screen
          padding: EdgeInsets.all(phoneWidth * 0.075),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
            children: [
              SizedBox(height: phoneWidth * 0.1), // Space for notch
              const Spacer(), // Push text to the bottom
              Container( // Background for text for better readability
                padding: EdgeInsets.all(phoneWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45), 
                  borderRadius: BorderRadius.circular(phoneWidth * 0.035),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text( screen.title, style: TextStyle( color: Colors.white, fontSize: phoneWidth * 0.078, fontWeight: FontWeight.bold, letterSpacing: 0.4,)), // Screen title
                    SizedBox(height: phoneWidth * 0.015),
                    Text( screen.subtitle, style: TextStyle( color: Colors.white.withOpacity(0.88), fontSize: phoneWidth * 0.048, height: 1.35)), // Screen subtitle
                  ],
                ),
              ),
              SizedBox(height: phoneWidth * 0.06), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Builds the phone notch/dynamic island element 🤳➖
   Widget _buildPhoneNotch(double phoneWidth) {
    return Positioned( // Positioned at the top-center of the screen
      top: phoneWidth * 0.04, 
      left: phoneWidth * 0.32,
      right: phoneWidth * 0.32,
      child: Container(
        height: phoneWidth * 0.06, // Height of the notch
        decoration: BoxDecoration( color: Colors.black, borderRadius: BorderRadius.circular(phoneWidth * 0.03)), // Rounded black notch
      ),
    );
  }

  // Builds a subtle screen reflection effect ✨💎
  Widget _buildScreenReflection(double phoneWidth, double phoneHeight) {
    return Positioned( // Positioned at the top-left of the screen
      top: 0, left: 0,  
      child: Transform.rotate( // Rotated for diagonal reflection
        angle: -math.pi / 5, // Angle of rotation
        origin: Offset(-phoneWidth * 0.1, -phoneHeight * 0.05), // Origin of rotation
        child: Opacity( // Semi-transparent reflection
          opacity: 0.07,
          child: Container(
            width: phoneWidth * 0.7, height: phoneHeight * 0.6, // Size of the reflection
            decoration: BoxDecoration(
              gradient: LinearGradient( // Gradient for the reflection
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [ Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.03), Colors.transparent], // White to transparent
                stops: const [0.0, 0.35, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Builds the call to action section at the bottom 📢🔘
  Widget _buildCallToAction(ThemeData theme, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32), // Padding based on device
      decoration: BoxDecoration(
        gradient: LinearGradient( colors: theme.brightness == Brightness.light // Gradient background for CTA
            ? [const Color(0xFF2A548D).withOpacity(0.03), const Color(0xFFD8A31A).withOpacity(0.02)] // Light theme CTA gradient
            : [const Color(0xFF2A548D).withOpacity(0.08), const Color(0xFFD8A31A).withOpacity(0.05)], // Dark theme CTA gradient
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all( color: const Color(0xFF2A548D).withOpacity(theme.brightness == Brightness.light ? 0.1 : 0.2), width: 1), // Border
      ),
      child: Column( // CTA content
        children: [
          Text( "All Your Services in One App?", // CTA Title
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)?.copyWith( fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface,),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text( "Download Shamil and Book. Subscribe. Manage. All in one place.", // CTA Subtitle
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap( // Download buttons (App Store, Google Play) WRAP으로 감싸 반응형으로 배치
            spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
            children: [
              _ShamildDownloadButton(text: "App Store", icon: Icons.apple, onPressed: () { /* TODO: Link to App Store 🍎 */ }),
              _ShamildDownloadButton(text: "Google Play", icon: Icons.shop_outlined, onPressed: () { /* TODO: Link to Google Play 🤖 */ }, isPrimary: false),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom download button widget 🔘🔽
class _ShamildDownloadButton extends StatefulWidget {
  final String text; // Button text
  final IconData icon; // Button icon
  final VoidCallback onPressed; // Action on press
  final bool isPrimary; // Style variation (primary or secondary)

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
  bool _isHovered = false; // Tracks hover state for animation 🐭👆

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2A548D); // Shamil Blue
    final secondaryColor = const Color(0xFFD8A31A); // Shamil Gold

    return MouseRegion( // Detect mouse hover
      onEnter: (_) => setState(() => _isHovered = true), // Set hover true
      onExit: (_) => setState(() => _isHovered = false), // Set hover false
      cursor: SystemMouseCursors.click, // Clickable cursor
      child: AnimatedContainer( // Animate button scale on hover
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.04 : 1.0), // Scale up on hover
        child: ElevatedButton.icon( // Button itself
          onPressed: widget.onPressed,
          icon: Icon( widget.icon, size: 20, color: widget.isPrimary ? Colors.white : (_isHovered ? secondaryColor : primaryColor)), // Icon style
          label: Text(widget.text, style: const TextStyle(fontWeight: FontWeight.w600)), // Label style
          style: ElevatedButton.styleFrom( // Button styling
            backgroundColor: widget.isPrimary ? (_isHovered ? primaryColor.withOpacity(0.88) : primaryColor) : Colors.transparent, // Background color
            foregroundColor: widget.isPrimary ? Colors.white : (_isHovered ? secondaryColor : primaryColor), // Text/icon color
            side: widget.isPrimary ? null : BorderSide( color: _isHovered ? secondaryColor : primaryColor, width: 2), // Border for secondary button
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Padding
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Shape
            elevation: _isHovered ? 8 : (widget.isPrimary ? 4 : 0), // Elevation on hover
            shadowColor: primaryColor.withOpacity(0.3), // Shadow color
          ),
        ),
      ),
    );
  }
}
// lib/features/home/presentation/widgets/intro_section.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 🌟 VIRAL SHAMIL INTRO SECTION 🌟
/// Clean, flexible design with smooth animations and Shamil branding
/// Optimized for eye comfort and viral appeal
class IntroSection extends StatefulWidget {
  const IntroSection({super.key});

  @override
  State<IntroSection> createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection>
    with TickerProviderStateMixin {
  
  // Simple animation controllers
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Gentle floating animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    // Soft glow pulse
    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Entry animation
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Start entry animation
    _entryController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _glowController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    
    return Container(
      decoration: _buildShamildDecoration(theme),
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatingController, _glowController]),
        builder: (context, child) => _buildContent(theme, isMobile),
      ),
    );
  }

  /// Build Shamil-themed gradient background
  BoxDecoration _buildShamildDecoration(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: theme.brightness == Brightness.light
            ? [
                const Color(0xFF2A548D).withOpacity(0.05), // Shamil blue very light
                const Color(0xFFD8A31A).withOpacity(0.02), // Shamil gold very light
                Colors.white,
              ]
            : [
                const Color(0xFF1A2332), // Shamil dark surface
                const Color(0xFF0F1419), // Shamil darker
                Colors.black,
              ],
      ),
    );
  }

  /// Build main content with smooth animations
  Widget _buildContent(ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingPageHorizontal,
        vertical: isMobile ? 60 : 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveRowColumn(
            layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            columnSpacing: isMobile ? 40 : 0,
            rowSpacing: 80,
            children: [
              // Text Content
              ResponsiveRowColumnItem(
                rowFlex: 3,
                child: _buildTextSection(theme, isMobile),
              ),
              
              // Visual Element
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: _buildViralVisual(theme, isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build text section with viral typography
  Widget _buildTextSection(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        _buildViralBadge(theme).animate(delay: 200.ms)
          .fadeIn(duration: 800.ms)
          .slideY(begin: -0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 24),
        
        // Main Title
        _buildMainTitle(theme, isMobile).animate(delay: 400.ms)
          .fadeIn(duration: 1000.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 24),
        
        // Description
        _buildDescription(theme, isMobile).animate(delay: 600.ms)
          .fadeIn(duration: 1000.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 32),
        
        // Features
        _buildFeatures(theme, isMobile).animate(delay: 800.ms)
          .fadeIn(duration: 800.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
      ],
    );
  }

  /// Build viral badge
  Widget _buildViralBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A548D).withOpacity(0.1), // Shamil blue
            const Color(0xFFD8A31A).withOpacity(0.1), // Shamil gold
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2A548D).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2A548D),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(duration: 1000.ms, curve: Curves.easeInOut)
           .then()
           .scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0), duration: 1000.ms),
          
          const SizedBox(width: 12),
          
          Text(
            "✨ Smart Service Platform",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF2A548D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build main title with Shamil gradient
  Widget _buildMainTitle(ThemeData theme, bool isMobile) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF2A548D), // Shamil blue
          Color(0xFFD8A31A), // Shamil gold
          Color(0xFF2A548D), // Back to blue
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        AppStrings.whatIsShamil.tr(),
        style: (isMobile 
            ? theme.textTheme.displaySmall 
            : theme.textTheme.displayMedium)?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          height: 1.1,
        ),
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  /// Build eye-comfortable description
  Widget _buildDescription(ThemeData theme, bool isMobile) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Text(
        AppStrings.introText.tr(),
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          height: 1.6,
          fontWeight: FontWeight.w400,
        ),
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  /// Build simple feature highlights
  Widget _buildFeatures(ThemeData theme, bool isMobile) {
    final features = [
      {"icon": "⚡", "text": "Lightning Fast", "color": const Color(0xFF2A548D)},
      {"icon": "🔒", "text": "Secure & Safe", "color": const Color(0xFFD8A31A)},
      {"icon": "🎯", "text": "Smart AI", "color": const Color(0xFF2A548D)},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (feature["color"] as Color).withOpacity(0.08),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: (feature["color"] as Color).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                feature["icon"] as String,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                feature["text"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: feature["color"] as Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate(delay: (1000 + index * 150).ms)
         .fadeIn(duration: 600.ms)
         .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
      }).toList(),
    );
  }

  /// Build viral visual element
  Widget _buildViralVisual(ThemeData theme, bool isMobile) {
    return Transform.translate(
      offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 8),
      child: Container(
        width: isMobile ? 280 : 350,
        height: isMobile ? 280 : 350,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF2A548D).withOpacity(0.1 + (_glowController.value * 0.1)),
              const Color(0xFFD8A31A).withOpacity(0.05 + (_glowController.value * 0.05)),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A548D).withOpacity(0.1 + (_glowController.value * 0.1)),
              blurRadius: 40 + (_glowController.value * 20),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating rings
            ...List.generate(3, (index) => _buildRotatingRing(index)),
            
            // Center logo
            _buildCenterLogo(theme, isMobile),
          ],
        ),
      ),
    ).animate(delay: 1000.ms)
     .fadeIn(duration: 1200.ms)
     .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutCubic);
  }

  /// Build rotating ring
  Widget _buildRotatingRing(int index) {
    final size = 120.0 + (index * 60);
    final rotationSpeed = 0.5 + (index * 0.3);
    
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _floatingController.value * 2 * math.pi * rotationSpeed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: index.isEven 
                    ? const Color(0xFF2A548D).withOpacity(0.2)
                    : const Color(0xFFD8A31A).withOpacity(0.2),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build center logo with Shamil branding
  Widget _buildCenterLogo(ThemeData theme, bool isMobile) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A548D),
            Color(0xFFD8A31A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A548D).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'S',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .scale(
       begin: const Offset(1.0, 1.0), 
       end: const Offset(1.1, 1.1), 
       duration: 2000.ms,
       curve: Curves.easeInOut,
     )
     .then()
     .scale(
       begin: const Offset(1.1, 1.1), 
       end: const Offset(1.0, 1.0), 
       duration: 2000.ms,
       curve: Curves.easeInOut,
     );
  }
}
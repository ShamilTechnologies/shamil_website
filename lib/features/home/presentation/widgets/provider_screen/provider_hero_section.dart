// lib/features/provider/presentation/widgets/provider_hero_section.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 🚀 Provider Hero Section - Stunning introduction for service providers
class ProviderHeroSection extends StatefulWidget {
  final AnimationController floatingController;
  
  const ProviderHeroSection({
    super.key,
    required this.floatingController,
  });

  @override
  State<ProviderHeroSection> createState() => _ProviderHeroSectionState();
}

class _ProviderHeroSectionState extends State<ProviderHeroSection>
    with TickerProviderStateMixin {
  
  late AnimationController _entryController;
  late AnimationController _pulseController;
  
  // Shamil brand colors
  static const Color _shamildBlue = Color(0xFF2A548D);
  static const Color _shamildGold = Color(0xFFD8A31A);
  
  @override
  void initState() {
    super.initState();
    
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    // Start entry animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: double.infinity,
      height: screenHeight * 0.95,
      decoration: _buildBackgroundDecoration(theme),
      child: Stack(
        children: [
          // Floating particles background
          _buildFloatingParticles(),
          
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingPageHorizontal,
                vertical: isMobile ? 60 : 80,
              ),
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
                      child: _buildTextContent(theme, isMobile),
                    ),
                    
                    // Visual Content
                    ResponsiveRowColumnItem(
                      rowFlex: 2,
                      child: _buildVisualContent(theme, isMobile),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build stunning gradient background
  BoxDecoration _buildBackgroundDecoration(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: theme.brightness == Brightness.light
            ? [
                _shamildBlue.withOpacity(0.95),
                _shamildBlue.withOpacity(0.8),
                _shamildGold.withOpacity(0.6),
              ]
            : [
                const Color(0xFF1A2332),
                const Color(0xFF2A548D).withOpacity(0.8),
                const Color(0xFF0F1419),
              ],
      ),
    );
  }

  /// Build floating particles animation
  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: widget.floatingController,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlesPainter(
              animationValue: widget.floatingController.value,
            ),
          );
        },
      ),
    );
  }

  /// Build text content section
  Widget _buildTextContent(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        _buildProviderBadge(theme).animate(controller: _entryController)
          .fadeIn(delay: 200.ms, duration: 800.ms)
          .slideY(begin: -0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 32),
        
        // Main Title
        _buildMainTitle(theme, isMobile).animate(controller: _entryController)
          .fadeIn(delay: 400.ms, duration: 1000.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 24),
        
        // Subtitle
        _buildSubtitle(theme, isMobile).animate(controller: _entryController)
          .fadeIn(delay: 600.ms, duration: 1000.ms)
          .slideY(begin: 0.2, curve: Curves.easeOutCubic),
        
        const SizedBox(height: 48),
        
        // Action Buttons
        _buildActionButtons(theme, isMobile).animate(controller: _entryController)
          .fadeIn(delay: 800.ms, duration: 800.ms)
          .slideY(begin: 0.3, curve: Curves.easeOutCubic),
      ],
    );
  }

  /// Build provider badge
  Widget _buildProviderBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(duration: 1000.ms, curve: Curves.easeInOut)
           .then()
           .scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0), duration: 1000.ms),
          
          const SizedBox(width: 12),
          
          Text(
            "🏢 For Service Providers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Build main title with gradient text
  Widget _buildMainTitle(ThemeData theme, bool isMobile) {
    return Text(
      ProviderStrings.heroTitle.tr(),
      style: (isMobile 
          ? theme.textTheme.displaySmall 
          : theme.textTheme.displayLarge)?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.1,
      ),
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(duration: 3000.ms, color: _shamildGold.withOpacity(0.4));
  }

  /// Build subtitle
  Widget _buildSubtitle(ThemeData theme, bool isMobile) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Text(
        ProviderStrings.heroSubtitle.tr(),
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white.withOpacity(0.9),
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return ResponsiveRowColumn(
          layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
          rowMainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowSpacing: AppDimensions.spacingLarge,
          columnSpacing: AppDimensions.spacingLarge,
          children: [
            // Primary Button
            ResponsiveRowColumnItem(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _shamildGold.withOpacity(0.4),
                      blurRadius: 20 + (_pulseController.value * 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomButton(
                  text: ProviderStrings.startFreeTrial.tr(),
                  onPressed: () => _handleStartFreeTrial(),
                  icon: const Icon(Icons.rocket_launch_rounded),
                  backgroundColor: _shamildGold,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            // Secondary Button
            ResponsiveRowColumnItem(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 15 + (_pulseController.value * 8),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CustomButton(
                  text: ProviderStrings.contactSales.tr(),
                  onPressed: () => _handleContactSales(),
                  icon: const Icon(Icons.phone_rounded),
                  isSecondary: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build visual content section
  Widget _buildVisualContent(ThemeData theme, bool isMobile) {
    return AnimatedBuilder(
      animation: widget.floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(widget.floatingController.value * 2 * math.pi) * 10),
          child: Container(
            width: isMobile ? 300 : 400,
            height: isMobile ? 300 : 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating rings
                ...List.generate(3, (index) => _buildRotatingRing(index)),
                
                // Center content
                _buildCenterContent(theme, isMobile),
              ],
            ),
          ),
        );
      },
    ).animate(controller: _entryController)
     .fadeIn(delay: 1000.ms, duration: 1200.ms)
     .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutCubic);
  }

  /// Build rotating ring
  Widget _buildRotatingRing(int index) {
    final size = 120.0 + (index * 80);
    final rotationSpeed = 0.3 + (index * 0.2);
    
    return AnimatedBuilder(
      animation: widget.floatingController,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.floatingController.value * 2 * math.pi * rotationSpeed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: index.isEven 
                    ? Colors.white.withOpacity(0.2)
                    : _shamildGold.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build center content
  Widget _buildCenterContent(ThemeData theme, bool isMobile) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            _shamildGold.withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.business_center_rounded,
          size: 50,
          color: Colors.white,
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

  /// Handle start free trial action
  void _handleStartFreeTrial() {
    // TODO: Implement free trial signup
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Free trial signup coming soon!'),
        backgroundColor: _shamildGold,
      ),
    );
  }

  /// Handle contact sales action
  void _handleContactSales() {
    // TODO: Implement contact sales flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact sales form coming soon!'),
        backgroundColor: _shamildBlue,
      ),
    );
  }
}

/// Custom painter for floating particles
class _ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  _ParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Create particles
    for (int i = 0; i < 15; i++) {
      final x = (i * 0.1 + animationValue * 0.1) % 1.0;
      final y = (i * 0.15 + animationValue * 0.05) % 1.0;
      final opacity = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2 * 0.3;
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        2 + (i % 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
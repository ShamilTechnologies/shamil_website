import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/features/demo/simplified_dashboard_demo_screen.dart';
import 'package:shamil_web/core/utils/helpers.dart';

class ProviderDashboardDemoCtaSection extends StatefulWidget {
  const ProviderDashboardDemoCtaSection({super.key});

  @override
  State<ProviderDashboardDemoCtaSection> createState() => _ProviderDashboardDemoCtaSectionState();
}

class _ProviderDashboardDemoCtaSectionState extends State<ProviderDashboardDemoCtaSection>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _floatingController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  // Hover state
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToDemo() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const SimplifiedDashboardDemoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);
    
    return Container(
      key: const ValueKey("ProviderDashboardDemoCtaSection"),
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * (isMobile ? 1.0 : 1.2),
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      color: theme.colorScheme.surface, // Consistent with other sections
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative elements
          _buildBackgroundDecoration(theme),
          
          // Main content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDashboardPreview(theme, isMobile),
                  SizedBox(height: isMobile ? 40 : 60),
                  _buildCallToAction(theme, isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecoration(ThemeData theme) {
    return Positioned.fill(
      child: OverflowBox(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return CustomPaint(
              painter: _BackgroundPatternPainter(
                animation: _floatingController,
                primaryColor: AppColors.primary.withOpacity(0.03),
                secondaryColor: AppColors.primaryGold.withOpacity(0.02),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardPreview(ThemeData theme, bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _navigateToDemo,
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            final floatOffset = math.sin(_floatingController.value * 2 * math.pi) * 8;
            
            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_isHovered ? -0.01 : 0)
                  ..scale(_isHovered ? 1.02 : 1.0),
                transformAlignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    if (_isHovered)
                      Container(
                        width: isMobile ? 300 : 450,
                        height: isMobile ? 200 : 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGold.withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    
                    // Dashboard preview card
                    Container(
                      width: isMobile ? 280 : 400,
                      height: isMobile ? 180 : 250,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered 
                              ? AppColors.primaryGold.withOpacity(0.5)
                              : theme.dividerColor.withOpacity(0.3),
                          width: _isHovered ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Stack(
                          children: [
                            // Dashboard mockup content
                            _buildDashboardMockup(theme, isMobile),
                            
                            // Shimmer overlay
                            if (_isHovered)
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.1),
                                          Colors.transparent,
                                        ],
                                        stops: [
                                          _shimmerController.value - 0.3,
                                          _shimmerController.value,
                                          _shimmerController.value + 0.3,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: Container(
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  );
                                },
                              ),
                            
                            // Play button overlay
                            Center(
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  final pulseScale = 1.0 + (_pulseController.value * 0.1);
                                  return Transform.scale(
                                    scale: pulseScale,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGold.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryGold.withOpacity(0.4),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).animate()
     .fadeIn(delay: 100.ms, duration: 600.ms)
     .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutCubic);
  }

  Widget _buildDashboardMockup(ThemeData theme, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              ...List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ],
          ),
          
          const Spacer(),
          
          // Stats cards mockup
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  color: AppColors.primary.withOpacity(0.1),
                  theme: theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  theme: theme,
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    color: AppColors.accent.withOpacity(0.1),
                    theme: theme,
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Chart mockup
          Container(
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              painter: _ChartPainter(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required Color color, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primaryGold.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LIVE DEMO',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate()
         .fadeIn(delay: 200.ms)
         .slideY(begin: -0.2),
        
        const SizedBox(height: 20),
        
        // Title
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryGold,
            ],
          ).createShader(bounds),
          child: Text(
            ProviderStrings.providerDemoCtaTitle.tr(),
            textAlign: TextAlign.center,
            style: (isMobile ? theme.textTheme.headlineMedium : theme.textTheme.displaySmall)
                ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
          ),
        ).animate()
         .fadeIn(delay: 300.ms)
         .slideY(begin: 0.2),
        
        const SizedBox(height: 16),
        
        // Caption
        Text(
          ProviderStrings.providerDemoCtaCaption.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ).animate()
         .fadeIn(delay: 400.ms)
         .slideY(begin: 0.2),
        
        const SizedBox(height: 32),
        
        // CTA Button
        CustomButton(
          text: ProviderStrings.providerDemoCtaButtonText.tr(),
          icon: const Icon(Icons.rocket_launch_rounded, size: 20),
          onPressed: _navigateToDemo,
          gradient: const LinearGradient(
            colors: [AppColors.primaryGold, AppColors.primary],
          ),
          foregroundColor: Colors.white,
          elevation: 8,
          hoverScale: 1.05,
          shimmerEffect: true,
        ).animate()
         .fadeIn(delay: 500.ms)
         .scale(
           begin: const Offset(0.8, 0.8),
           duration: 600.ms,
           curve: Curves.elasticOut,
         ),
      ],
    );
  }
}

// Custom painters for visual elements
class _BackgroundPatternPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  _BackgroundPatternPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw floating circles
    for (int i = 0; i < 5; i++) {
      final progress = (animation.value + i * 0.2) % 1.0;
      final y = size.height * progress;
      final x = size.width * (0.2 + i * 0.15) + 
                math.sin(progress * math.pi * 2) * 30;
      
      paint.color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withOpacity(0.5 - progress * 0.4);
      
      canvas.drawCircle(
        Offset(x, y),
        30 + i * 10,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChartPainter extends CustomPainter {
  final Color color;

  _ChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barWidth = size.width / 12;
    final random = math.Random(42); // Fixed seed for consistent bars

    for (int i = 0; i < 10; i++) {
      final height = size.height * (0.3 + random.nextDouble() * 0.6);
      final x = i * barWidth * 1.2 + barWidth;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - height, barWidth * 0.8, height),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
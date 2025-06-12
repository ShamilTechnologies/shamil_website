import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/features/home/data/models/service_item_model.dart';
import 'dart:math' as math;

/// Enhanced ServiceCard that works with the new viral design
class ServiceCard extends StatefulWidget {
  final ServiceItem service;
  final bool isMobile;

  const ServiceCard({
    super.key,
    required this.service,
    this.isMobile = false,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.03 : 1.0) // Reduced from 1.05
          ..rotateX(_isHovered ? -0.005 : 0.0) // Reduced from -0.01
          ..setEntry(3, 2, _isHovered ? 0.0004 : 0.0), // Reduced from 0.0008
        child: Container(
          height: widget.isMobile ? 400 : 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? AppColors.primary.withOpacity(0.1) // Reduced from 0.15
                    : Colors.black.withOpacity(0.03),
                blurRadius: _isHovered ? 15 : 8, // Reduced from 25
                spreadRadius: _isHovered ? 0 : -1,
                offset: Offset(0, _isHovered ? 8 : 3), // Reduced from 12
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Enhanced background with shimmer
                _buildEnhancedBackground(),
                
                // Dynamic overlay
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isHovered
                          ? [
                              Colors.black.withOpacity(0.3), // Less change
                              Colors.transparent,
                              AppColors.primary.withOpacity(0.03), // More subtle
                              Colors.black.withOpacity(0.55), // Less change
                            ]
                          : [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                    ),
                  ),
                ),
                
                // Content with magnetic effects
                _buildEnhancedContent(theme),
                
                // Shimmer effect on hover
                if (_isHovered) _buildShimmerEffect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedBackground() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0), // Reduced from 1.08
      child: Image.asset(
        widget.service.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.4),
                  AppColors.primaryGold.withOpacity(0.4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedContent(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () { /* TODO: Handle Card Tap */ },
        splashColor: AppColors.primaryGold.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced title
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0), // Reduced from -6.0
                child: Text(
                  widget.service.titleKey.tr(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: _isHovered ? 8 : 6, // Reduced from 12
                        color: Colors.black.withOpacity(_isHovered ? 0.6 : 0.5), // Reduced from 0.7
                      ),
                    ],
                  ),
                ),
              ),
              
              // Enhanced CTA button
              _buildEnhancedButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedButton(ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()
        ..translate(0.0, _isHovered ? -2.0 : 0.0) // Reduced from -3.0
        ..scale(_isHovered ? 1.02 : 1.0), // Reduced from 1.03
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryGold],
                )
              : LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _isHovered 
                ? Colors.white.withOpacity(0.15) // Reduced from 0.2
                : Colors.white.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2), // Reduced from 0.3
                    blurRadius: 10, // Reduced from 15
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.learnMore.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..translate(_isHovered ? 2.0 : 0.0, 0.0), // Reduced from 3.0
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_isHovered ? 0.12 : 0.08), // Reduced from 0.15
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.05), // Reduced from 0.1
                Colors.transparent,
              ],
              stops: [
                0.0,
                _shimmerController.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 🚀 VIRAL SERVICES SECTION 🚀
/// Eye-comfortable design with magnetic hover effects and smooth animations
/// Designed to captivate users and encourage engagement
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  int _hoveredIndex = -1;

  List<ServiceItem> get _services => [
    ServiceItem(
      titleKey: AppStrings.valueFootballTitle,
      imagePath: AppAssets.servicePeopleImage,
    ),
    ServiceItem(
      titleKey: AppStrings.valuePadelTitle,
      imagePath: AppAssets.servicePurposeImage,
    ),
    ServiceItem(
      titleKey: AppStrings.valueWellnessTitle,
      imagePath: AppAssets.servicePerformanceImage,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Container(
      width: double.infinity,
      decoration: _buildViralBackground(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSectionVertical + 20,
          horizontal: isMobile ? AppDimensions.paddingPageHorizontal : 80,
        ),
        child: Column(
          children: [
            _buildViralHeader(theme, isMobile),
            SizedBox(height: isMobile ? 50 : 80),
            _buildMagneticGrid(theme, isMobile),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  /// Build viral gradient background with floating particles
  BoxDecoration _buildViralBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: theme.brightness == Brightness.light
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.primary.withOpacity(0.02),
                AppColors.primaryGold.withOpacity(0.01),
                Colors.white,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkPageBackground,
                AppColors.darkSurface.withOpacity(0.3),
                AppColors.primary.withOpacity(0.05),
                AppColors.darkPageBackground,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
    );
  }

  /// Build viral header with magnetic attraction effect
  Widget _buildViralHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Floating badge with pulse effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (math.sin(_pulseController.value * 2 * math.pi) * 0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryGold.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryGold],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.valuesSectionBadge.tr(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).animate(delay: 200.ms)
         .fadeIn(duration: 1000.ms)
         .slideY(begin: -0.3, curve: Curves.easeOutCubic),

        const SizedBox(height: 32),

        // Magnetic title with gradient text
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryGold,
              AppColors.primary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            AppStrings.valuesSectionTitle.tr(),
            textAlign: TextAlign.center,
            style: (isMobile 
                ? theme.textTheme.displaySmall 
                : theme.textTheme.displayMedium)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
        ).animate(delay: 400.ms)
         .fadeIn(duration: 1200.ms)
         .slideY(begin: 0.2, curve: Curves.easeOutCubic),

        const SizedBox(height: 24),

        // Eye-comfortable subtitle
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            AppStrings.valuesSectionSubtitle.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.75),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ).animate(delay: 600.ms)
         .fadeIn(duration: 1000.ms)
         .slideY(begin: 0.2, curve: Curves.easeOutCubic),
      ],
    );
  }

  /// Build magnetic grid with hover effects
  Widget _buildMagneticGrid(ThemeData theme, bool isMobile) {
    if (isMobile) {
      return Column(
        children: _services.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: _buildMagneticCard(entry.value, entry.key, theme, true),
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _services.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMagneticCard(entry.value, entry.key, theme, false),
          ),
        );
      }).toList(),
    );
  }

  /// Build individual magnetic card with viral effects
  Widget _buildMagneticCard(ServiceItem service, int index, ThemeData theme, bool isMobile) {
    final isHovered = _hoveredIndex == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          // Floating effect with individual timing
          final floatOffset = math.sin((_floatingController.value * 2 * math.pi) + (index * 0.5)) * 6;
          
          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(isHovered ? 1.03 : 1.0) // Reduced from 1.08
                ..rotateX(isHovered ? -0.01 : 0.0) // Reduced from -0.02
                ..setEntry(3, 2, isHovered ? 0.0005 : 0.0), // Reduced perspective
              child: Container(
                height: isMobile ? 450 : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: isHovered 
                          ? AppColors.primary.withOpacity(0.1) // Reduced from 0.2
                          : Colors.black.withOpacity(0.05),
                      blurRadius: isHovered ? 15 : 10, // Reduced from 20
                      spreadRadius: isHovered ? 0 : -2,
                      offset: Offset(0, isHovered ? 8 : 5), // Reduced from 10
                    ),
                    if (isHovered)
                      BoxShadow(
                        color: AppColors.primaryGold.withOpacity(0.05), // Reduced from 0.1
                        blurRadius: 20, // Reduced from 30
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Dynamic background image
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0), // Reduced from 1.1
                        child: Image.asset(
                          service.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary.withOpacity(0.3),
                                    AppColors.primaryGold.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Magnetic overlay
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isHovered
                                ? [
                                    Colors.black.withOpacity(0.4), // Less transparent
                                    Colors.transparent,
                                    AppColors.primary.withOpacity(0.03), // More subtle
                                    Colors.black.withOpacity(0.65), // Less change
                                  ]
                                : [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                      
                      // Content with magnetic effects
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            /* TODO: Handle Card Tap */
                          },
                          splashColor: AppColors.primaryGold.withOpacity(0.1),
                          highlightColor: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Magnetic title with glow effect
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()..translate(0.0, isHovered ? -4.0 : 0.0), // Reduced from -8.0
                                  child: Container(
                                    decoration: isHovered
                                        ? BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.15), // Reduced from 0.3
                                                blurRadius: 10, // Reduced from 20
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          )
                                        : null,
                                    child: Text(
                                      service.titleKey.tr(),
                                      style: (isMobile 
                                          ? theme.textTheme.headlineMedium 
                                          : theme.textTheme.headlineLarge)?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            blurRadius: isHovered ? 10 : 8, // Reduced from 15
                                            color: Colors.black.withOpacity(isHovered ? 0.7 : 0.6), // Reduced from 0.8
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Magnetic CTA button
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  transform: Matrix4.identity()
                                    ..translate(0.0, isHovered ? -2.0 : 0.0) // Reduced from -4.0
                                    ..scale(isHovered ? 1.03 : 1.0), // Reduced from 1.05
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: isHovered
                                          ? LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.primaryGold,
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.6),
                                                Colors.black.withOpacity(0.4),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isHovered 
                                            ? Colors.white.withOpacity(0.2) // Reduced from 0.3
                                            : Colors.white.withOpacity(0.1),
                                        width: 1.5,
                                      ),
                                      boxShadow: isHovered
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary.withOpacity(0.2), // Reduced from 0.4
                                                blurRadius: 15, // Reduced from 20
                                                spreadRadius: 0,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppStrings.learnMore.tr(),
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          transform: Matrix4.identity()
                                            ..translate(isHovered ? 3.0 : 0.0, 0.0), // Reduced from 4.0
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(isHovered ? 0.15 : 0.1), // Reduced from 0.2
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate(delay: (800 + index * 200).ms)
     .fadeIn(duration: 1000.ms)
     .slideY(begin: 0.3, curve: Curves.easeOutCubic);
  }
}
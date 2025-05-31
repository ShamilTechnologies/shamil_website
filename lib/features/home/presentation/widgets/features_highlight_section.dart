// lib/features/home/presentation/widgets/features_highlight_section.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';

/// Modern, clean Features Highlight Section with smooth animations and better UX
/// Designed to be viral and engaging while being comfortable for users' eyes
class FeaturesHighlightSection extends StatefulWidget {
  final ScrollController scrollController;

  const FeaturesHighlightSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<FeaturesHighlightSection> createState() => _FeaturesHighlightSectionState();
}

class _FeaturesHighlightSectionState extends State<FeaturesHighlightSection>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  // Scroll Progress Tracking
  double _sectionScrollProgress = 0.0;
  final GlobalKey _sectionKey = GlobalKey();

  // Feature Data with Enhanced Information
  final List<FeatureCardData> _featuresData = [
    FeatureCardData(
      lottieAsset: AppAssets.bookingLottie,
      titleKey: AppStrings.featureBooking,
      description: "Book services instantly with our smart booking system that learns your preferences",
      icon: Icons.calendar_today_rounded,
      accentColor: const Color(0xFF4F46E5), // Indigo
      benefitText: "Save 70% time",
    ),
    FeatureCardData(
      lottieAsset: AppAssets.paymentLottie,
      titleKey: AppStrings.featurePayment,
      description: "Secure payments with multiple options and instant confirmation",
      icon: Icons.payment_rounded,
      accentColor: const Color(0xFF059669), // Emerald
      benefitText: "100% Secure",
    ),
    FeatureCardData(
      lottieAsset: AppAssets.dashboardLottie,
      titleKey: AppStrings.featureDashboard,
      description: "Comprehensive dashboard for service providers with real-time analytics",
      icon: Icons.dashboard_rounded,
      accentColor: const Color(0xFFDC2626), // Red
      benefitText: "Real-time data",
    ),
    FeatureCardData(
      lottieAsset: AppAssets.notificationLottie,
      titleKey: AppStrings.featureNotifications,
      description: "Smart notifications that keep you updated without overwhelming you",
      icon: Icons.notifications_active_rounded,
      accentColor: const Color(0xFFD97706), // Amber
      benefitText: "Smart alerts",
    ),
    FeatureCardData(
      lottieAsset: AppAssets.locationLottie,
      titleKey: AppStrings.featureLocation,
      description: "Find services near you with AI-powered location discovery",
      icon: Icons.location_on_rounded,
      accentColor: const Color(0xFF7C3AED), // Violet
      benefitText: "AI-powered",
    ),
    FeatureCardData(
      lottieAsset: AppAssets.performanceLottie,
      titleKey: AppStrings.featurePerformance,
      description: "Lightning-fast performance with 99.9% uptime reliability",
      icon: Icons.speed_rounded,
      accentColor: const Color(0xFF0891B2), // Cyan
      benefitText: "99.9% uptime",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    widget.scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  /// Initialize smooth animation controllers
  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Handle scroll-based animation progress
  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return;

    final RenderBox? sectionRenderBox = 
        _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (sectionRenderBox == null) return;

    final sectionOffset = sectionRenderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate smooth animation progress
    final scrollStartPoint = sectionOffset.dy - screenHeight * 0.8;
    final scrollEndPoint = sectionOffset.dy - screenHeight * 0.2;
    final currentScroll = widget.scrollController.offset;

    double progress = 0.0;
    if (currentScroll > scrollStartPoint && scrollEndPoint > scrollStartPoint) {
      progress = (currentScroll - scrollStartPoint) / (scrollEndPoint - scrollStartPoint);
    } else if (currentScroll >= scrollEndPoint) {
      progress = 1.0;
    }

    if (mounted) {
      setState(() {
        _sectionScrollProgress = math.min(1.0, math.max(0.0, progress));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      key: _sectionKey,
      decoration: _buildSectionBackground(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical + (isMobile ? 40 : 80),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                _buildSectionHeader(theme, isMobile),
                SizedBox(height: isMobile ? 50 : 80),
                _buildFeaturesGrid(theme, isMobile, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern gradient background
  BoxDecoration _buildSectionBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: theme.brightness == Brightness.light
            ? [
                const Color(0xFFFAFBFF),
                const Color(0xFFF8FAFC),
                const Color(0xFFFFFFFF),
              ]
            : [
                const Color(0xFF0F172A),
                const Color(0xFF1E293B),
                const Color(0xFF0F172A),
              ],
      ),
    );
  }

  /// Build engaging section header with statistics
  Widget _buildSectionHeader(ThemeData theme, bool isMobile) {
    return Animate(
      target: _sectionScrollProgress,
      effects: [
        FadeEffect(begin: 0.0, end: 1.0, duration: 600.ms),
        SlideEffect(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Column(
        children: [
          // Engaging badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Trusted by 10,000+ users",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Main title
          Text(
            AppStrings.featuresTitle.tr(),
            style: (isMobile 
                ? theme.textTheme.headlineLarge 
                : theme.textTheme.displaySmall)?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle with hook
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              "Discover game-changing features that will transform how you book and manage services forever.",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Build responsive grid layout
  Widget _buildFeaturesGrid(ThemeData theme, bool isMobile, bool isTablet) {
    final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final double spacing = isMobile ? 24 : 32;
    final double childAspectRatio = isMobile ? 1.1 : (isTablet ? 1.0 : 0.95);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _featuresData.length,
      itemBuilder: (context, index) {
        return _buildModernFeatureCard(
          theme,
          _featuresData[index],
          index,
          isMobile,
        );
      },
    );
  }

  /// Build modern, clean feature card with hover effects
  Widget _buildModernFeatureCard(
    ThemeData theme,
    FeatureCardData feature,
    int index,
    bool isMobile,
  ) {
    return Animate(
      target: _sectionScrollProgress,
      effects: [
        SlideEffect(
          begin: Offset(0, 0.3),
          end: Offset.zero,
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
        ),
        FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: Duration(milliseconds: 300 + (index * 100)),
        ),
      ],
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatingController, _pulseController]),
        builder: (context, child) {
          final floatOffset = math.sin(_floatingController.value * 2 * math.pi + index * 0.5) * 2;
          
          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: _ModernFeatureCard(
              feature: feature,
              theme: theme,
              pulseValue: _pulseController.value,
              isMobile: isMobile,
            ),
          );
        },
      ),
    );
  }
}

/// Enhanced feature card data model
class FeatureCardData {
  final String lottieAsset;
  final String titleKey;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String benefitText;

  const FeatureCardData({
    required this.lottieAsset,
    required this.titleKey,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.benefitText,
  });
}

/// Modern feature card widget with clean design
class _ModernFeatureCard extends StatefulWidget {
  final FeatureCardData feature;
  final ThemeData theme;
  final double pulseValue;
  final bool isMobile;

  const _ModernFeatureCard({
    required this.feature,
    required this.theme,
    required this.pulseValue,
    required this.isMobile,
  });

  @override
  State<_ModernFeatureCard> createState() => _ModernFeatureCardState();
}

class _ModernFeatureCardState extends State<_ModernFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered 
                ? widget.feature.accentColor.withOpacity(0.3)
                : widget.theme.colorScheme.outline.withOpacity(0.1),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.feature.accentColor.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.02 : 1.0),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and benefit badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.feature.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.feature.icon,
                      color: widget.feature.accentColor,
                      size: 28,
                    ),
                  ),
                  
                  // Benefit badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.feature.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.feature.benefitText,
                      style: widget.theme.textTheme.labelSmall?.copyWith(
                        color: widget.feature.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Title
              Text(
                widget.feature.titleKey.tr(),
                style: widget.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                widget.feature.description,
                style: widget.theme.textTheme.bodyMedium?.copyWith(
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Learn more link (appears on hover)
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        "Learn more",
                        style: widget.theme.textTheme.labelLarge?.copyWith(
                          color: widget.feature.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: widget.feature.accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
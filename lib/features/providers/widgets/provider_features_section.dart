import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProviderFeature {
  final String titleKey;
  final String descriptionKey;
  final List<String> benefitKeys;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final String animationAsset; // Lottie animation path

  const ProviderFeature({
    required this.titleKey,
    required this.descriptionKey,
    required this.benefitKeys,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.animationAsset,
  });
}

class ProviderFeaturesSection extends StatefulWidget {
  final ScrollController scrollController;

  const ProviderFeaturesSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<ProviderFeaturesSection> createState() => _ProviderFeaturesSectionState();
}

class _ProviderFeaturesSectionState extends State<ProviderFeaturesSection>
    with TickerProviderStateMixin {
  
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  double _scrollProgress = 0.0;
  final GlobalKey _sectionKey = GlobalKey();

  final List<ProviderFeature> _features = [
    ProviderFeature(
      titleKey: ProviderStrings.featureSmartBookingTitle,
      descriptionKey: ProviderStrings.featureSmartBookingDesc,
      benefitKeys: [
        ProviderStrings.featureSmartBookingBenefit1,
        ProviderStrings.featureSmartBookingBenefit2,
        ProviderStrings.featureSmartBookingBenefit3,
      ],
      icon: Icons.calendar_today_rounded,
      gradientStart: AppColors.primary,
      gradientEnd: AppColors.accent,
      animationAsset: 'assets/lottie/booking_anim.json',
    ),
    ProviderFeature(
      titleKey: ProviderStrings.featureSubscriptionManagementTitle,
      descriptionKey: ProviderStrings.featureSubscriptionManagementDesc,
      benefitKeys: [
        ProviderStrings.featureSubscriptionManagementBenefit1,
        ProviderStrings.featureSubscriptionManagementBenefit2,
        ProviderStrings.featureSubscriptionManagementBenefit3,
      ],
      icon: Icons.autorenew_rounded,
      gradientStart: AppColors.primaryGold,
      gradientEnd: AppColors.primaryGoldLight,
      animationAsset: 'assets/lottie/subscription_anim.json',
    ),
    ProviderFeature(
      titleKey: ProviderStrings.featureNfcQrAccessTitle,
      descriptionKey: ProviderStrings.featureNfcQrAccessDesc,
      benefitKeys: [
        ProviderStrings.featureNfcQrAccessBenefit1,
        ProviderStrings.featureNfcQrAccessBenefit2,
        ProviderStrings.featureNfcQrAccessBenefit3,
      ],
      icon: Icons.qr_code_2_rounded,
      gradientStart: const Color(0xFF6C63FF),
      gradientEnd: const Color(0xFF4CAF50),
      animationAsset: 'assets/lottie/nfc_anim.json',
    ),
    ProviderFeature(
      titleKey: ProviderStrings.featureAdvancedAnalyticsTitle,
      descriptionKey: ProviderStrings.featureAdvancedAnalyticsDesc,
      benefitKeys: [
        ProviderStrings.featureAdvancedAnalyticsBenefit1,
        ProviderStrings.featureAdvancedAnalyticsBenefit2,
        ProviderStrings.featureAdvancedAnalyticsBenefit3,
      ],
      icon: Icons.analytics_rounded,
      gradientStart: const Color(0xFFFF6B6B),
      gradientEnd: const Color(0xFFFFE66D),
      animationAsset: 'assets/lottie/analytics_anim.json',
    ),
    ProviderFeature(
      titleKey: ProviderStrings.featureCustomerManagementTitle,
      descriptionKey: ProviderStrings.featureCustomerManagementDesc,
      benefitKeys: [
        ProviderStrings.featureCustomerManagementBenefit1,
        ProviderStrings.featureCustomerManagementBenefit2,
        ProviderStrings.featureCustomerManagementBenefit3,
      ],
      icon: Icons.people_alt_rounded,
      gradientStart: const Color(0xFF667EEA),
      gradientEnd: const Color(0xFF764BA2),
      animationAsset: 'assets/lottie/customer_anim.json',
    ),
    ProviderFeature(
      titleKey: ProviderStrings.featureCloudSyncTitle,
      descriptionKey: ProviderStrings.featureCloudSyncDesc,
      benefitKeys: [
        ProviderStrings.featureCloudSyncBenefit1,
        ProviderStrings.featureCloudSyncBenefit2,
        ProviderStrings.featureCloudSyncBenefit3,
      ],
      icon: Icons.cloud_sync_rounded,
      gradientStart: const Color(0xFF11998E),
      gradientEnd: const Color(0xFF38EF7D),
      animationAsset: 'assets/lottie/cloud_anim.json',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _setupScrollListener() {
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return;

    final RenderBox? sectionRenderBox = 
        _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (sectionRenderBox == null) return;

    final sectionOffset = sectionRenderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final scrollStartPoint = sectionOffset.dy - screenHeight * 0.8;
    final scrollEndPoint = sectionOffset.dy - screenHeight * 0.2;
    final currentScroll = widget.scrollController.offset;

    double progress = 0.0;
    if (currentScroll > scrollStartPoint && scrollEndPoint > scrollStartPoint) {
      progress = (currentScroll - scrollStartPoint) / (scrollEndPoint - scrollStartPoint);
    } else if (currentScroll >= scrollEndPoint) {
      progress = 1.0;
    }

    setState(() {
      _scrollProgress = progress.clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return Container(
      key: _sectionKey,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: _buildSectionBackground(theme),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              _buildSectionHeader(theme, isMobile),
              SizedBox(height: isMobile ? 60 : 80),
              _buildFeaturesGrid(theme, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildSectionBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: theme.brightness == Brightness.light
            ? [
                theme.colorScheme.surface,
                theme.colorScheme.primary.withOpacity(0.02),
                theme.colorScheme.surface,
              ]
            : [
                theme.colorScheme.surface,
                theme.colorScheme.primary.withOpacity(0.05),
                theme.colorScheme.surface,
              ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Animated badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primaryGold.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .scale(duration: 1500.ms)
               .then()
               .scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0)),
              const SizedBox(width: 12),
              Text(
                "🚀 Powerful Features",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate()
         .fadeIn(delay: 200.ms, duration: 600.ms)
         .slideY(begin: -0.2),

        const SizedBox(height: 24),

        // Main title
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
            ProviderStrings.featuresSectionTitle.tr(),
            style: (isMobile 
                ? theme.textTheme.headlineLarge 
                : theme.textTheme.displaySmall)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate()
         .fadeIn(delay: 400.ms, duration: 800.ms)
         .slideY(begin: 0.2),

        const SizedBox(height: 20),

        // Subtitle
        Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            ProviderStrings.featuresSectionSubtitle.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate()
         .fadeIn(delay: 600.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildFeaturesGrid(ThemeData theme, bool isMobile, bool isTablet) {
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: isMobile ? 1.2 : 1.0,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(
          feature: _features[index],
          index: index,
          scrollProgress: _scrollProgress,
          floatingController: _floatingController,
        );
      },
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final ProviderFeature feature;
  final int index;
  final double scrollProgress;
  final AnimationController floatingController;

  const _FeatureCard({
    required this.feature,
    required this.index,
    required this.scrollProgress,
    required this.floatingController,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delay = widget.index * 100;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedBuilder(
          animation: widget.floatingController,
          builder: (context, child) {
            final floatOffset = math.sin(
              widget.floatingController.value * 2 * math.pi + widget.index * 0.5
            ) * 4;

            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_isHovered ? -0.02 : 0)
                  ..rotateY(_isHovered ? 0.02 : 0)
                  ..scale(_isHovered ? 1.03 : 1.0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.feature.gradientStart.withOpacity(0.9),
                      widget.feature.gradientEnd.withOpacity(0.9),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.feature.gradientStart.withOpacity(_isHovered ? 0.4 : 0.2),
                      blurRadius: _isHovered ? 30 : 20,
                      spreadRadius: _isHovered ? 2 : 0,
                      offset: Offset(0, _isHovered ? 12 : 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        right: -50,
                        bottom: -50,
                        child: Icon(
                          widget.feature.icon,
                          size: 200,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                widget.feature.icon,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Title
                            Text(
                              widget.feature.titleKey.tr(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Description
                            Text(
                              widget.feature.descriptionKey.tr(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                              maxLines: _isExpanded ? null : 3,
                              overflow: _isExpanded ? null : TextOverflow.ellipsis,
                            ),
                            
                            const Spacer(),
                            
                            // Benefits (shown on hover or expanded)
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: (_isHovered || _isExpanded)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        ...widget.feature.benefitKeys.map((benefitKey) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  benefitKey.tr(),
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            
                            // Learn more indicator
                            if (_isHovered)
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    Text(
                                      _isExpanded ? "Tap to collapse" : "Tap to learn more",
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).animate(
          target: widget.scrollProgress,
          delay: Duration(milliseconds: delay),
        )
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, curve: Curves.easeOutCubic),
      ),
    );
  }
}
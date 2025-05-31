// lib/features/home/presentation/widgets/benefits_section.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 🌟 OPTIMIZED BENEFITS SECTION 🌟
/// Performance-optimized with reduced animations and better memory management
class BenefitsSection extends StatefulWidget {
  const BenefitsSection({super.key});

  @override
  State<BenefitsSection> createState() => _BenefitsSectionState();
}

class _BenefitsSectionState extends State<BenefitsSection>
    with TickerProviderStateMixin {
  // 🎭 Optimized Animation Controllers - Reduced from 3 to 2
  late AnimationController _floatingController;
  late AnimationController _typewriterController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _setupOptimizedAnimations();
  }

  /// 🔧 Setup lightweight animations
  void _setupOptimizedAnimations() {
    // Slower, less frequent floating animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 12), // Slower = less CPU
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -5.0, // Reduced movement
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOutSine,
    ));

    // Simplified typewriter effect
    _typewriterController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Start typewriter with delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _typewriterController.forward();
      }
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return Container(
      decoration: _buildSimpleBackground(theme),
      child: _buildMainContent(theme, isMobile, isTablet),
    );
  }

  /// 🎨 Simplified gradient background - No particles for performance
  BoxDecoration _buildSimpleBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: theme.brightness == Brightness.light
            ? [
                AppColors.lightPageBackground,
                AppColors.primary.withOpacity(0.03),
                AppColors.lightPageBackground,
              ]
            : [
                AppColors.darkPageBackground,
                AppColors.accent.withOpacity(0.05),
                AppColors.darkPageBackground,
              ],
      ),
    );
  }

  /// 📱 Optimized main content
  Widget _buildMainContent(ThemeData theme, bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
        vertical: isMobile ? 60 : 80, // Reduced padding
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400), // Reduced max width
          child: Column(
            children: [
              // 📝 Simple section header
              _buildSimpleHeader(theme, isMobile),
              
              SizedBox(height: isMobile ? 60 : 80), // Reduced spacing
              
              // 🎴 Optimized flip cards with minimal floating
              _buildOptimizedFlipCards(theme, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  /// 📝 Simplified header with minimal animations
  Widget _buildSimpleHeader(ThemeData theme, bool isMobile) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Column(
      children: [
        // 🏷️ Simple title
        Text(
          AppStrings.whyChooseShamil.tr(),
          style: (isMobile 
              ? theme.textTheme.headlineLarge
              : theme.textTheme.displaySmall)?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: isRTL ? 0 : -0.5,
            height: isRTL ? 1.3 : 1.2,
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: -0.2, duration: 600.ms),

        const SizedBox(height: 24),

        // 📝 Optimized typewriter
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedBuilder(
            animation: _typewriterController,
            builder: (context, child) {
              const fullText = 'Experience seamless service booking with our innovative platform.';
              final displayedLength = (fullText.length * _typewriterController.value).round();
              final displayedText = fullText.substring(0, displayedLength);
              
              return Text(
                displayedText,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: isRTL ? 1.5 : 1.4,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 🎴 Optimized flip cards with minimal floating
  Widget _buildOptimizedFlipCards(ThemeData theme, bool isMobile, bool isTablet) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5), // Reduced floating
          child: ResponsiveRowColumn(
            layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowSpacing: isMobile ? 30 : 40, // Reduced spacing
            columnSpacing: isTablet ? 30 : 60,
            children: [
              // 👤 Users Card
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: OptimizedFlipCard(
                  theme: theme,
                  cardData: _getUsersCardData(),
                  delay: 400.ms,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
              
              // 🏢 Providers Card
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: OptimizedFlipCard(
                  theme: theme,
                  cardData: _getProvidersCardData(),
                  delay: 600.ms,
                  isMobile: isMobile,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 👤 Users card data
  SimpleCardData _getUsersCardData() {
    return SimpleCardData(
      title: AppStrings.forUsersTitle.tr(),
      frontIcon: Icons.person_outline_rounded,
      backIcon: Icons.star_outline_rounded,
      primaryColor: AppColors.primary,
      benefits: [
        '⚡ Lightning-fast booking',
        '🛡️ Bank-level security',
        '🎯 Smart recommendations',
        '🌍 Available worldwide',
      ],
      frontDescription: 'Perfect for Users',
      backDescription: 'Book services effortlessly with our user-friendly platform.',
    );
  }

  /// 🏢 Providers card data
  SimpleCardData _getProvidersCardData() {
    return SimpleCardData(
      title: AppStrings.forProvidersTitle.tr(),
      frontIcon: Icons.business_center_outlined,
      backIcon: Icons.trending_up_rounded,
      primaryColor: AppColors.primaryGold,
      benefits: [
        '🤖 Automated management',
        '📊 Analytics dashboard',
        '💰 Increase revenue',
        '🚀 Expand customer base',
      ],
      frontDescription: 'Grow Your Business',
      backDescription: 'Manage your services efficiently with our comprehensive tools.',
    );
  }
}

/// 📊 Card data model (unchanged)
class SimpleCardData {
  final String title;
  final IconData frontIcon;
  final IconData backIcon;
  final Color primaryColor;
  final List<String> benefits;
  final String frontDescription;
  final String backDescription;

  SimpleCardData({
    required this.title,
    required this.frontIcon,
    required this.backIcon,
    required this.primaryColor,
    required this.benefits,
    required this.frontDescription,
    required this.backDescription,
  });
}

/// 🎴 Optimized flip card with better performance
class OptimizedFlipCard extends StatefulWidget {
  final ThemeData theme;
  final SimpleCardData cardData;
  final Duration delay;
  final bool isMobile;
  final bool isTablet;

  const OptimizedFlipCard({
    super.key,
    required this.theme,
    required this.cardData,
    required this.delay,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<OptimizedFlipCard> createState() => _OptimizedFlipCardState();
}

class _OptimizedFlipCardState extends State<OptimizedFlipCard>
    with TickerProviderStateMixin {
  // 🎭 Reduced animation controllers
  late AnimationController _flipController;
  late AnimationController _hoverController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  
  // 🏷️ State variables
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _setupOptimizedAnimations();
  }

  /// 🔧 Setup lightweight animations
  void _setupOptimizedAnimations() {
    // Faster flip animation
    _flipController = AnimationController(
      duration: Duration(milliseconds: widget.isMobile ? 600 : 500),
      vsync: this,
    );

    // Lighter hover animation
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Smooth flip
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutQuart, // Lighter curve
    ));

    // Subtle scale
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.isMobile ? 1.02 : 1.03, // Reduced scale
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  /// 🎯 Handle card tap
  void _handleTap() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  /// 🖱️ Handle hover
  void _handleHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    // 📏 Fixed sizing
    final cardHeight = widget.isMobile ? 320.0 : (widget.isTablet ? 360.0 : 400.0);

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_flipAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                height: cardHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    // 🎨 Front card
                    if (_flipAnimation.value <= 0.5)
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_flipAnimation.value * math.pi),
                        alignment: Alignment.center,
                        child: _buildSimpleFrontCard(cardHeight, isRTL),
                      ),
                    
                    // 🎨 Back card
                    if (_flipAnimation.value > 0.5)
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY((_flipAnimation.value - 1) * math.pi),
                        alignment: Alignment.center,
                        child: _buildSimpleBackCard(cardHeight, isRTL),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    )
    .animate()
    .fadeIn(delay: widget.delay, duration: 800.ms)
    .slideY(begin: 0.2, duration: 800.ms);
  }

  /// 🎨 Simplified front card
  Widget _buildSimpleFrontCard(double cardHeight, bool isRTL) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.theme.colorScheme.surface.withOpacity(0.9),
        border: Border.all(
          color: widget.cardData.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.cardData.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🎯 Simple icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.cardData.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: widget.cardData.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              widget.cardData.frontIcon,
              size: 28,
              color: widget.cardData.primaryColor,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 🏷️ Title
          Text(
            widget.cardData.title,
            style: widget.theme.textTheme.headlineSmall?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // 📝 Description
          Text(
            widget.cardData.frontDescription,
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.cardData.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 20),
          
          // 👆 Tap indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.cardData.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: widget.cardData.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 16,
                  color: widget.cardData.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tap to explore',
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    color: widget.cardData.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 Simplified back card
  Widget _buildSimpleBackCard(double cardHeight, bool isRTL) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.theme.colorScheme.surface.withOpacity(0.9),
        border: Border.all(
          color: widget.cardData.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.cardData.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.cardData.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  widget.cardData.backIcon,
                  color: widget.cardData.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.cardData.title,
                  style: widget.theme.textTheme.titleLarge?.copyWith(
                    color: widget.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 📝 Description
          Text(
            widget.cardData.backDescription,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 20),
          
          // 📋 Benefits list
          Expanded(
            child: Column(
              children: widget.cardData.benefits.take(4).map((benefit) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.cardData.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: widget.theme.textTheme.bodySmall?.copyWith(
                            color: widget.theme.colorScheme.onSurface.withOpacity(0.8),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
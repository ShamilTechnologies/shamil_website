import 'dart:math' as math;
import 'dart:ui' as ui; // Added this import for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material; // 🎨 Alias for material widgets
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/features/home/data/models/testimonial_model.dart';

// 🌟 MAIN TESTIMONIALS SECTION - The star of the show!
class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  // 📊 Data Management
  final List<TestimonialModel> _testimonials = [
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoTechNova,
      companyNameKey: AppStrings.testimonial1CompanyName,
      testimonialTextKey: AppStrings.testimonial1Text,
      userAvatarAsset: AppAssets.userAvatarBen,
      userNameKey: AppStrings.testimonial1UserName,
      userTitleKey: AppStrings.testimonial1UserTitle,
    ),
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoShopify,
      companyNameKey: AppStrings.testimonial2CompanyName,
      testimonialTextKey: AppStrings.testimonial2Text,
      userAvatarAsset: AppAssets.userAvatarMichael,
      userNameKey: AppStrings.testimonial2UserName,
      userTitleKey: AppStrings.testimonial2UserTitle,
    ),
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoApex,
      companyNameKey: AppStrings.testimonial3CompanyName,
      testimonialTextKey: AppStrings.testimonial3Text,
      userAvatarAsset: AppAssets.userAvatarRavi,
      userNameKey: AppStrings.testimonial3UserName,
      userTitleKey: AppStrings.testimonial3UserTitle,
    ),
  ];

  // 🎮 Controllers & Animation State
  late PageController _pageController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    
    // 📱 Initialize page controller with smooth viewport
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.82, // Perfect balance for card visibility
    );

    // 🎭 Floating animation for cards (gentle up-down motion)
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // 💓 Pulse animation for active indicators
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // 🎯 Navigation Methods
  void _nextPage() {
    final nextPage = (_currentPage + 1) % _testimonials.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _previousPage() {
    final prevPage = _currentPage == 0 ? _testimonials.length - 1 : _currentPage - 1;
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(material.BuildContext context) {
    final material.ThemeData theme = material.Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final material.TextDirection textDirection = material.Directionality.of(context);
    final bool isRtl = textDirection == material.TextDirection.rtl;

    // 🎨 Dynamic colors based on theme (not used further down, consider removing if not needed)
    // final Color primaryGlow = theme.colorScheme.primary.withOpacity(0.3);
    // final Color secondaryGlow = theme.colorScheme.secondary.withOpacity(0.4);
    // final Color backgroundOverlay = isDark 
    //     ? Colors.black.withOpacity(0.4) 
    //     : Colors.white.withOpacity(0.7);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // 🌈 Stunning gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withOpacity(0.8),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal * 0.5,
          vertical: AppDimensions.paddingSectionVertical + 30,
        ),
        child: Column(
          children: [
            // 🏆 Section Title with Animated Underline
            _buildSectionHeader(theme, isDark),
            
            const SizedBox(height: 50),
            
            // 🎠 Main Testimonials Carousel
            _buildTestimonialsCarousel(theme, isDark, isRtl),
            
            const SizedBox(height: 30),
            
            // 🔘 Custom Page Indicators
            _buildPageIndicators(theme, isDark),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🏆 Beautiful Section Header
  Widget _buildSectionHeader(material.ThemeData theme, bool isDark) {
    return Column(
      children: [
        // ✨ Animated title with glow effect
        material.Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
          child: Text(
            AppStrings.testimonialsTitle.tr(),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 2000.ms,
          color: theme.colorScheme.secondary.withOpacity(0.4),
        )
        .animate() // Chain a new animation for entry
        .fadeIn(delay: 200.ms, duration: 800.ms)
        .slideY(begin: -0.2, duration: 800.ms, curve: Curves.easeOutBack),
        
        const SizedBox(height: 15),
        
        // 🌟 Decorative underline
        material.Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
        )
        .animate(delay: 400.ms)
        .scaleX(begin: 0, duration: 600.ms, curve: Curves.easeOutBack),
      ],
    );
  }

  // 🎠 Main Testimonials Carousel
  Widget _buildTestimonialsCarousel(material.ThemeData theme, bool isDark, bool isRtl) {
    return SizedBox(
      height: 480, // Optimized height for content
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Allows nav arrows to be slightly outside if needed
        children: [
          // 🌌 Background glow effects
          _buildBackgroundGlow(theme),
          
          // 📱 Main PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _testimonials.length,
            onPageChanged: (page) {
              if (mounted) {
                setState(() => _currentPage = page);
              }
            },
            itemBuilder: (context, index) {
              final testimonial = _testimonials[index];
              final isActive = index == _currentPage;
              
              // 📏 Scale calculation for 3D effect
              final scale = isActive ? 1.0 : 0.85;
              final opacity = isActive ? 1.0 : 0.7;
              
              return Transform.scale( // Animated scale
                scale: scale,
                child: Opacity( // Animated opacity
                  opacity: opacity,
                  child: _buildTestimonialCard(
                    context, 
                    theme, 
                    testimonial, 
                    isActive, 
                    isDark,
                  ),
                ),
              );
            },
          ),
          
          // ⬅️ Navigation Arrows
          _buildNavigationArrows(theme, isRtl),
        ],
      ),
    );
  }

  // 🌌 Beautiful background glow effects
  Widget _buildBackgroundGlow(material.ThemeData theme) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Stack(
            children: [
              // 🔵 Primary glow (left side)
              Positioned(
                left: -50,
                top: 100 + (_floatingController.value * 30),
                child: material.Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // 🟡 Secondary glow (right side)
              Positioned(
                right: -50,
                bottom: 100 - (_floatingController.value * 30),
                child: material.Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.secondary.withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 💎 Stunning Testimonial Card
  Widget _buildTestimonialCard(
    material.BuildContext context,
    material.ThemeData theme,
    TestimonialModel testimonial,
    bool isActive,
    bool isDark,
  ) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final floatOffset = isActive ? _floatingController.value * 8 : 0.0; // Only active card floats more
        
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: material.Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Card spacing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              // 🌈 Glass morphism effect
              color: isDark 
                  ? Colors.white.withOpacity(0.08) // Dark theme glass color
                  : Colors.white.withOpacity(0.9), // Light theme glass color
              border: Border.all(
                color: isActive 
                    ? theme.colorScheme.primary.withOpacity(0.3) // Active card border
                    : Colors.white.withOpacity(0.1), // Inactive card border
                width: 1.5,
              ),
              boxShadow: [
                // 💫 Main shadow
                BoxShadow(
                  color: isDark 
                      ? Colors.black.withOpacity(0.3)
                      : theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: isActive ? 25 : 15,
                  spreadRadius: isActive ? 2 : 0,
                  offset: Offset(0, isActive ? 15 : 8),
                ),
                // ✨ Inner glow for active card
                if (isActive)
                  BoxShadow(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: -5, // Negative spread pulls shadow inwards
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
            child: material.ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: material.BackdropFilter( // The widget using ImageFilter
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10), // CORRECTED
                child: _buildCardContent(context, theme, testimonial, isActive),
              ),
            ),
          ),
        );
      },
    );
  }

  // 📝 Card Content Layout
  Widget _buildCardContent(
    material.BuildContext context,
    material.ThemeData theme,
    TestimonialModel testimonial,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏢 Company Header
          _buildCompanyHeader(theme, testimonial),
          
          const SizedBox(height: 24),
          
          // 💬 Quote with beautiful styling
          _buildQuoteSection(theme, testimonial, isActive),
          
          const Spacer(), // Pushes user info to the bottom
          
          // 👤 User Info with enhanced design
          _buildUserInfo(theme, testimonial),
        ],
      ),
    );
  }

  // 🏢 Company Header with Logo
  Widget _buildCompanyHeader(material.ThemeData theme, TestimonialModel testimonial) {
    return Row(
      children: [
        // 🖼️ Company Logo with glow
        material.Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.primary.withOpacity(0.1),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Image.asset(
            testimonial.companyLogoAsset,
            height: 28,
            width: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => material.Icon(
              material.Icons.business_rounded,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 🏷️ Company Name
        Expanded(
          child: Text(
            testimonial.companyNameKey.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // ⭐ Decorative stars
        ...List.generate(5, (index) => 
          material.Icon(
            material.Icons.star_rounded,
            size: 16,
            color: theme.colorScheme.secondary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // 💬 Beautiful Quote Section
  Widget _buildQuoteSection(
    material.ThemeData theme, 
    TestimonialModel testimonial, 
    bool isActive,
  ) {
    return material.Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface.withOpacity(0.5), // Semi-transparent surface
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1), // Subtle border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📝 Quote Icon
          material.Icon(
            material.Icons.format_quote_rounded,
            size: 32,
            color: theme.colorScheme.secondary,
          ),
          
          const SizedBox(height: 12),
          
          // 💭 Testimonial Text
          Text(
            testimonial.testimonialTextKey.tr(),
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 6, // Limit lines to keep card height consistent
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // 👤 Enhanced User Info Section
  Widget _buildUserInfo(material.ThemeData theme, TestimonialModel testimonial) {
    return Row(
      children: [
        // 🖼️ User Avatar with ring
        material.Container(
          padding: const EdgeInsets.all(3), // Space for gradient border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient( // Decorative ring
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.surface, // Fallback background
            backgroundImage: AssetImage(testimonial.userAvatarAsset),
            onBackgroundImageError: (_, __) {}, // Handle image load error
            child: AssetImage(testimonial.userAvatarAsset).assetName.isEmpty // Fallback icon
                ? material.Icon(
                    material.Icons.person_rounded,
                    size: 24,
                    color: theme.colorScheme.onSurface,
                  )
                : null,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 📋 User Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                testimonial.userNameKey.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                testimonial.userTitleKey.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        // ✅ Verified Badge
        material.Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.secondary.withOpacity(0.1),
            border: Border.all(
              color: theme.colorScheme.secondary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              material.Icon(
                material.Icons.verified_rounded,
                size: 14,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Verified', // This could also be from AppStrings if needed
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ⬅️➡️ Navigation Arrows
  Widget _buildNavigationArrows(material.ThemeData theme, bool isRtl) {
    // Determine icons based on text direction
    final leftIcon = isRtl ? material.Icons.arrow_forward_ios_rounded : material.Icons.arrow_back_ios_rounded;
    final rightIcon = isRtl ? material.Icons.arrow_back_ios_rounded : material.Icons.arrow_forward_ios_rounded;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ⬅️ Previous Button
        _buildNavButton(
          theme,
          leftIcon,
          _previousPage,
          Alignment.centerLeft, // Not strictly needed for Row's spaceBetween
        ),
        
        // ➡️ Next Button  
        _buildNavButton(
          theme,
          rightIcon,
          _nextPage,
          Alignment.centerRight, // Not strictly needed for Row's spaceBetween
        ),
      ],
    );
  }

  // 🔘 Navigation Button
  Widget _buildNavButton(
    material.ThemeData theme,
    material.IconData icon,
    VoidCallback onTap,
    Alignment alignment, // alignment parameter is not used if Row is spaceBetween
  ) {
    return material.Material( // For InkWell splash effect
      color: Colors.transparent,
      child: material.InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30), // For circular splash
        child: material.Container(
          width: 56, // Standard touch target size
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface.withOpacity(0.9), // Slightly transparent
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2), // Subtle border
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: material.Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
      ),
    );
  }

  // 🔘 Custom Page Indicators
  Widget _buildPageIndicators(material.ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _testimonials.length,
        (index) => AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final isActive = index == _currentPage;
            final pulseValue = isActive ? _pulseController.value : 0.0; // Pulse only if active
            
            return material.Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: material.GestureDetector(
                onTap: () => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                ),
                child: material.Container(
                  width: isActive ? 32 : 12, // Active indicator is wider
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: isActive 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.3),
                    boxShadow: isActive ? [ // Glow effect for active indicator
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4 + pulseValue * 0.3),
                        blurRadius: 8 + pulseValue * 4,
                        spreadRadius: pulseValue * 2,
                      ),
                    ] : null,
                  ),
                ),
              ),
            )
            .animate(target: isActive ? 1 : 0) // Animate based on active state
            .scaleXY(end: isActive ? 1.1 : 1.0, duration: 200.ms); // Subtle scale for active
          },
        ),
      ),
    );
  }
}
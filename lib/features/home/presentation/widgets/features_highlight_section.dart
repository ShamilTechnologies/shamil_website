import 'dart:math' as math;
import 'dart:ui'; // For ImageFilter if you decide to bring back glassmorphism later
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
// import 'package:shamil_web/core/widgets/animated_fade_in.dart'; // Using flutter_animate directly

class FeaturesHighlightSection extends StatefulWidget {
  final ScrollController scrollController;

  const FeaturesHighlightSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<FeaturesHighlightSection> createState() => _FeaturesHighlightSectionState();
}

class _FeaturesHighlightSectionState extends State<FeaturesHighlightSection> {
  // _sectionScrollProgress: Tracks how much of this section is visible or
  // how far it has scrolled into view. Ranges from 0.0 to 1.0.
  double _sectionScrollProgress = 0.0;
  final GlobalKey _sectionKey = GlobalKey();

  // Data for feature items: Lottie asset path and title key
  final List<Map<String, String>> _featureItemsData = [
    {'lottie': AppAssets.bookingLottie, 'title': AppStrings.featureBooking},
    {'lottie': AppAssets.paymentLottie, 'title': AppStrings.featurePayment},
    {'lottie': AppAssets.dashboardLottie, 'title': AppStrings.featureDashboard},
    {'lottie': AppAssets.notificationLottie, 'title': AppStrings.featureNotifications},
    {'lottie': AppAssets.locationLottie, 'title': AppStrings.featureLocation},
    {'lottie': AppAssets.performanceLottie, 'title': AppStrings.featurePerformance},
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    // Initial check in case the section is already visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) _onScroll();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return;

    final RenderBox? sectionRenderBox = _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (sectionRenderBox == null) return;

    final sectionOffset = sectionRenderBox.localToGlobal(Offset.zero);
    final sectionHeight = sectionRenderBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    // When the top of the section is at the bottom of the screen, progress is 0.
    // When the top of the section is at the top of the screen, progress is 1.
    // This makes items animate as the section itself scrolls into full view.
    // Adjust the effective scroll range (screenHeight - sectionHeight / N) to change sensitivity.
    // A smaller divisor for sectionHeight makes the animation complete faster.
    final scrollStartPoint = sectionOffset.dy - screenHeight;
    final scrollEndPoint = sectionOffset.dy - (screenHeight * 0.2); // Animation completes when 20% from top

    final currentScroll = widget.scrollController.offset;
    double progress = 0.0;

    if (currentScroll > scrollStartPoint && scrollEndPoint > scrollStartPoint) {
      progress = (currentScroll - scrollStartPoint) / (scrollEndPoint - scrollStartPoint);
    } else if (currentScroll <= scrollStartPoint) {
      progress = 0.0;
    } else if (currentScroll >= scrollEndPoint) {
      progress = 1.0;
    }

    setState(() {
      _sectionScrollProgress = math.min(1.0, math.max(0.0, progress));
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      key: _sectionKey, // Key to get section's position
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical + 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background, // Use theme background
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // Max width for the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.featuresTitle.tr(),
                style: theme.textTheme.displaySmall, // Theme-aware text style
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms, duration: 500.ms), // Title entrance animation

              const SizedBox(height: AppDimensions.spacingExtraLarge + 20),

              // Wrap widget to arrange feature items.
              // The items will animate into their natural positions within this Wrap.
              Wrap(
                spacing: AppDimensions.paddingLarge + 15, // Horizontal space between items
                runSpacing: AppDimensions.paddingLarge + 15, // Vertical space between lines of items
                alignment: WrapAlignment.center, // Center items if they don't fill the row
                children: List.generate(_featureItemsData.length, (index) {
                  // Determine animation direction based on index
                  bool animateFromLeft = index % 2 == 0;
                  // Define a list of base colors from the theme
                  // Ensure your theme's ColorScheme has primary, secondary, and tertiary defined.
                  final List<Color> baseCardColors = [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    theme.colorScheme.tertiary, // Make sure this is defined in your ColorScheme
                    theme.colorScheme.primaryContainer, // Example, add more distinct colors
                    theme.colorScheme.secondaryContainer,
                    theme.colorScheme.tertiaryContainer,
                  ];
                  // Cycle through the base colors
                  Color cardColor = baseCardColors[index % baseCardColors.length];

                  return _buildFeatureItem(
                    context,
                    theme: theme,
                    lottieAsset: _featureItemsData[index]['lottie']!,
                    titleKey: _featureItemsData[index]['title']!,
                    cardColor: cardColor.withOpacity(0.75), // Apply transparency
                    animateFromLeft: animateFromLeft,
                    animationTarget: _sectionScrollProgress, // Pass scroll progress to drive animation
                    staggerDelay: (150 * index).ms, // Stagger animation start for each item
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each individual feature item
  Widget _buildFeatureItem(
    BuildContext context, {
    required ThemeData theme,
    required String lottieAsset,
    required String titleKey,
    required Color cardColor, // Base color for the card with transparency
    required bool animateFromLeft,
    required double animationTarget, // Current scroll progress (0.0 to 1.0)
    required Duration staggerDelay,
  }) {
    // Initial horizontal offset for the slide animation
    final double initialHorizontalOffset = animateFromLeft ? -0.5 : 0.5; // -0.5 for left, 0.5 for right (as fraction of width)

    return Animate(
      target: animationTarget, // Drives the animation from begin to end based on this value
      delay: staggerDelay, // Stagger the start of each item's animation
      effects: [
        // Slide in horizontally. 'begin' is the starting offset (fraction of width).
        // 'end' is 0 (final position).
        SlideEffect(
          begin: Offset(initialHorizontalOffset, 0),
          end: Offset.zero,
          duration: 800.ms, // Duration of the slide animation
          curve: Curves.easeOutCubic, // Smooth easing curve
        ),
        // Fade in as it slides
        FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: 700.ms, // Slightly shorter fade duration
          curve: Curves.easeOut,
        ),
      ],
      child: Container(
        width: 230, // Width of each feature card
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: cardColor, // Theme-aware semi-transparent color
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge), // Rounded corners
          boxShadow: [ // Subtle shadow for a floating effect
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            Lottie.asset(
              lottieAsset,
              height: 80, // Lottie animation height
              width: 80,  // Lottie animation width
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Text(
              titleKey.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                // Text color needs to contrast with the semi-transparent cardColor.
                // Using onSurface is a safe bet, or you can define onPrimary, onSecondary, onTertiary
                // if your cardColors are directly from theme.colorScheme.
                color: theme.colorScheme.onSurface, // Adjust if needed for specific card colors
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async'; // Import async library for Timer
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
// import 'package:shamil_web/core/constants/app_colors.dart'; // Use theme colors
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart'; // Import foundation for kDebugMode

// Convert to StatefulWidget
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  // List of banner images
  final List<String> _bannerImages = [
    AppAssets.heroBanner1,
    AppAssets.heroBanner2,
    AppAssets.heroBanner3,
  ];

  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  bool _hasImages = true; // Flag to track if images are available

  @override
  void initState() {
    super.initState();
    // --- Check if banner images list is populated ---
    if (_bannerImages.isEmpty || _bannerImages.any((path) => path.isEmpty)) {
      _hasImages = false;
      if (kDebugMode) { // Only print in debug mode
        print("ERROR: HeroSection _bannerImages list is empty or contains empty paths. "
              "Check AppAssets definitions and asset paths.");
      }
    } else {
      // Start the timer only if images are available
      _startBannerTimer();
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _startBannerTimer() {
    // Ensure list is not empty before starting timer
    if (!_hasImages) return;

    // *** Duration is 10 seconds ***
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        // --- Add safety check before calculating index ---
        if (_bannerImages.isNotEmpty) {
           final newIndex = (_currentBannerIndex + 1) % _bannerImages.length;
           if (kDebugMode) {
             print("Updating banner index: $_currentBannerIndex -> $newIndex (List length: ${_bannerImages.length})");
           }
           setState(() {
             _currentBannerIndex = newIndex;
           });
        } else {
           // This case shouldn't be reached if initState check works, but added for safety
           if (kDebugMode) {
             print("ERROR: Banner timer fired but _bannerImages is empty.");
           }
           timer.cancel(); // Stop timer if list becomes empty unexpectedly
           setState(() {
             _hasImages = false;
           });
        }
      } else {
        timer.cancel();
      }
    });
  }

  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';
  // final String _providerJoinUrl = '/join'; // If needed

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    // Get screen height
    final double screenHeight = MediaQuery.of(context).size.height;

    // *** ADJUST HERO SECTION HEIGHT HERE ***
    // Define a suitable height for the hero section.
    // Using screenHeight directly might be too much if you have an AppBar.
    // Consider subtracting AppBar height if you want it to be truly full viewport below AppBar.
    // final double appBarHeight = Theme.of(context).appBarTheme.toolbarHeight ?? kToolbarHeight;
    // final double heroHeight = screenHeight - appBarHeight; // Full viewport below AppBar
    final double heroHeight = screenHeight * 0.95; // Example: 95% of total screen height

    final Color imageOverlayColor = theme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.6);

    // --- Fallback background if no images ---
    final Widget backgroundWidget = !_hasImages
      ? Container(
          key: const ValueKey<String>('fallback_background'), // Key for AnimatedSwitcher
          color: theme.colorScheme.surface, // Use a theme color as fallback
          child: const Center(child: Text("Banner Error")), // Optional: Show error text
        )
      : Container(
          key: ValueKey<int>(_currentBannerIndex), // Use index as key when images exist
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_bannerImages[_currentBannerIndex]),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(imageOverlayColor, BlendMode.darken),
              onError: (exception, stackTrace) {
                 if (kDebugMode) {
                    print("ERROR loading banner image ${_bannerImages[_currentBannerIndex]}: $exception");
                 }
              },
            ),
          ),
        );

    // --- Main Container controlling the height ---
    return Container(
      width: double.infinity,
      height: heroHeight, // Set the desired height for the section
      child: Stack(
        children: [
          // --- Animated Background Banner (or fallback) ---
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1800), // Fade duration
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: backgroundWidget, // Use the conditional background widget
            ),
          ),

          // --- Foreground Content (Text and Buttons) ---
          // Use Center widget to vertically and horizontally center the content column
          Center(
            child: Padding(
              // Horizontal padding remains, vertical padding removed as Center handles vertical alignment
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingPageHorizontal,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  // Column takes minimum space needed by children
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      AppStrings.heroTitle.tr(),
                      style: Helpers.responsiveValue(
                        context,
                        mobile: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                        desktop: theme.textTheme.displayMedium?.copyWith(color: Colors.white),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),

                    const SizedBox(height: AppDimensions.spacingMedium),

                    // Subtitle
                    Text(
                      AppStrings.heroSubtitle.tr(),
                      style: Helpers.responsiveValue(
                        context,
                        mobile: theme.textTheme.titleLarge?.copyWith(color: Colors.white.withOpacity(0.85)),
                        desktop: theme.textTheme.headlineSmall?.copyWith(color: Colors.white.withOpacity(0.85)),
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),

                    const SizedBox(height: AppDimensions.spacingExtraLarge),

                    // Buttons
                    ResponsiveRowColumn(
                      layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                      rowMainAxisAlignment: MainAxisAlignment.center,
                      columnCrossAxisAlignment: CrossAxisAlignment.center,
                      rowSpacing: AppDimensions.spacingMedium,
                      columnSpacing: AppDimensions.spacingMedium,
                      children: [
                        // App Store Button (Primary Style)
                        ResponsiveRowColumnItem(
                          child: CustomButton(
                            text: "App Store", // Using direct string for example
                            onPressed: () => Helpers.launchUrlHelper(context, _appStoreUrl),
                            icon: const Icon(Icons.apple),
                          ),
                        ),
                        // Google Play Button (Secondary/Outline Style)
                        ResponsiveRowColumnItem(
                          child: CustomButton(
                            text: "Google Play",
                            onPressed: () => Helpers.launchUrlHelper(context, _playStoreUrl),
                            icon: const Icon(Icons.shop), // Consider a Google Play specific icon if available
                            isSecondary: true, // Apply the secondary style (outline)
                          ),
                        ),
                      ],
                    ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

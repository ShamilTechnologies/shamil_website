import 'dart:math' as math; // <-- ADD THIS IMPORT
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart'; // For asset paths
import 'package:shamil_web/features/home/data/models/testimonial_model.dart'; // Import the model

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  // Sample testimonial data
  final List<TestimonialModel> _testimonials = [
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoTechNova, // Replace with actual asset
      companyNameKey: AppStrings.testimonial1CompanyName,
      testimonialTextKey: AppStrings.testimonial1Text,
      userAvatarAsset: AppAssets.userAvatarBen, // Replace with actual asset
      userNameKey: AppStrings.testimonial1UserName,
      userTitleKey: AppStrings.testimonial1UserTitle,
    ),
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoShopify, // Replace with actual asset
      companyNameKey: AppStrings.testimonial2CompanyName,
      testimonialTextKey: AppStrings.testimonial2Text,
      userAvatarAsset: AppAssets.userAvatarMichael, // Replace with actual asset
      userNameKey: AppStrings.testimonial2UserName,
      userTitleKey: AppStrings.testimonial2UserTitle,
    ),
    const TestimonialModel(
      companyLogoAsset: AppAssets.companyLogoApex, // Replace with actual asset
      companyNameKey: AppStrings.testimonial3CompanyName,
      testimonialTextKey: AppStrings.testimonial3Text,
      userAvatarAsset: AppAssets.userAvatarRavi, // Replace with actual asset
      userNameKey: AppStrings.testimonial3UserName,
      userTitleKey: AppStrings.testimonial3UserTitle,
    ),
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.85, // Show parts of adjacent cards for a carousel feel
    );
    // Add listener to update current page for indicators or other logic if needed
    _pageController.addListener(() {
      // Check if pageController has clients and page is not null before rounding
      if (_pageController.hasClients && _pageController.page != null) {
        final int newPage = _pageController.page!.round();
        if (newPage != _currentPage) {
          if (mounted) {
            setState(() {
              _currentPage = newPage;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _testimonials.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Optional: Loop back to the first page
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Optional: Loop to the last page
      _pageController.animateToPage(
        _testimonials.length -1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final bool isDarkMode = theme.brightness == Brightness.dark; // Not explicitly used in this build

    return Container(
      color: theme.colorScheme.background, // Use main background
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal * 0.5, // Reduced horizontal for wider cards
          vertical: AppDimensions.paddingSectionVertical + 20),
      child: Column(
        children: [
          Text(
            AppStrings.testimonialsTitle.tr(),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          const SizedBox(height: AppDimensions.spacingExtraLarge + 20),
          SizedBox(
            height: 420, // Adjust height to fit content and look good
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _testimonials.length,
                  onPageChanged: (int page) { // More reliable way to update _currentPage
                    if (mounted) {
                      setState(() {
                        _currentPage = page;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    final testimonial = _testimonials[index];
                    // Calculate scale for cards not in focus
                    double scale = 1.0;
                    // Use _currentPage directly for scaling logic
                    scale = math.max(0.85, (1.0 - (_currentPage - index).abs() * 0.15));

                    return Transform.scale(
                       scale: scale,
                       child: _buildTestimonialCard(context, theme, testimonial),
                    );
                  },
                ),
                // Navigation Arrows
                Positioned(
                  left: 0,
                  child: Material( // Wrap with Material for InkWell splash
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _previousPage,
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0,2)
                            )
                          ]
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                   child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _nextPage,
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.7),
                          shape: BoxShape.circle,
                           boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0,2)
                            )
                          ]
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 700.ms);
  }

  Widget _buildTestimonialCard(BuildContext context, ThemeData theme, TestimonialModel testimonial) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0), // Margin for spacing and shadow
      padding: const EdgeInsets.all(AppDimensions.paddingLarge + 5),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface, // Use CardTheme color
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
        children: [
          // Company Info
          Row(
            children: [
              Image.asset(
                testimonial.companyLogoAsset,
                height: 32, // Adjust as needed
                width: 32,  // Adjust as needed
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 32),
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Text(
                testimonial.companyNameKey.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLarge),

          // Testimonial Text
          Expanded(
            child: SingleChildScrollView( // Make text scrollable if too long
              child: Text(
                testimonial.testimonialTextKey.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.85),
                  height: 1.6,
                  fontSize: 17
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),

          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(testimonial.userAvatarAsset),
                onBackgroundImageError: (exception, stackTrace) {
                  // Optionally print error or handle it
                },
                // Fallback child if backgroundImage fails or is null
                child: (AssetImage(testimonial.userAvatarAsset) == null ||
                        AssetImage(testimonial.userAvatarAsset).assetName.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.userNameKey.tr(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    testimonial.userTitleKey.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

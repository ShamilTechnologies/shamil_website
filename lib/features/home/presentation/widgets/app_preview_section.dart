import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
// import 'package:shamil_web/core/widgets/animated_fade_in.dart'; // Using flutter_animate directly
import 'package:shamil_web/core/widgets/custom_button.dart'; // Assuming you have this
import 'package:responsive_framework/responsive_framework.dart';

class AppPreviewSection extends StatelessWidget {
  const AppPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    // final bool isDarkMode = theme.brightness == Brightness.dark; // Not directly needed for phone frame anymore

    // Phone mockup colors
    const Color phoneFrameColor = Colors.black; // Frame is always black
    final Color phoneScreenBackgroundColor = theme.brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white; // Screen bg adapts
    final Color phoneNotchColor = Colors.black; // Notch is always black

    return Container(
      // Use theme.colorScheme.surface or background
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingPageHorizontal,
        vertical: AppDimensions.paddingSectionVertical + (isMobile ? 0 : 30),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200), // Wider for this layout
          child: ResponsiveRowColumn(
            layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            columnSpacing: AppDimensions.paddingLarge,
            rowSpacing: AppDimensions.paddingLarge * 2, // Space between text and phone
            children: [
              // --- Phone Mockup (Now on the Left) ---
              ResponsiveRowColumnItem(
                rowFlex: 3, // Takes 3 parts of the row space
                child: _buildPhoneMockup(
                  context,
                  theme,
                  phoneFrameColor: phoneFrameColor,
                  phoneScreenBackgroundColor: phoneScreenBackgroundColor,
                  phoneNotchColor: phoneNotchColor,
                  appInterfaceAsset: AppAssets.shamilAppInterface, // Your app screenshot
                ).animate().fadeIn(delay: 300.ms, duration: 700.ms).slideX(begin: -0.2, curve: Curves.easeOutCubic), // Slide from left
              ),
              // --- Right Side: Text Content (Now on the Right) ---
              ResponsiveRowColumnItem(
                rowFlex: 2, // Takes 2 parts of the row space
                child: _buildTextContent(context, theme, isMobile),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms), // Overall section fade-in
        ),
      ),
    );
  }

  // Helper widget for the text content on the left (now right)
  Widget _buildTextContent(BuildContext context, ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.previewSectionTitle.tr(),
          style: (isMobile
                  ? theme.textTheme.headlineLarge
                  : theme.textTheme.displayMedium)
              ?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: 0.1, curve: Curves.easeOutCubic), // Slide from right
        const SizedBox(height: AppDimensions.spacingLarge),
        Text(
          AppStrings.previewSectionSubtitle.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
        const SizedBox(height: AppDimensions.spacingExtraLarge),
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            CustomButton(
              text: AppStrings.previewTryForFree.tr(),
              onPressed: () { /* TODO: Implement action */ },
              // Primary button style will be applied from theme
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            CustomButton(
              text: AppStrings.previewShowMore.tr(),
              onPressed: () { /* TODO: Implement action */ },
              isSecondary: true, // Outline style
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
        // Optional: Add the "Coach" avatars section here if desired
        // _buildCoachesSection(context, theme),
      ],
    );
  }

  // Helper widget for the phone mockup
  Widget _buildPhoneMockup(
    BuildContext context,
    ThemeData theme, {
    required Color phoneFrameColor, // Will be Colors.black
    required Color phoneScreenBackgroundColor,
    required Color phoneNotchColor,
    required String appInterfaceAsset,
  }) {
    // *** ADJUST PHONE SIZE HERE ***
    // Made the phone smaller by reducing defaultValue and conditional values
    final double phoneWidth = ResponsiveValue(
      context,
      defaultValue: 240.0, // Reduced from 280.0
      conditionalValues: [
        Condition.smallerThan(name: TABLET, value: 220.0), // Reduced from 260.0
        Condition.largerThan(name: DESKTOP, value: 280.0), // Reduced from 320.0
      ]
    ).value!;

    final double phoneHeight = phoneWidth * (19.5 / 9); // Maintain aspect ratio
    final double phoneBorderRadius = phoneWidth * 0.12;
    final double screenPadding = phoneWidth * 0.04;
    final double notchHeight = phoneHeight * 0.035;
    final double notchWidth = phoneWidth * 0.35;

    return Container(
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        // *** FRAME COLOR IS NOW ALWAYS BLACK ***
        color: phoneFrameColor, // This will be Colors.black
        borderRadius: BorderRadius.circular(phoneBorderRadius),
        // *** ENHANCED SHADOW FOR FLOATING EFFECT ***
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35), // Darker, more pronounced shadow
            blurRadius: 25,      // Increased blur for softer, larger shadow
            spreadRadius: 3,       // Slightly increased spread
            offset: const Offset(0, 12), // Increased Y-offset for more "lift"
          ),
        ],
      ),
      padding: EdgeInsets.all(screenPadding * 0.4), // Slightly reduced bezel padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(phoneBorderRadius - (screenPadding * 0.4)),
        child: Container(
          color: phoneScreenBackgroundColor, // Screen background (adapts to theme)
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(screenPadding * 0.5),
                  child: ClipRRect(
                     borderRadius: BorderRadius.circular(phoneBorderRadius - screenPadding),
                    child: Image.asset(
                      appInterfaceAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          "App Preview Unavailable", // TODO: Localize this
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onError),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenPadding * 0.7,
                child: Container(
                  width: notchWidth,
                  height: notchHeight,
                  decoration: BoxDecoration(
                    color: phoneNotchColor, // Notch color (black)
                    borderRadius: BorderRadius.circular(notchHeight / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Optional: Helper for the "Coaches" part if you want to implement it
  // Widget _buildCoachesSection(BuildContext context, ThemeData theme) { ... }
}

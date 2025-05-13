import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // For internationalization.
import 'package:flutter_animate/flutter_animate.dart'; // For UI animations.
import 'package:shamil_web/core/constants/app_dimensions.dart'; // For consistent spacing and sizing.
import 'package:shamil_web/core/constants/app_strings.dart'; // For localized strings.
// import 'package:shamil_web/core/constants/app_assets.dart'; // No longer needed directly for rocket in this version
import 'package:responsive_framework/responsive_framework.dart'; // For responsive UI design.

// IntroSection: Now a StatelessWidget as rocket animation is handled separately.
class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Ensure that the breakpoint names (MOBILE, TABLET) used here
    // exactly match the 'name' property provided to the Breakpoint widgets
    // in your ResponsiveBreakpoints.builder setup (usually in your MaterialApp).
    // For example, if you used name: 'MOBILE_DEVICE' in the builder,
    // you must use that same name/constant here.
    // The responsive_framework package exports MOBILE, TABLET, DESKTOP constants.
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final bool isTablet = ResponsiveBreakpoints.of(context).between(MOBILE, TABLET);

    // Define text styles based on theme for good contrast.
    // Using ?.copyWith is safe. If the base style (e.g., theme.textTheme.headlineLarge) is null,
    // the result of titleStyle will be null, and Text(style: null) is valid (uses default style).
    // However, ensure your theme (AppTheme.dart) defines these text styles.
    final TextStyle? titleStyle = isMobile
        ? theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.onPrimary, fontSize: 30, fontWeight: FontWeight.bold)
        : theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);

    final TextStyle? descriptionStyle = theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.onPrimary, // Text color is onPrimary (e.g., white on dark blue).
      height: 1.7, // Line height for readability.
      fontSize: isMobile ? 17 : (isTablet ? 19 : 21), // Responsive font size.
    );

    // Fallback TextStyle if theme styles are somehow not defined properly.
    const TextStyle fallbackTextStyle = TextStyle(color: Colors.red); // Visible error color

    // Outermost container: Sets the background color.
    return Container(
      // Ensure theme.colorScheme.primary is well-defined in both light and dark themes.
      color: theme.colorScheme.primary, // Background color from theme.
      // Padding widget defines the content area within the colored background.
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical + (isMobile ? 10 : 40),
        ),
        // Main Content (Title and Description) - Centered within the padded area.
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100), // Max width for content.
            // Ensure AnimatedFadeIn is a correctly implemented custom widget if it's yours,
            // or that it's used correctly if from a package.
            child: Animate( // Replaced AnimatedFadeIn with direct flutter_animate for clarity
              effects: [
                FadeEffect(delay: 100.ms, duration: 500.ms), // Overall fade for the content block.
              ],
              child: ResponsiveRowColumn(
                layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                columnCrossAxisAlignment: CrossAxisAlignment.center,
                columnSpacing: AppDimensions.spacingLarge,
                rowSpacing: AppDimensions.paddingLarge * 2,
                children: [
                  // Title Column
                  ResponsiveRowColumnItem(
                    rowFlex: isTablet ? 3 : 2, // Flex factor for responsive layout.
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        // Ensure AppStrings.whatIsShamil is a valid key in your translation files.
                        // If .tr() fails, it might display the key itself or cause issues if EasyLocalization isn't setup.
                        Text(
                          AppStrings.whatIsShamil.tr(), // Localized title.
                          style: titleStyle ?? fallbackTextStyle, // Use fallback if titleStyle is null
                          textAlign: isMobile ? TextAlign.center : TextAlign.start,
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.1, duration: 500.ms), // Entrance animation.
                      ],
                    ),
                  ),
                  // Description Column
                  ResponsiveRowColumnItem(
                    rowFlex: 3, // Flex factor for responsive layout.
                    child: Padding(
                      padding: EdgeInsets.only(top: isMobile ? AppDimensions.spacingMedium : 0),
                      // Ensure AppStrings.introText is a valid key.
                      child: Text(
                        AppStrings.introText.tr(), // Localized description.
                        style: descriptionStyle ?? fallbackTextStyle, // Use fallback
                        textAlign: isMobile ? TextAlign.center : TextAlign.start,
                      ).animate().fadeIn(delay: 350.ms, duration: 600.ms).slideX(begin: 0.1, duration: 500.ms), // Entrance animation.
                      ),
                    ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

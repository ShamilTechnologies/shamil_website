import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // Import AppColors for specific hover
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppPreviewSection extends StatelessWidget {
  const AppPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    const Color phoneFrameColor = Colors.black;
    final Color phoneScreenBackgroundColor = theme.brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white;
    final Color phoneNotchColor = Colors.black;

    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingPageHorizontal,
        vertical: AppDimensions.paddingSectionVertical + (isMobile ? 20 : 50),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveRowColumn(
            layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            columnSpacing: AppDimensions.paddingLarge + 20,
            // *** INCREASED ROW SPACING for more space between text and phone ***
            rowSpacing: AppDimensions.paddingLarge * 3.5, // Was 2.5
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2, // Text content takes 2 parts
                child: _buildTextContent(context, theme, isMobile),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 3, // Phone mockup takes 3 parts
                child: _buildPhoneMockup(
                  context,
                  theme,
                  phoneFrameColor: phoneFrameColor,
                  phoneScreenBackgroundColor: phoneScreenBackgroundColor,
                  phoneNotchColor: phoneNotchColor,
                  appInterfaceAsset: AppAssets.shamilAppInterface,
                ).animate().fadeIn(delay: 300.ms, duration: 700.ms).slideX(begin: 0.2, curve: Curves.easeOutCubic),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, ThemeData theme, bool isMobile) {
    // Define a specific hover overlay for gold buttons
    final MaterialStateProperty<Color?> goldButtonHoverOverlay =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          // On hover, make it slightly darker or apply a dark overlay
          return AppColors.black.withOpacity(0.12); // Example: subtle dark overlay
          // Alternatively, use a darker shade of gold if defined in AppColors:
          // return AppColors.primaryGoldDark.withOpacity(0.8); // Ensure primaryGoldDark is defined
        }
        return null; // No overlay in other states
      },
    );

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
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: -0.1, curve: Curves.easeOutCubic),
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
            // "Download Now" Button - Styled as PRIMARY THEME COLOR
            CustomButton(
              text: AppStrings.downloadNow.tr(),
              onPressed: () { /* TODO: Implement download action */ },
              // No explicit backgroundColor or foregroundColor needed;
              // it will inherit from the ElevatedButtonTheme (which uses theme.colorScheme.primary).
              // isSecondary is false by default.
              // Icon can be added if desired, e.g., Icon(Icons.download)
            ),
            const SizedBox(width: AppDimensions.spacingMedium),
            // "Show More" Button - Styled as GOLD
            CustomButton(
              text: AppStrings.previewShowMore.tr(),
              onPressed: () { /* TODO: Implement action */ },
              // Explicitly set gold styling
              backgroundColor: theme.colorScheme.secondary, // This is AppColors.primaryGold via theme
              foregroundColor: theme.colorScheme.onSecondary, // This is AppColors.textOnGold (black) via theme
              overlayColor: goldButtonHoverOverlay, // Apply custom hover for gold
              // isSecondary: true, // REMOVED: No longer using the default secondary (outline) style
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
      ],
    );
  }

  // Helper widget for the phone mockup
  Widget _buildPhoneMockup(
    BuildContext context,
    ThemeData theme, {
    required Color phoneFrameColor,
    required Color phoneScreenBackgroundColor,
    required Color phoneNotchColor,
    required String appInterfaceAsset,
  }) {
    final double phoneWidth = ResponsiveValue(
      context,
      defaultValue: 240.0,
      conditionalValues: [
        Condition.smallerThan(name: TABLET, value: 220.0),
        Condition.largerThan(name: DESKTOP, value: 280.0),
      ]
    ).value!;

    final double phoneHeight = phoneWidth * (19.5 / 9);
    final double phoneBorderRadius = phoneWidth * 0.12;
    final double screenPaddingFactor = phoneWidth * 0.04;
    final double bezelThickness = screenPaddingFactor * 0.6;
    final double screenCornerRadius = phoneBorderRadius - bezelThickness;
    final double imageCornerRadius = screenCornerRadius * 0.85;
    final double notchHeight = phoneHeight * 0.035;
    final double notchWidth = phoneWidth * 0.35;

    // Define animation parameters
    const Duration floatDuration = Duration(milliseconds: 3000);
    const double floatDistance = 6.0;

    Widget phoneWidget = Container(
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        color: phoneFrameColor,
        borderRadius: BorderRadius.circular(phoneBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(bezelThickness),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenCornerRadius),
        child: Container(
          color: phoneScreenBackgroundColor,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: ClipRRect(
                   borderRadius: BorderRadius.circular(imageCornerRadius),
                  child: Image.asset(
                    appInterfaceAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        "App Preview Unavailable".tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onError),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenPaddingFactor * 0.5,
                child: Container(
                  width: notchWidth,
                  height: notchHeight,
                  decoration: BoxDecoration(
                    color: phoneNotchColor,
                    borderRadius: BorderRadius.circular(notchHeight / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget animatedPhone = phoneWidget
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -floatDistance,
          end: floatDistance,
          duration: floatDuration,
          curve: Curves.easeInOutSine,
        );

    Widget animatedShadow = Container(
      width: phoneWidth,
      height: phoneHeight * 0.03,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(phoneHeight * 0.015),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .custom(
      duration: floatDuration,
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        final double baseShadowRestingY = 25.0;
        final shadowOffsetY = baseShadowRestingY + (floatDistance * 0.8) - (value * floatDistance * 1.6);
        final shadowBlur = 30.0 - (value * 20.0);
        final shadowSpread = 6.0 - (value * 4.0);
        final shadowOpacity = 0.05 + (value * 0.15);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(phoneHeight * 0.015),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity.clamp(0.03, 0.25)),
                blurRadius: shadowBlur.clamp(5.0, 35.0),
                spreadRadius: shadowSpread.clamp(1.0, 8.0),
                offset: Offset(0, shadowOffsetY),
              ),
            ],
          ),
          child: child,
        );
      }
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(0, phoneHeight * 0.5 + floatDistance * 2.5),
          child: animatedShadow,
        ),
        animatedPhone,
      ],
    );
  }
}

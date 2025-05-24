// lib/features/home/presentation/widgets/benefits_section.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // Assuming your AppColors are here
import 'package:responsive_framework/responsive_framework.dart';

// Data model for benefit cards (reusing and simplifying from original)
class ViralCardData {
  final String titleKey;
  final List<ViralBenefit> benefits;
  final IconData primaryIcon;
  final Color gradientStart;
  final Color gradientEnd;
  // final String emoji; // Kept if needed for other parts, but not used in simplified card
  // final String statistic; // Kept if needed, not used in simplified card
  // final String flipMessage; // Kept if needed, not used in simplified card

  ViralCardData({
    required this.titleKey,
    required this.benefits,
    required this.primaryIcon,
    required this.gradientStart,
    required this.gradientEnd,
    String emoji = "", // Provide default if not used
    String statistic = "", // Provide default
    String flipMessage = "", // Provide default
  });
}

// Individual benefit item
class ViralBenefit {
  final String textKey;
  final String emoji;
  final String buzzword; // Keeping this for descriptive flair

  ViralBenefit(this.textKey, this.emoji, this.buzzword);
}


/// Simplified Benefits Section
/// Displays benefits for users and providers using clear, themed cards.
class BenefitsSection extends StatefulWidget {
  const BenefitsSection({super.key});

  @override
  State<BenefitsSection> createState() => _BenefitsSectionState();
}

class _BenefitsSectionState extends State<BenefitsSection> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Container(
      decoration: _buildSectionBackground(theme),
      child: _buildBenefitsContent(theme, isMobile),
    );
  }

  BoxDecoration _buildSectionBackground(ThemeData theme) {
    // Simplified background using Shamil colors
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: theme.brightness == Brightness.light
            ? [
                AppColors.lightPageBackground.withOpacity(0.5),
                AppColors.accent.withOpacity(0.1),
                AppColors.lightPageBackground,
              ]
            : [
                AppColors.darkPageBackground,
                AppColors.primary.withOpacity(0.3),
                AppColors.darkPageBackground.withOpacity(0.8),

              ],
        stops: const [0.0, 0.5, 1.0]
      ),
    );
  }

  Widget _buildBenefitsContent(ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingPageHorizontal,
        vertical: AppDimensions.paddingSectionVertical,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200), // Consistent max width
          child: Column(
            children: [
              _buildSectionHeader(theme, isMobile)
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOutCubic),
              
              SizedBox(height: isMobile ? 50 : 80),
              
              _buildBenefitCards(theme, isMobile),
              
              SizedBox(height: isMobile ? 50 : 80),
              
              _buildCallToAction(theme, isMobile)
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, bool isMobile) {
    // Using AppStrings for title for consistency
    final String title = AppStrings.whyChooseShamil.tr();
    final String subtitle = AppStrings.flipCardsToDiscover.tr(); // Example, can be more specific

    return Column(
      children: [
        Text(
          title,
          style: (isMobile 
              ? theme.textTheme.headlineLarge 
              : theme.textTheme.displaySmall)?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ).animate().shimmer(delay: 400.ms, duration: 1800.ms, color: theme.colorScheme.primary.withOpacity(0.3)),
        const SizedBox(height: AppDimensions.paddingMedium),
        Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            subtitle, // "Experience the future of service booking with our revolutionary platform"
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 600.ms) // Stagger the subtitle animation
           .fadeIn(duration: 800.ms)
           .custom( // Typewriter effect
             duration: 2000.ms, // Adjust duration for speed
             builder: (context, value, child) {
               final fullText = subtitle;
               final displayedLength = (fullText.length * value).round().clamp(0, fullText.length);
               return Text(
                 fullText.substring(0, displayedLength),
                 style: theme.textTheme.titleMedium?.copyWith(
                   color: theme.colorScheme.onSurface.withOpacity(0.7),
                   height: 1.6,
                 ),
                 textAlign: TextAlign.center,
               );
             },
           ),
        ),
      ],
    );
  }

  Widget _buildBenefitCards(ThemeData theme, bool isMobile) {
    return ResponsiveRowColumn(
      layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
      rowCrossAxisAlignment: CrossAxisAlignment.start, // Align cards to the top if heights differ
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      rowSpacing: AppDimensions.paddingLarge * (isMobile ? 1.5 : 2), // Responsive spacing
      columnSpacing: AppDimensions.paddingLarge * 2,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: BenefitCard(
            theme: theme,
            cardData: ViralCardData(
              titleKey: AppStrings.forUsersTitle,
              benefits: [
                ViralBenefit(AppStrings.forUsersBenefit1, "⚡", "Speed"),
                ViralBenefit(AppStrings.forUsersBenefit2, "🛡️", "Security"),
                ViralBenefit(AppStrings.forUsersBenefit3, "🎯", "Precision"),
                ViralBenefit(AppStrings.forUsersBenefit4, "🌍", "Accessibility"),
              ],
              primaryIcon: Icons.person_rounded,
              gradientStart: AppColors.primary, // Shamil Dark Blue
              gradientEnd: AppColors.accent,     // Shamil Lighter Blue
            ),
          ).animate(delay: 400.ms) // Stagger card animations
           .fadeIn(duration: 700.ms, curve: Curves.easeOutCubic)
           .slideX(begin: isMobile ? 0 : -0.1, duration: 700.ms, curve: Curves.easeOutCubic)
           .scaleXY(begin: 0.95, curve: Curves.easeOutCubic),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: BenefitCard(
            theme: theme,
            cardData: ViralCardData(
              titleKey: AppStrings.forProvidersTitle,
              benefits: [
                ViralBenefit(AppStrings.forProvidersBenefit1, "🤖", "Automation"),
                ViralBenefit(AppStrings.forProvidersBenefit2, "📊", "Analytics"),
                ViralBenefit(AppStrings.forProvidersBenefit3, "💰", "Growth"),
                ViralBenefit(AppStrings.forProvidersBenefit4, "🚀", "Efficiency"),
              ],
              primaryIcon: Icons.store_rounded,
              gradientStart: AppColors.primaryGold,      // Shamil Gold
              gradientEnd: AppColors.primaryGoldLight, // Lighter Gold
            ),
          ).animate(delay: 600.ms) // Stagger second card
           .fadeIn(duration: 700.ms, curve: Curves.easeOutCubic)
           .slideX(begin: isMobile ? 0 : 0.1, duration: 700.ms, curve: Curves.easeOutCubic)
           .scaleXY(begin: 0.95, curve: Curves.easeOutCubic),
        ),
      ],
    );
  }

  Widget _buildCallToAction(ThemeData theme, bool isMobile) {
    // Simplified CTA, can reuse existing CTA button styles if available
    return Column(
      children: [
        Text(
          "Ready to Get Started?".tr(), // Example, use AppStrings
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        ElevatedButton(
          onPressed: () { /* TODO: CTA Action */ },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGold,
            foregroundColor: AppColors.textOnGold,
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingExtraLarge,
                vertical: AppDimensions.paddingMedium),
            textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            ),
          ),
          child: Text(AppStrings.downloadNow.tr()),
        ),
      ],
    );
  }
}


/// Simplified Benefit Card Widget
class BenefitCard extends StatefulWidget {
  final ThemeData theme;
  final ViralCardData cardData;

  const BenefitCard({
    super.key,
    required this.theme,
    required this.cardData,
  });

  @override
  State<BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<BenefitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cardTextColor = widget.theme.brightness == Brightness.light 
                          ? AppColors.textWhite // Good contrast on dark blue/gold
                          : AppColors.darkTextPrimary; // Ensure good contrast on lighter versions if used in dark theme
    
    // For gradients on dark backgrounds, white text is usually best.
    // If cardData gradients are light, then a dark text color would be needed.
    // Assuming gradientStart/End are Shamil's primary (dark blue) and gold, white text is fine.

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click, // Indicates interactivity, even if just hover
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 420, // Fixed height for consistency, adjust as needed
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.cardData.gradientStart, widget.cardData.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.cardData.gradientStart.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: widget.cardData.gradientEnd.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: widget.theme.shadowColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon and Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15), // Subtle icon background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.cardData.primaryIcon,
                    color: Colors.white, // Icon color on gradient
                    size: AppDimensions.iconSizeMedium,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Text(
                    widget.cardData.titleKey.tr(),
                    style: widget.theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white, // Title text color on gradient
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),

            // Benefits List
            Expanded(
              child: ListView.builder(
                itemCount: widget.cardData.benefits.length,
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling within card if height is fixed
                itemBuilder: (context, index) {
                  final benefit = widget.cardData.benefits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                    child: Row(
                      children: [
                        Text(
                          benefit.emoji,
                          style: const TextStyle(fontSize: 20), // Emoji size
                        ),
                        const SizedBox(width: AppDimensions.paddingSmall),
                        Expanded(
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                benefit.textKey.tr(),
                                style: widget.theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.95), // Benefit text color
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (benefit.buzzword.isNotEmpty)
                                Text(
                                  benefit.buzzword,
                                  style: widget.theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.7), // Buzzword color
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
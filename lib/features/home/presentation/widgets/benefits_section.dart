// // lib/features/home/presentation/widgets/benefits_section.dart
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shamil_web/core/constants/app_assets.dart';
// import 'package:shamil_web/core/constants/app_colors.dart';
// import 'package:shamil_web/core/constants/app_dimensions.dart';
// import 'package:shamil_web/core/constants/app_strings.dart';
// import 'package:flip_card/flip_card.dart'; // Import flip_card
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:shamil_web/core/utils/helpers.dart';
// import 'package:shamil_web/core/widgets/animated_fade_in.dart';

// class BenefitsSection extends StatelessWidget {
//   const BenefitsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppDimensions.paddingPageHorizontal,
//           vertical: AppDimensions.paddingSectionVertical),
//       child: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 1100), // Wider for side-by-side
//           child: AnimatedFadeIn(
//              delay: 200.ms, // Stagger animation
//              child: ResponsiveRowColumn(
//               layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
//               rowCrossAxisAlignment: CrossAxisAlignment.start,
//               rowSpacing: AppDimensions.paddingLarge,
//               columnSpacing: AppDimensions.paddingSectionVertical / 2,
//               children: [
//                 ResponsiveRowColumnItem(
//                   rowFlex: 1,
//                   child: _buildBenefitCard(
//                     context,
//                     titleKey: AppStrings.forUsersTitle,
//                     benefits: [
//                       AppStrings.forUsersBenefit1,
//                       AppStrings.forUsersBenefit2,
//                       AppStrings.forUsersBenefit3,
//                       AppStrings.forUsersBenefit4,
//                     ],
//                     icon: Icons.person_outline,
//                     isUserCard: true,
//                   ),
//                 ),
//                 ResponsiveRowColumnItem(
//                   rowFlex: 1,
//                   child: _buildBenefitCard(
//                     context,
//                     titleKey: AppStrings.forProvidersTitle,
//                     benefits: [
//                       AppStrings.forProvidersBenefit1,
//                       AppStrings.forProvidersBenefit2,
//                       AppStrings.forProvidersBenefit3,
//                       AppStrings.forProvidersBenefit4,
//                     ],
//                      icon: Icons.storefront_outlined,
//                      isUserCard: false,
//                   ),
//                 ),
//               ],
//                      ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper to build the card (can be extracted further)
//   Widget _buildBenefitCard(BuildContext context, {
//     required String titleKey,
//     required List<String> benefits,
//     required IconData icon,
//     required bool isUserCard, // To potentially style differently or control flip direction
//   }) {
//     final cardContent = Container(
//        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
//        decoration: BoxDecoration(
//            color: isUserCard ? AppColors.primary : AppColors.primaryGold,
//            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
//            border: Border.all(color: AppColors.white)
//        ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//              children: [
//                 Icon(icon, color: AppColors.white, size: AppDimensions.iconSizeLarge),
//                 const SizedBox(width: AppDimensions.spacingMedium),
//                 Text(
//                   titleKey.tr(),
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.white),
//                 ),
//              ],
//           ),
//           const SizedBox(height: AppDimensions.spacingLarge),
//           ...benefits.map((key) => Padding(
//             padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.check_circle_outline, size: AppDimensions.iconSizeMedium, color: AppColors.lightPageBackground),
//                 const SizedBox(width: AppDimensions.spacingSmall),
//                 Expanded(child: Text(key.tr(), style: Theme.of(context).textTheme.bodyMedium)),
//               ],
//             ),
//           )).toList(),
//            // Add a 'Learn More' or similar button if desired
//         ],
//       ),
//     );

//     // Example using FlipCard - Wrap cardContent with FlipCard
//     // You might need to adjust sizing and interaction logic
//     return FlipCard(
//        // fill: Fill.fillBack, // Fill the back side
//        direction: FlipDirection.VERTICAL, // Or VERTICAL
//        front: cardContent,
//        back: Container( // Simple back example - replace with more info if needed
//           padding: const EdgeInsets.all(AppDimensions.paddingLarge),
//           decoration: BoxDecoration(
//              color: AppColors.primary,
//              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
//           ),
//           child: Center(
//              child: Text(
//                 isUserCard ? "Explore User Features!" : "Boost Your Business!", // Example back text
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white),
//                 textAlign: TextAlign.center,
//              ),
//           ),
//        ),
//     );

//     // If not using FlipCard, just return cardContent:
//     // return cardContent;
//   }
// }




import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/animated_fade_in.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Container(
      color: theme.colorScheme.background, // Use main background
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: AnimatedFadeIn(
            delay: 200.ms, // From original code
            child: ResponsiveRowColumn(
              layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowSpacing: AppDimensions.paddingLarge,
              columnSpacing: AppDimensions.paddingSectionVertical / 2,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: _buildBenefitCard(
                    context,
                    theme: theme,
                    titleKey: AppStrings.forUsersTitle,
                    benefits: [
                      AppStrings.forUsersBenefit1,
                      AppStrings.forUsersBenefit2,
                      AppStrings.forUsersBenefit3,
                      AppStrings.forUsersBenefit4,
                    ],
                    icon: Icons.person_outline,
                    cardBaseColor: theme.colorScheme.secondary.withOpacity(0.1), // Goldish tint
                    iconColor: theme.colorScheme.secondary,
                    titleColor: theme.colorScheme.secondary,
                    textColor: theme.textTheme.bodyMedium?.color,
                    flipCardBackgroundColor: theme.colorScheme.secondary,
                    flipCardTextColor: theme.colorScheme.onSecondary,
                  ),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: _buildBenefitCard(
                    context,
                    theme: theme,
                    titleKey: AppStrings.forProvidersTitle,
                    benefits: [
                      AppStrings.forProvidersBenefit1,
                      AppStrings.forProvidersBenefit2,
                      AppStrings.forProvidersBenefit3,
                      AppStrings.forProvidersBenefit4,
                    ],
                    icon: Icons.storefront_outlined,
                    cardBaseColor: theme.colorScheme.primary.withOpacity(0.1), // Bluish tint
                    iconColor: theme.colorScheme.primary,
                    titleColor: theme.colorScheme.primary,
                    textColor: theme.textTheme.bodyMedium?.color,
                    flipCardBackgroundColor: theme.colorScheme.primary,
                    flipCardTextColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard(
    BuildContext context, {
    required ThemeData theme,
    required String titleKey,
    required List<String> benefits,
    required IconData icon,
    required Color cardBaseColor,
    required Color iconColor,
    required Color titleColor,
    Color? textColor,
    required Color flipCardBackgroundColor,
    required Color flipCardTextColor,
  }) {
    final cardContent = Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
          color: cardBaseColor, // Theme-based tint
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          border: Border.all(color: iconColor.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: AppDimensions.iconSizeLarge),
              const SizedBox(width: AppDimensions.spacingMedium),
              Text(
                titleKey.tr(),
                style: theme.textTheme.headlineSmall?.copyWith(color: titleColor),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          ...benefits.map((key) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: AppDimensions.iconSizeMedium, color: iconColor),
                    const SizedBox(width: AppDimensions.spacingSmall),
                    Expanded(child: Text(key.tr(), style: theme.textTheme.bodyMedium?.copyWith(color: textColor))),
                  ],
                ),
              )).toList(),
        ],
      ),
    );

    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: cardContent,
      back: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: flipCardBackgroundColor, // Theme-based
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Center(
          child: Text(
            "${"learnMoreAbout".tr()} ${titleKey.tr()}", // Example, add "learnMoreAbout" to JSON
            style: theme.textTheme.titleLarge?.copyWith(color: flipCardTextColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}















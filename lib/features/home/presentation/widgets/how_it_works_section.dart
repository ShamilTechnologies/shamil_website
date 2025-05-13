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


// class HowItWorksSection extends StatelessWidget {
//   const HowItWorksSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//      final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
//     return Container(
//       color: AppColors.lightPageBackground, // Alternating background
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppDimensions.paddingPageHorizontal,
//           vertical: AppDimensions.paddingSectionVertical),
//       child: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 900),
//           child: AnimatedFadeIn(
//              delay: 400.ms,
//              child: Column(
//               children: [
//                 Text(
//                   AppStrings.howItWorksTitle.tr(),
//                   style: Theme.of(context).textTheme.headlineMedium,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: AppDimensions.spacingExtraLarge),
//                 ResponsiveRowColumn(
//                   layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
//                   rowMainAxisAlignment: MainAxisAlignment.spaceAround,
//                   columnSpacing: AppDimensions.paddingLarge,
//                   children: [
//                      ResponsiveRowColumnItem(rowFlex: 1, child: _buildStep(context, number: "1", titleKey: AppStrings.step1Title, descKey: AppStrings.step1Desc)),
//                      ResponsiveRowColumnItem(rowFlex: 1, child: _buildStep(context, number: "2", titleKey: AppStrings.step2Title, descKey: AppStrings.step2Desc)),
//                      ResponsiveRowColumnItem(rowFlex: 1, child: _buildStep(context, number: "3", titleKey: AppStrings.step3Title, descKey: AppStrings.step3Desc)),
//                   ],
//                 ),
//               ],
//                      ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStep(BuildContext context, {required String number, required String titleKey, required String descKey}) {
//      return Column(
//        children: [
//           CircleAvatar(
//              radius: 30,
//              backgroundColor: AppColors.primaryGold,
//              child: Text(number, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.white)),
//           ),
//           const SizedBox(height: AppDimensions.spacingMedium),
//           Text(titleKey.tr(), style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
//           const SizedBox(height: AppDimensions.spacingSmall),
//           Text(descKey.tr(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
//        ],
//      );
//   }
// }

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:shamil_web/core/constants/app_colors.dart'; // Prefer theme
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shamil_web/core/widgets/animated_fade_in.dart';


class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Container(
      color: theme.colorScheme.background, // Use main background or surface
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: AnimatedFadeIn(
            delay: 400.ms, // From original code
            child: Column(
              children: [
                Text(
                  AppStrings.howItWorksTitle.tr(),
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingExtraLarge),
                ResponsiveRowColumn(
                  layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                  columnSpacing: AppDimensions.paddingLarge,
                  rowSpacing: AppDimensions.paddingMedium, // Added rowSpacing
                  children: [
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: _buildStep(context, theme,
                            number: "1",
                            titleKey: AppStrings.step1Title,
                            descKey: AppStrings.step1Desc,
                            iconData: Icons.search)), // Example icon
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: _buildStep(context, theme,
                            number: "2",
                            titleKey: AppStrings.step2Title,
                            descKey: AppStrings.step2Desc,
                            iconData: Icons.book_online)), // Example icon
                    ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: _buildStep(context, theme,
                            number: "3",
                            titleKey: AppStrings.step3Title,
                            descKey: AppStrings.step3Desc,
                            iconData: Icons.celebration)), // Example icon
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, ThemeData theme, // Pass theme
      {required String number,
      required String titleKey,
      required String descKey,
      required IconData iconData}) { // Added iconData
    return Padding( // Added padding for better spacing on mobile column layout
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35, // Slightly larger
            backgroundColor: theme.colorScheme.primary, // Use theme primary
            child: Icon(iconData, size: 30, color: theme.colorScheme.onPrimary),
            // Text(number, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onPrimary)),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          Text(titleKey.tr(), style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppDimensions.spacingSmall),
          Text(descKey.tr(), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onBackground.withOpacity(0.8)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
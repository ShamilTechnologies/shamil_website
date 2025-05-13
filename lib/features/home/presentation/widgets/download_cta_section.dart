
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

// class DownloadCtaSection extends StatelessWidget {
//   const DownloadCtaSection({super.key});

//    // TODO: Replace with your actual App Store and Play Store links
//   final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
//   final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primaryGold, // Use primary color for strong CTA
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppDimensions.paddingPageHorizontal,
//           vertical: AppDimensions.paddingSectionVertical),
//       child: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 800),
//            child: AnimatedFadeIn(
//               delay: 700.ms,
//               beginOffsetY: 0, // No slide for this one maybe
//              child: Column(
//               children: [
//                 Text(
//                   // Use a more engaging title here if needed
//                   AppStrings.downloadNow.tr().toUpperCase(),
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.white),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: AppDimensions.spacingLarge),
//                  Text(
//                   // Add a short compelling sentence
//                   "Get started with the smartest way to manage services.", // TODO: Localize this
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white.withOpacity(0.9)),
//                   textAlign: TextAlign.center,
//                 ),
//                  const SizedBox(height: AppDimensions.spacingExtraLarge),
//                 Row( // Use official badges
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InkWell(
//                        onTap: () => Helpers.launchUrlHelper(context, _appStoreUrl),
//                        child: SvgPicture.asset(AppAssets.appStoreBadge, height: 50), // Ensure asset exists
//                     ),
//                      const SizedBox(width: AppDimensions.paddingMedium),
//                      InkWell(
//                        onTap: () => Helpers.launchUrlHelper(context, _playStoreUrl),
//                        child: Image.asset(AppAssets.googlePlayBadge, height: 50), // Ensure asset exists
//                     ),
//                   ],
//                 ),
//               ],
//                      ),
//            ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/utils/helpers.dart';
// import 'package:shamil_web/core/constants/app_colors.dart'; // Prefer theme colors
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/widgets/animated_fade_in.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/constants/app_assets.dart'; // For badges
import 'package:flutter_svg/flutter_svg.dart'; // If badges are SVG

class DownloadCtaSection extends StatelessWidget {
  const DownloadCtaSection({super.key});

  final String _appStoreUrl = 'https://apps.apple.com/app/your-app-id';
  final String _playStoreUrl = 'https://play.google.com/store/apps/details?id=your.package.name';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.primary, // Strong CTA with primary color
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: AppDimensions.paddingSectionVertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AnimatedFadeIn(
            delay: 700.ms, // From original code
            beginOffsetY: 0,
            child: Column(
              children: [
                Text(
                  AppStrings.downloadNow.tr().toUpperCase(),
                  style: theme.textTheme.displaySmall?.copyWith(color: theme.colorScheme.onPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingLarge),
                Text(
                  "getStartedWithShamil".tr(), // Add this key to your JSON files
                  style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.9)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingExtraLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Helpers.launchUrlHelper(context, _appStoreUrl),
                      // Assuming AppAssets.appStoreBadge points to an SVG or PNG that works on theme.primary background
                      child: SvgPicture.asset(AppAssets.appStoreBadge, height: 50),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    InkWell(
                      onTap: () => Helpers.launchUrlHelper(context, _playStoreUrl),
                      // Assuming AppAssets.googlePlayBadge points to an SVG or PNG
                      child: Image.asset(AppAssets.googlePlayBadge, height: 50),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
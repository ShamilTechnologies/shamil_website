import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:shamil_web/core/constants/app_colors.dart'; // Prefer theme colors
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
// Make sure AppAssets.logo is correctly defined if you use it, or handle if it's theme-specific
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/utils/helpers.dart'; // Assuming Helpers.launchUrlHelper is defined

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  // Placeholder URLs - replace with your actual links
  final String _facebookUrl = "https://facebook.com/yourpage";
  final String _telegramUrl = "https://t.me/yourchannel";
  final String _emailAddress = "contact@shamilapp.com";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    const double desktopBreakpoint = 1000;
    const double tabletBreakpoint = 600;

    // Determine footer background and foreground colors from the theme
    // Let's make the footer background similar to the AppBar background for consistency
    final Color footerBackgroundColor = theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    // For text and icons on this background, let's use the AppBar's title text style color or onSurface
    final Color footerForegroundColor = theme.appBarTheme.titleTextStyle?.color ?? theme.colorScheme.onSurface;
    final Color footerIconColor = theme.appBarTheme.iconTheme?.color ?? theme.colorScheme.onSurface;


    Widget logo = SizedBox(
      height: 60, // Consider making this responsive or slightly smaller
      child: Image.asset(
        AppAssets.logo, // Assuming AppAssets.logo is defined and points to your logo
        fit: BoxFit.contain,
        // If your logo is a single color and needs to adapt, you might use:
        // color: footerIconColor, // This only works well for monochrome silhouette logos
      ),
    );

    Widget copyright = Text(
      // Make sure AppStrings.allRightsReserved is defined in your JSON files
      "© ${DateTime.now().year} ${AppStrings.appName.tr()}. ${"allRightsReserved".tr()}",
      style: theme.textTheme.bodySmall?.copyWith(
            color: footerForegroundColor.withOpacity(0.7),
          ),
      textAlign: TextAlign.center,
    );

    Widget socialAndEmail = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.facebook, color: footerIconColor),
          tooltip: 'Facebook',
          onPressed: () {
            Helpers.launchUrlHelper(context, _facebookUrl);
          },
        ),
        const Gap(12),
        // IconButton(
        //   icon: const Icon(Icons.telegram, color: footerIconColor), // Assuming Telegram icon exists
        //   tooltip: 'Telegram',
        //   onPressed: () {
        //     Helpers.launchUrlHelper(context, _telegramUrl);
        //   },
        // ),
        const Gap(12),
        IconButton(
          icon: Icon(Icons.email, color: footerIconColor),
          tooltip: 'Email Us',
          onPressed: () {
            Helpers.launchUrlHelper(context, 'mailto:$_emailAddress');
          },
        ),
        const Gap(20),
        SelectableText( // Use SelectableText for email
          _emailAddress,
          style: theme.textTheme.bodyMedium?.copyWith(
                color: footerForegroundColor.withOpacity(0.7),
              ),
        ),
      ],
    );

    // Common container properties
    BoxDecoration footerDecoration = BoxDecoration(color: footerBackgroundColor);
    EdgeInsets footerPadding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingPageHorizontal,
      vertical: AppDimensions.paddingLarge,
    );

    if (screenWidth >= desktopBreakpoint) {
      // Desktop Layout
      return Container(
        decoration: footerDecoration,
        padding: footerPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo,
            copyright,
            socialAndEmail,
          ],
        ),
      );
    } else if (screenWidth >= tabletBreakpoint) {
      // Tablet Layout
      return Container(
        decoration: footerDecoration,
        padding: footerPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo,
                Expanded(child: Align(alignment: Alignment.centerRight, child: socialAndEmail)),
              ],
            ),
            const Gap(16),
            Center(child: copyright),
          ],
        ),
      );
    } else {
      // Mobile Layout
      return Container(
        decoration: footerDecoration,
        padding: footerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: logo),
            const Gap(16),
            Center(child: socialAndEmail), // Social icons might look better before copyright on mobile
            const Gap(16),
            Center(child: copyright),
          ],
        ),
      );
    }
  }
}
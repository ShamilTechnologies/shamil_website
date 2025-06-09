import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 🌐 Used for navigation
import 'package:shamil_web/core/widgets/modern_app_bar.dart'; // ✨ Your custom AppBar
import 'package:shamil_web/core/navigation/app_router.dart'; // 🧭 Defines app routes
import 'package:shamil_web/core/constants/app_strings.dart'; // 📜 String constants for localization
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart'; // ⬆️ Scroll-to-top button

// Importing section widgets as per the "old code" structure.
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/rocket_separator_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/mobile_app_pages_section.dart';
// import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart'; // EnhancedStepsSection is in this file
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/shamil_ai_showcase_section';
// import 'package:shamil_web/features/home/presentation/widgets/app_preview_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/testimonials_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/download_cta_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';


class HomeScreenSectionData {
  final String id;
  final String titleKey;
  final IconData icon;
  final String subtitleKey;
  final GlobalKey key;
  final Widget widget;
  final bool showInMenu;

  const HomeScreenSectionData({
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.subtitleKey,
    required this.key,
    required this.widget,
    this.showInMenu = true,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {

  late ScrollController _scrollController;
  late List<HomeScreenSectionData> _sections;

  final GlobalKey _heroKey = GlobalKey(debugLabel: 'HeroSectionKey');
  final GlobalKey _introKey = GlobalKey(debugLabel: 'IntroSectionKey');
  final GlobalKey _rocketSeparatorKey = GlobalKey(debugLabel: 'RocketSeparatorKey');
  final GlobalKey _mobileAppPagesKey = GlobalKey(debugLabel: 'MobileAppPagesKey');
  final GlobalKey _howItWorksKey = GlobalKey(debugLabel: 'HowItWorksKey');
  final GlobalKey _featuresKey = GlobalKey(debugLabel: 'FeaturesHighlightKey');
  final GlobalKey _aiShowcaseKey = GlobalKey(debugLabel: 'AiShowcaseKey'); // <-- KEY FOR NEW SECTION
  final GlobalKey _benefitsKey = GlobalKey(debugLabel: 'BenefitsSectionKey');
  final GlobalKey _testimonialsKey = GlobalKey(debugLabel: 'TestimonialsKey');
  final GlobalKey _downloadKey = GlobalKey(debugLabel: 'DownloadCTAKey');
  final GlobalKey _contactKey = GlobalKey(debugLabel: 'FooterContactKey');


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeSections();
  }

  void _initializeSections() {
    // This list defines the order of sections on the home page.
    _sections = [
      HomeScreenSectionData(
        id: 'hero',
        titleKey: '', // No title for menu
        icon: Icons.home_outlined,
        subtitleKey: '', // No subtitle for menu
        key: _heroKey,
        widget: const HeroSection(),
        showInMenu: false, // Typically Hero isn't in the jump-to menu
      ),
      HomeScreenSectionData(
        id: 'intro',
        titleKey: AppStrings.whatIsShamil,
        icon: Icons.info_outline_rounded,
        subtitleKey: 'learnMoreAboutShamil', // Example subtitle key
        key: _introKey,
        widget: const IntroSection(),
      ),
      HomeScreenSectionData(
        id: 'rocket_separator',
        titleKey: '', // No title for menu
        icon: Icons.rocket_launch_outlined,
        subtitleKey: '',
        key: _rocketSeparatorKey,
        widget: EnhancedRocketSeparatorSection(scrollController: _scrollController),
        showInMenu: false,
      ),
      HomeScreenSectionData(
        id: 'mobile_app_pages',
        titleKey: AppStrings.mobileAppPagesTitle,
        icon: Icons.phone_android_outlined,
        subtitleKey: 'seeOurAppInAction', // Example subtitle key
        key: _mobileAppPagesKey,
        widget: MobileAppPagesSection(scrollController: _scrollController),
      ),
       HomeScreenSectionData(
        id: 'ai_showcase', // Unique ID for the new section
        titleKey: 'AI Showcase', // Placeholder menu title, use AppStrings key
        icon: Icons.auto_awesome_outlined, // Icon for the menu
        subtitleKey: 'discoverAISolutions', // Placeholder menu subtitle, use AppStrings key
        key: _aiShowcaseKey,
        widget: const ShamilAiShowcaseSection(),
        showInMenu: true, // Decide if it should appear in the mobile jump-to menu
      ),
      HomeScreenSectionData(
        id: 'how_it_works',
        titleKey: AppStrings.howItWorksTitle,
        icon: Icons.integration_instructions_outlined,
        subtitleKey: 'learnHowShamilWorks', // Example subtitle key
        key: _howItWorksKey,
        widget: const EnhancedStepsSection(), // This is your "How it Works" / Steps section
      ),
      HomeScreenSectionData(
        id: 'features',
        titleKey: AppStrings.featuresTitle,
        icon: Icons.star_outline_rounded,
        subtitleKey: 'discoverPowerfulCapabilities', // Example subtitle key
        key: _featuresKey,
        widget: FeaturesHighlightSection(scrollController: _scrollController),
      ),
      HomeScreenSectionData(
        id: 'benefits',
        titleKey: AppStrings.whyChooseShamil,
        icon: Icons.verified_user_outlined,
        subtitleKey: 'advantagesOfUsingShamil', // Example subtitle key
        key: _benefitsKey,
        widget: const BenefitsSection(),
      ),
      HomeScreenSectionData(
        id: 'testimonials',
        titleKey: AppStrings.testimonialsTitle,
        icon: Icons.thumbs_up_down_outlined,
        subtitleKey: 'whatOurUsersSay', // Example subtitle key
        key: _testimonialsKey,
        widget: const TestimonialsSection(),
      ),
      HomeScreenSectionData(
        id: 'download',
        titleKey: AppStrings.downloadApp,
        icon: Icons.download_outlined,
        subtitleKey: 'getShamilOnYourDevice', // Example subtitle key
        key: _downloadKey,
        widget: const DownloadCtaSection(),
      ),
      HomeScreenSectionData(
        id: 'contact',
        titleKey: AppStrings.footerContact,
        icon: Icons.contact_support_outlined,
        subtitleKey: 'getInTouchWithUs', // Example subtitle key
        key: _contactKey,
        widget: FooterSection(scrollController: _scrollController),
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final currentContext = key.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0, // Scrolls so the top of the section is at the top of the viewport
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows content to go behind the AppBar
      backgroundColor: Theme.of(context).colorScheme.surface, // Fallback background
      appBar: ModernAppBar(
        scrollController: _scrollController,
        onMenuTap: _showMobileMenu, // Handler for mobile menu icon tap
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(), // Nice scroll physics
            child: Column(
              // Iterates through the _sections list and builds each section's widget
              children: _sections.map((sectionData) {
                return Container(
                  key: sectionData.key, // Assign the GlobalKey to the container for scrolling
                  child: sectionData.widget,
                );
              }).toList(),
            ),
          ),
          // Floating Action Button for scrolling to top
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScrollToTopFAB(scrollController: _scrollController),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the mobile menu (bottom sheet)
  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Sheet itself is transparent, content has color
      isScrollControlled: true, // Allows sheet to take more height
      enableDrag: true,
      builder: (context) => _buildMobileMenu(), // Builds the menu content
    );
  }

  // Builds the content of the mobile menu
  Widget _buildMobileMenu() {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Initial height of the sheet
      minChildSize: 0.4,   // Minimum height when dragging down
      maxChildSize: 0.9,   // Maximum height when dragging up
      builder: (context, scrollController) {
        // The visual container for the menu
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            gradient: LinearGradient( // Subtle gradient for the menu background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.light
                  ? [
                      Colors.white.withOpacity(0.98),
                      Colors.grey.shade100.withOpacity(0.97),
                    ]
                  : [
                      const Color(0xFF1A2332).withOpacity(0.98), // Darker shades for dark theme
                      const Color(0xFF0F1419).withOpacity(0.97),
                    ],
            ),
            border: Border.all( // Subtle border
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [ // Soft shadow for depth
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 35,
                spreadRadius: -5,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Menu Header
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16, top: 8, bottom: 16),
                child: Row(
                  children: [
                    Container( // Icon background with gradient
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.explore_outlined, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Text( // Menu title
                      'Explore Shamil', // Consider localizing
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton( // Close button
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      tooltip: "Close Menu", // Accessibility
                    ),
                  ],
                ),
              ),
              // Scrollable list of menu items
              Expanded(
                child: ListView(
                  controller: scrollController, // Use the controller from DraggableScrollableSheet
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Generate menu items from _sections list if showInMenu is true
                    ..._sections
                        .where((sectionData) => sectionData.showInMenu)
                        .map((sectionData) => _buildMenuItem(
                              sectionData.titleKey.tr(), // Localized title
                              sectionData.icon,
                              sectionData.subtitleKey.tr(), // Localized subtitle
                              () => _scrollToSection(sectionData.key), // Scroll action
                              theme,
                            ))
                        .toList(),
                    Padding( // Divider
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: theme.colorScheme.outline.withOpacity(0.2), height: 1),
                    ),
                    // Special menu item for "Provider Services"
                    _buildProviderMenuItem(theme),
                    const SizedBox(height: 30), // Bottom padding
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds a single menu item
  Widget _buildMenuItem(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Card( // Using Card for a slightly elevated look
      elevation: 0, // Subtle elevation
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primary.withOpacity(0.03), // Very light background
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close menu
          onTap(); // Perform action
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.secondary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container( // Icon background
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient( // Gradient for icon background
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded( // Text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[ // Show subtitle only if it exists
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.65),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon( // Forward arrow icon
                Icons.arrow_forward_ios_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the "Provider Services" menu item
  Widget _buildProviderMenuItem(ThemeData theme) {
    return Card(
      elevation: 1, // Slightly more prominent
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.primary, // Primary color background
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close menu
          Future.delayed(const Duration(milliseconds: 50), () { // Slight delay for smoother transition
            if (mounted) {
              context.go(AppRouter.providerServicesPath); // Navigate
            }
          });
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: theme.colorScheme.secondary.withOpacity(0.3),
        highlightColor: theme.colorScheme.secondary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container( // Icon background
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.storefront_outlined, color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded( // Text content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.joinProvider.tr(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary, // Text color on primary background
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Grow your business with Shamil', // Subtitle
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon( // Decorative icon
                Icons.rocket_launch_outlined,
                color: theme.colorScheme.onPrimary.withOpacity(0.9),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/home/presentation/screens/home_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/navigation/app_router.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';

// Importing section widgets as per the "old code" structure.
// Verify these paths align with your project's file organization.
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/rocket_separator_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/mobile_app_pages_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/app_preview_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/testimonials_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/download_cta_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';


/// Data class to define properties for each section on the HomeScreen.
/// This promotes a flexible and maintainable way to manage page content and navigation.
class HomeScreenSectionData {
  final String id; // Unique identifier for the section (e.g., 'hero', 'features')
  final String titleKey; // Localization key for the section's title in the mobile menu
  final IconData icon; // Icon to display in the mobile menu for this section
  final String subtitleKey; // Localization key for the section's subtitle in the mobile menu
  final GlobalKey key; // GlobalKey for scrolling to this section
  final Widget widget; // The actual widget for this section
  final bool showInMenu; // Flag to determine if this section should appear in the mobile menu

  const HomeScreenSectionData({
    required this.id,
    required this.titleKey,
    required this.icon,
    required this.subtitleKey,
    required this.key,
    required this.widget,
    this.showInMenu = true, // Default to showing in menu for easy toggling
  });
}

/// 🚀 Enhanced Home Screen - Flexible, Smooth, Clean & Organized
/// This screen uses a data-driven approach to build its sections and mobile menu,
/// making it easier to update, reorder, and maintain the page structure.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin { // TickerProviderStateMixin for animations within this screen or passed down
  late ScrollController _scrollController;
  // Example: If multiple sections need a shared animation controller (e.g., a parallax or floating effect controller)
  // late AnimationController _sharedAnimationController;

  late List<HomeScreenSectionData> _sections;

  // GlobalKeys for each section to enable scrolling and unique identification.
  // These are used in _initializeSections to link data to specific parts of the page.
  final GlobalKey _heroKey = GlobalKey(debugLabel: 'HeroSectionKey');
  final GlobalKey _introKey = GlobalKey(debugLabel: 'IntroSectionKey');
  final GlobalKey _rocketSeparatorKey = GlobalKey(debugLabel: 'RocketSeparatorKey');
  final GlobalKey _mobileAppPagesKey = GlobalKey(debugLabel: 'MobileAppPagesKey');
  final GlobalKey _howItWorksKey = GlobalKey(debugLabel: 'HowItWorksKey');
  final GlobalKey _featuresKey = GlobalKey(debugLabel: 'FeaturesHighlightKey');
  final GlobalKey _benefitsKey = GlobalKey(debugLabel: 'BenefitsSectionKey');
  final GlobalKey _appPreviewKey = GlobalKey(debugLabel: 'AppPreviewKey');
  final GlobalKey _testimonialsKey = GlobalKey(debugLabel: 'TestimonialsKey');
  final GlobalKey _downloadKey = GlobalKey(debugLabel: 'DownloadCTAKey');
  final GlobalKey _contactKey = GlobalKey(debugLabel: 'FooterContactKey');


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initialize any shared animation controllers here if they are needed by child sections.
    // For example:
    // _sharedAnimationController = AnimationController(
    //   duration: const Duration(seconds: 8), // Adjust duration as needed
    //   vsync: this,
    // )..repeat(reverse: true);

    _initializeSections(); // Centralized method to define all page sections
  }
  
  /// Initializes the list of sections that make up the HomeScreen.
  /// This data-driven approach centralizes the page structure definition.
  void _initializeSections() {
    // Define all sections of the home page.
    // Ensure that `titleKey` and `subtitleKey` correspond to valid keys
    // in your localization files (e.g., en.json, ar.json) and are defined in AppStrings.dart.
    _sections = [
      HomeScreenSectionData(
        id: 'hero',
        titleKey: '', // Hero section typically doesn't have a menu item to scroll to itself
        icon: Icons.home_outlined, // Placeholder icon, not shown in menu if showInMenu is false
        subtitleKey: '', // Placeholder subtitle, not shown in menu
        key: _heroKey,
        // If your HeroSection or other sections require a shared controller, pass it here.
        // Example: widget: HeroSection(floatingController: _sharedAnimationController),
        widget: const HeroSection(), // Using HeroSection from "old code"
        showInMenu: false, // Hero section is usually not listed in a navigation menu
      ),
      HomeScreenSectionData(
        id: 'intro',
        titleKey: AppStrings.whatIsShamil, // Ensure this key exists in AppStrings and translations
        icon: Icons.info_outline_rounded,
        subtitleKey: 'learnMoreAboutShamil', // Create this localization key
        key: _introKey,
        widget: const IntroSection(), // Using IntroSection from "old code"
      ),
      HomeScreenSectionData(
        id: 'rocket_separator',
        titleKey: '', // Separator sections usually don't appear in navigation menus
        icon: Icons.rocket_launch_outlined, // Placeholder icon
        subtitleKey: '', // Placeholder subtitle
        key: _rocketSeparatorKey, // Key might not be strictly necessary if not a scroll target
        widget: EnhancedRocketSeparatorSection(scrollController: _scrollController), // From "old code"
        showInMenu: false,
      ),
      HomeScreenSectionData(
        id: 'mobile_app_pages',
        titleKey: AppStrings.mobileAppPagesTitle, // Ensure this key exists
        icon: Icons.phone_android_outlined,
        subtitleKey: 'seeOurAppInAction', // Create this localization key
        key: _mobileAppPagesKey,
        widget: MobileAppPagesSection(scrollController: _scrollController), // From "old code"
      ),
      HomeScreenSectionData(
        id: 'how_it_works',
        titleKey: AppStrings.howItWorksTitle,
        icon: Icons.integration_instructions_outlined,
        subtitleKey: 'learnHowShamilWorks', // Create this localization key
        key: _howItWorksKey,
        widget: const HowItWorksSection(), // From "old code"
      ),
      HomeScreenSectionData(
        id: 'features',
        titleKey: AppStrings.featuresTitle,
        icon: Icons.star_outline_rounded,
        subtitleKey: 'discoverPowerfulCapabilities', // Create this localization key
        key: _featuresKey,
        widget: FeaturesHighlightSection(scrollController: _scrollController), // From "old code"
      ),
      HomeScreenSectionData(
        id: 'benefits',
        titleKey: AppStrings.whyChooseShamil, // Title for the Benefits section in the menu
        icon: Icons.verified_user_outlined,
        subtitleKey: 'advantagesOfUsingShamil', // Create this localization key
        key: _benefitsKey,
        widget: const BenefitsSection(), // Using BenefitsSection from "old code"
      ),
      HomeScreenSectionData(
        id: 'testimonials',
        titleKey: AppStrings.testimonialsTitle,
        icon: Icons.thumbs_up_down_outlined,
        subtitleKey: 'whatOurUsersSay', // Create this localization key
        key: _testimonialsKey,
        widget: const TestimonialsSection(), // From "old code"
      ),
      HomeScreenSectionData(
        id: 'download',
        titleKey: AppStrings.downloadApp,
        icon: Icons.download_outlined,
        subtitleKey: 'getShamilOnYourDevice', // Create this localization key
        key: _downloadKey,
        widget: const DownloadCtaSection(), // From "old code"
      ),
      HomeScreenSectionData(
        id: 'contact',
        titleKey: AppStrings.footerContact, // Using a suitable key from AppStrings
        icon: Icons.contact_support_outlined,
        subtitleKey: 'getInTouchWithUs', // Create this localization key
        key: _contactKey,
        widget: FooterSection(scrollController: _scrollController), // From "old code"
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // if (_sharedAnimationController != null) _sharedAnimationController.dispose(); // Dispose if initialized
    super.dispose();
  }

  /// Scrolls to the section associated with the given GlobalKey.
  void _scrollToSection(GlobalKey key) {
    final currentContext = key.currentContext;
    if (currentContext != null) {
      Scrollable.ensureVisible(
        currentContext,
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeInOutCubic, 
        alignment: 0.0, // Aligns the top of the section with the top of the viewport
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Theme.of(context).colorScheme.surface, 
      appBar: ModernAppBar( 
        scrollController: _scrollController,
        onMenuTap: _showMobileMenu, 
      ),
      body: Stack( 
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(), 
            child: Column(
              // Dynamically build the page sections from the _sections list
              children: _sections.map((sectionData) {
                // Each section is wrapped in a Container with its GlobalKey
                // to enable `Scrollable.ensureVisible`.
                return Container(
                  key: sectionData.key,
                  child: sectionData.widget,
                );
              }).toList(),
            ),
          ),
          // Scroll-to-top button, aligned to the bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0), 
              child: ScrollToTopFAB(scrollController: _scrollController), // Correctly instantiated as a widget
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the mobile navigation menu as a modal bottom sheet.
  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, 
      isScrollControlled: true, 
      enableDrag: true, 
      builder: (context) => _buildMobileMenu(), 
    );
  }

  /// Builds the UI for the mobile navigation menu.
  Widget _buildMobileMenu() {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7, 
      minChildSize: 0.4,   
      maxChildSize: 0.9,   
      builder: (context, scrollController) { 
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.light
                  ? [
                      Colors.white.withOpacity(0.98),
                      Colors.grey.shade100.withOpacity(0.97),
                    ]
                  : [
                      const Color(0xFF1A2332).withOpacity(0.98), 
                      const Color(0xFF0F1419).withOpacity(0.97),
                    ],
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
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
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 16, top: 8, bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.explore_outlined, 
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Explore Shamil', 
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      tooltip: "Close Menu",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Dynamically generate menu items from sections marked `showInMenu`
                    ..._sections
                        .where((sectionData) => sectionData.showInMenu)
                        .map((sectionData) => _buildMenuItem(
                              sectionData.titleKey.tr(), 
                              sectionData.icon,
                              sectionData.subtitleKey.tr(), 
                              () => _scrollToSection(sectionData.key), 
                              theme,
                            ))
                        ,
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                        height: 1,
                      ),
                    ),
                    
                    _buildProviderMenuItem(theme),
                    
                    const SizedBox(height: 30), 
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a standard menu item widget.
  Widget _buildMenuItem(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0, 
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primary.withOpacity(0.03), 
      child: InkWell(
        onTap: () {
          Navigator.pop(context); 
          onTap(); 
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.secondary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                    if (subtitle.isNotEmpty) ...[
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
              Icon(
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

  /// Builds the special "Join as Provider" menu item.
  Widget _buildProviderMenuItem(ThemeData theme) {
    return Card(
      elevation: 1, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: theme.colorScheme.primary, 
      child: InkWell(
        onTap: () {
          Navigator.pop(context); 
          context.go(AppRouter.providerServicesPath); 
        },
        borderRadius: BorderRadius.circular(18),
        splashColor: theme.colorScheme.secondary.withOpacity(0.3),
        highlightColor: theme.colorScheme.secondary.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.storefront_outlined, 
                  color: theme.colorScheme.primary, 
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.joinProvider.tr(), 
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary, 
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Grow your business with Shamil', 
                       style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
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

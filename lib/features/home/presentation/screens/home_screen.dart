import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 🌐 Used for navigation
import 'package:shamil_web/core/widgets/modern_app_bar.dart'; // ✨ Your custom AppBar
import 'package:shamil_web/core/navigation/app_router.dart'; // 🧭 Defines app routes
import 'package:shamil_web/core/constants/app_strings.dart'; // 📜 String constants for localization
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart'; // ⬆️ Scroll-to-top button

// Importing section widgets as per the "old code" structure.
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/rocket_separator_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/mobile_app_pages_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
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
  final GlobalKey _benefitsKey = GlobalKey(debugLabel: 'BenefitsSectionKey');
  // final GlobalKey _appPreviewKey = GlobalKey(debugLabel: 'AppPreviewKey');
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
    _sections = [
      HomeScreenSectionData(
        id: 'hero',
        titleKey: '',
        icon: Icons.home_outlined,
        subtitleKey: '',
        key: _heroKey,
        widget: const HeroSection(),
        showInMenu: false,
      ),
      HomeScreenSectionData(
        id: 'intro',
        titleKey: AppStrings.whatIsShamil,
        icon: Icons.info_outline_rounded,
        subtitleKey: 'learnMoreAboutShamil',
        key: _introKey,
        widget: const IntroSection(),
      ),
      HomeScreenSectionData(
        id: 'rocket_separator',
        titleKey: '',
        icon: Icons.rocket_launch_outlined,
        subtitleKey: '',
        key: _rocketSeparatorKey,
        // Assuming EnhancedRocketSeparatorSection is defined and imported
        widget: EnhancedRocketSeparatorSection(scrollController: _scrollController),
        showInMenu: false,
      ),
      HomeScreenSectionData(
        id: 'mobile_app_pages',
        titleKey: AppStrings.mobileAppPagesTitle,
        icon: Icons.phone_android_outlined,
        subtitleKey: 'seeOurAppInAction',
        key: _mobileAppPagesKey,
        widget: MobileAppPagesSection(scrollController: _scrollController),
      ),
      HomeScreenSectionData(
        id: 'how_it_works',
        titleKey: AppStrings.howItWorksTitle,
        icon: Icons.integration_instructions_outlined,
        subtitleKey: 'learnHowShamilWorks',
        key: _howItWorksKey,
        widget: const HowItWorksSection(),
      ),
      HomeScreenSectionData(
        id: 'features',
        titleKey: AppStrings.featuresTitle,
        icon: Icons.star_outline_rounded,
        subtitleKey: 'discoverPowerfulCapabilities',
        key: _featuresKey,
        widget: FeaturesHighlightSection(scrollController: _scrollController),
      ),
      HomeScreenSectionData(
        id: 'benefits',
        titleKey: AppStrings.whyChooseShamil,
        icon: Icons.verified_user_outlined,
        subtitleKey: 'advantagesOfUsingShamil',
        key: _benefitsKey,
        widget: const BenefitsSection(),
      ),
      HomeScreenSectionData(
        id: 'testimonials',
        titleKey: AppStrings.testimonialsTitle,
        icon: Icons.thumbs_up_down_outlined,
        subtitleKey: 'whatOurUsersSay',
        key: _testimonialsKey,
        widget: const TestimonialsSection(),
      ),
      HomeScreenSectionData(
        id: 'download',
        titleKey: AppStrings.downloadApp,
        icon: Icons.download_outlined,
        subtitleKey: 'getShamilOnYourDevice',
        key: _downloadKey,
        widget: const DownloadCtaSection(),
      ),
      HomeScreenSectionData(
        id: 'contact',
        titleKey: AppStrings.footerContact,
        icon: Icons.contact_support_outlined,
        subtitleKey: 'getInTouchWithUs',
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
        alignment: 0.0,
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
              children: _sections.map((sectionData) {
                return Container(
                  key: sectionData.key,
                  child: sectionData.widget,
                );
              }).toList(),
            ),
          ),
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

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => _buildMobileMenu(),
    );
  }

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
                    _buildProviderMenuItem(theme), // THIS IS THE RELEVANT MENU ITEM
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
          Navigator.pop(context); // Close the menu first
          onTap(); // Then perform the scroll action
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

  /// Special menu item for navigating to the "Provider Services" page.
  Widget _buildProviderMenuItem(ThemeData theme) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: () {
          // 1. Close the menu first
          Navigator.pop(context);

          // 2. OPTIONAL: Add a very short delay.
          // This allows the modal dismiss animation to complete before starting
          // the new route transition, which can feel smoother.
          // The main "delay" fix is on the ProviderServicesScreen itself.
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) { // Always check 'mounted' after an async gap
              context.go(AppRouter.providerServicesPath); // Navigate using GoRouter
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
                      AppStrings.joinProvider.tr(), // "Join as Provider"
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
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
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/navigation/app_router.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
import 'package:shamil_web/core/widgets/stylized_loading_indicator.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/download_cta_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/mobile_app_pages_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/Rocket_Separator_Section.dart';
import 'package:shamil_web/features/home/presentation/widgets/services_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/ShamilShowcaseSection.dart';
import 'package:shamil_web/features/home/presentation/widgets/testimonials_section.dart';

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

// OPTIMIZATION 1: Added 'AutomaticKeepAliveClientMixin'
// This is a critical optimization for this specific use case. It tells Flutter
// to keep the state of each section alive even when it's scrolled off-screen.
// This prevents any "hiccup" or "reload" when scrolling back up, making the
// experience extremely fluid and flexible.
class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late List<HomeScreenSectionData> _sections;

  bool _isContentLoaded = false;

  final GlobalKey _heroKey = GlobalKey(debugLabel: 'HeroSectionKey');
  final GlobalKey _introKey = GlobalKey(debugLabel: 'IntroSectionKey');
  final GlobalKey _servicesKey = GlobalKey(debugLabel: 'ServicesSectionKey');
  final GlobalKey _rocketSeparatorKey =
      GlobalKey(debugLabel: 'RocketSeparatorKey');
  final GlobalKey _mobileAppPagesKey =
      GlobalKey(debugLabel: 'MobileAppPagesKey');
  final GlobalKey _howItWorksKey = GlobalKey(debugLabel: 'HowItWorksKey');
  final GlobalKey _featuresKey = GlobalKey(debugLabel: 'FeaturesHighlightKey');
  final GlobalKey _aiShowcaseKey = GlobalKey(debugLabel: 'AiShowcaseKey');
  final GlobalKey _benefitsKey = GlobalKey(debugLabel: 'BenefitsSectionKey');
  final GlobalKey _testimonialsKey =
      GlobalKey(debugLabel: 'TestimonialsKey');
  final GlobalKey _downloadKey = GlobalKey(debugLabel: 'DownloadCTAKey');
  final GlobalKey _contactKey = GlobalKey(debugLabel: 'FooterContactKey');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeSections();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _isContentLoaded = true;
        });
      }
    });
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
        subtitleKey: AppStrings.learnMoreAboutShamil,
        key: _introKey,
        widget: const IntroSection(),
      ),
      HomeScreenSectionData(
        id: 'rocket_separator',
        titleKey: '',
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
        subtitleKey: AppStrings.seeOurAppInAction,
        key: _mobileAppPagesKey,
        widget: MobileAppPagesSection(scrollController: _scrollController),
      ),
      HomeScreenSectionData(
        id: 'services',
        titleKey: AppStrings.servicesTitle,
        icon: Icons.design_services_outlined,
        subtitleKey: AppStrings.exploreOurOfferings,
        key: _servicesKey,
        widget: const ServicesSection(),
      ),
      HomeScreenSectionData(
        id: 'how_it_works',
        titleKey: AppStrings.howItWorksTitle,
        icon: Icons.integration_instructions_outlined,
        subtitleKey: AppStrings.learnHowShamilWorks,
        key: _howItWorksKey,
        widget: const EnhancedStepsSection(),
      ),
      HomeScreenSectionData(
        id: 'features',
        titleKey: AppStrings.featuresTitle,
        icon: Icons.star_outline_rounded,
        subtitleKey: AppStrings.discoverPowerfulCapabilities,
        key: _featuresKey,
        widget: FeaturesHighlightSection(scrollController: _scrollController),
      ),
      HomeScreenSectionData(
        id: 'testimonials',
        titleKey: AppStrings.testimonialsTitle,
        icon: Icons.thumbs_up_down_outlined,
        subtitleKey: AppStrings.whatOurUsersSay,
        key: _testimonialsKey,
        widget: const TestimonialsSection(),
      ),
      HomeScreenSectionData(
        id: 'download',
        titleKey: AppStrings.downloadApp,
        icon: Icons.download_outlined,
        subtitleKey: AppStrings.getShamilOnYourDevice,
        key: _downloadKey,
        widget: const DownloadCtaSection(),
      ),
      HomeScreenSectionData(
        id: 'contact',
        titleKey: AppStrings.footerContact,
        icon: Icons.contact_support_outlined,
        subtitleKey: AppStrings.getInTouchWithUs,
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

  // OPTIMIZATION 2: This is required by AutomaticKeepAliveClientMixin.
  // Returning 'true' activates the keep-alive behavior.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // OPTIMIZATION 3: This is also required by the mixin.
    // It registers this widget with the framework to be kept alive.
    super.build(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ModernAppBar(
        scrollController: _scrollController,
        onMenuTap: _showMobileMenu,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _isContentLoaded
            ? Stack(
                key: const ValueKey('content'),
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final sectionData = _sections[index];
                      // OPTIMIZATION 4: Wrapped each section in a 'RepaintBoundary'.
                      // This is the most powerful optimization here. It creates a
                      // separate rendering layer for each section. Any animation or
                      // visual update inside a section will not affect any other
                      // section, preventing cascading repaints and ensuring
                      // the scroll performance is exceptionally smooth.
                      return RepaintBoundary(
                        child: Container(
                          key: sectionData.key,
                          child: sectionData.widget,
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          ScrollToTopFAB(scrollController: _scrollController),
                    ),
                  ),
                ],
              )
            : const StylizedLoadingIndicator(key: ValueKey('loading')),
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
            color: theme.cardColor.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      child: Divider(color: theme.dividerColor, height: 1),
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

  Widget _buildMenuItem(
      String title, IconData icon, String subtitle, VoidCallback onTap, ThemeData theme) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildProviderMenuItem(ThemeData theme) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              context.go(AppRouter.providerServicesPath);
            }
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.storefront_outlined,
                  color: theme.colorScheme.onPrimary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.joinProvider.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'Grow your business with Shamil',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

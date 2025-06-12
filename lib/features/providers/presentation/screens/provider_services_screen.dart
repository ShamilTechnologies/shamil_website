import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
// ADDED: Imported the animated gradient background to be used on this screen.
import 'package:shamil_web/features/common/widgets/animated_gradient_background.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_hero_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_how_it_works_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_features_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_pricing_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_faq_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_cta_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_dashboard_demo_cta_section.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

// OPTIMIZATION 1: Added 'AutomaticKeepAliveClientMixin'.
// This mixin ensures that the state of this screen is preserved, which works
// with the ListView to keep scrolled-off sections in memory. This provides
// an incredibly fluid and flexible scrolling experience, as widgets don't
// need to be rebuilt when you scroll back to them.
class _ProviderServicesScreenState extends State<ProviderServicesScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late AnimationController _pageEntryController;
  late AnimationController _floatingParticlesController;
  late List<Widget> _providerSections;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeProviderSections();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageEntryController.forward();
      }
    });
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _pageEntryController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _floatingParticlesController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  void _initializeProviderSections() {
    _providerSections = [
      ProviderHeroSection(
        floatingParticlesController: _floatingParticlesController,
      ),
      ProviderHowItWorksSection(
        scrollController: _scrollController,
      ),
      ProviderFeaturesSection(
        scrollController: _scrollController,
      ),
      const ProviderDashboardDemoCtaSection(),
      const ProviderPricingSection(),
      const ProviderFaqSection(),
      ProviderCtaSection(
        floatingParticlesController: _floatingParticlesController,
      ),
      FooterSection(
        scrollController: _scrollController,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageEntryController.dispose();
    _floatingParticlesController.dispose();
    super.dispose();
  }

  // OPTIMIZATION 2: Required by AutomaticKeepAliveClientMixin.
  // Returning 'true' here is what activates the keep-alive behavior.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // OPTIMIZATION 3: This call is also required by the mixin to register
    // the widget for preservation.
    super.build(context);

    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      appBar: ModernAppBar(scrollController: _scrollController),
      body: Stack(
        children: [
          // ADDED: Placed the AnimatedGradientBackground here. This removes the solid color
          // from behind the AppBar and replaces it with a dynamic gradient, creating a
          // seamless look where the AppBar floats over the content.
          const AnimatedGradientBackground(),
          Animate(
            controller: _pageEntryController,
            effects: const [
              FadeEffect(duration: Duration(milliseconds: 500), curve: Curves.easeOut)
            ],
            // OPTIMIZATION 4: Replaced the inefficient SingleChildScrollView + Column
            // with a highly performant ListView.builder. This is the core change
            // that guarantees smooth scrolling by only building visible sections.
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: _providerSections.length,
              itemBuilder: (context, index) {
                // OPTIMIZATION 5: Wrapped each section in a RepaintBoundary.
                // This is a powerful optimization that gives each section its
                // own drawing layer. It prevents any animations or updates
                // in one section from causing any other section to repaint,
                // which is essential for a "very very smooth" scroll.
                return RepaintBoundary(
                  child: _providerSections[index],
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ScrollToTopFAB(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }
}

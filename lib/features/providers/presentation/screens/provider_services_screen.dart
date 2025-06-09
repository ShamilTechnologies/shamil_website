// lib/features/providers/presentation/screens/provider_services_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';

// Import all the provider section widgets
import 'package:shamil_web/features/providers/widgets/provider_hero_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_how_it_works_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_features_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_pricing_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_faq_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_cta_section.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen>
    with TickerProviderStateMixin {
  // --- CONTROLLERS ---
  late ScrollController _scrollController;
  late AnimationController _pageEntryController;
  late AnimationController _backgroundAnimationController;
  // ** FIX: Re-added the required controller for particles. **
  late AnimationController _floatingParticlesController;

  // --- STATE ---
  late List<Widget> _providerSections;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeProviderSections();

    // Simulate a short delay before showing content.
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _pageEntryController.forward();
      }
    });
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _pageEntryController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _backgroundAnimationController = AnimationController(
        duration: const Duration(seconds: 25), vsync: this)
      ..repeat(reverse: true);
      
    // ** FIX: Initialize the floating particles controller. **
    _floatingParticlesController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  /// This list is now built only once, which is critical for stability.
  void _initializeProviderSections() {
    _providerSections = [
      ProviderHeroSection(
        key: const ValueKey("provider_hero"),
        // ** FIX: Pass the required controller to the widget. **
        floatingParticlesController: _floatingParticlesController,
      ),
      ProviderHowItWorksSection(
        key: const ValueKey("provider_how_it_works"),
        scrollController: _scrollController,
      ),
      ProviderFeaturesSection(
        key: const ValueKey("provider_features"),
        scrollController: _scrollController,
      ),
      const ProviderPricingSection(
        key: ValueKey("provider_pricing")
      ),
      const ProviderFaqSection(
        key: ValueKey("provider_faq")
      ),
      ProviderCtaSection(
        key: const ValueKey("provider_cta"),
        // ** FIX: Pass the required controller to the widget. **
        floatingParticlesController: _floatingParticlesController,
      ),
      FooterSection(
        key: const ValueKey("footer_section_provider"),
        scrollController: _scrollController,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageEntryController.dispose();
    _backgroundAnimationController.dispose();
    // ** FIX: Dispose the added controller. **
    _floatingParticlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      appBar: ModernAppBar(scrollController: _scrollController),
      body: Stack(
        children: [
          _buildAnimatedBackground(theme),
          Animate(
            controller: _pageEntryController,
            effects: const [
              FadeEffect(duration: Duration(milliseconds: 500), curve: Curves.easeOut)
            ],
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(children: _providerSections),
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

  Widget _buildAnimatedBackground(ThemeData theme) {
    // This background is simple and less likely to cause issues.
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.surface.withOpacity(0.0),
          ],
          stops: const [0.0, 0.4],
        ),
      ),
    );
  }
}
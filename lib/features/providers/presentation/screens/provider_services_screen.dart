import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_cta_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_faq_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_features_section.dart';

// Ensure all these paths are correct and the widgets are defined in these files
import 'package:shamil_web/features/providers/widgets/provider_hero_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_how_it_works_section.dart';
import 'package:shamil_web/features/providers/widgets/provider_pricing_section.dart';

class ProviderServicesScreen extends StatefulWidget {
  const ProviderServicesScreen({super.key});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _floatingParticlesController;
  late AnimationController _pageEntryController;
  late AnimationController _backgroundAnimationController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("[ProviderServicesScreen - DEBUG] initState: Called");
    _initializeControllers();
    _setupScrollListener();

    Future.delayed(const Duration(milliseconds: 300), () {
      print("[ProviderServicesScreen - DEBUG] initState: Initial delay complete. Setting _isLoading to false.");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // _pageEntryController.forward() is handled in _initializeControllers post-load
      }
    });
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _floatingParticlesController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    _pageEntryController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isLoading) {
        print("[ProviderServicesScreen - DEBUG] _initializeControllers: Triggering page entry animation.");
        _pageEntryController.forward();
      }
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(_trackSectionVisibility);
  }

  void _trackSectionVisibility() {
    // Your analytics tracking implementation
  }

  @override
  void dispose() {
    print("[ProviderServicesScreen - DEBUG] dispose: Called");
    _scrollController.removeListener(_trackSectionVisibility);
    _scrollController.dispose();
    _floatingParticlesController.dispose();
    _pageEntryController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _backgroundAnimationController.value, -1 + 2 * _backgroundAnimationController.value),
              end: Alignment(1 - 2 * _backgroundAnimationController.value, 1 - 2 * _backgroundAnimationController.value),
              colors: theme.brightness == Brightness.light
                  ? [
                      theme.colorScheme.surface,
                      theme.colorScheme.primary.withOpacity(0.02),
                      theme.colorScheme.secondary.withOpacity(0.01),
                      theme.colorScheme.surface,
                    ]
                  : [
                      theme.colorScheme.surface,
                      theme.colorScheme.primary.withOpacity(0.05),
                      theme.colorScheme.secondary.withOpacity(0.03),
                      theme.colorScheme.surface,
                    ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("[ProviderServicesScreen - DEBUG] build: Called. _isLoading = $_isLoading");

    if (_isLoading) {
      print("[ProviderServicesScreen - DEBUG] build: Showing loading indicator.");
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: const Text("Loading Provider Services...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    print("[ProviderServicesScreen - DEBUG] build: Building main content with sections.");
    // --- !!! IMPORTANT: MODIFY THIS LIST FOR TESTING !!! ---
    final List<Widget> providerSections = [
      // 1. Start with all sections below commented out.
      // 2. Uncomment ONE section at a time, starting with ProviderHeroSection.
      // 3. After uncommenting a section, STOP & RESTART your app and test.
      // 4. If the error appears, the LAST section you uncommented is the problem.

      ProviderHeroSection(
         key: const ValueKey("provider_hero"),
         floatingParticlesController: _floatingParticlesController,
      ),
      ProviderHowItWorksSection(
         key: const ValueKey("provider_how_it_works"),
         scrollController: _scrollController,
      ),
      // const ProviderFeaturesSection( // Example: Test this next
      //   key: ValueKey("provider_features"),
      //   scrollController: _scrollController, // Pass if needed
      // ),
      // const ProviderTestimonialsSection(
      //    key: ValueKey("provider_testimonials"),
      // ),
      const ProviderPricingSection( // We suspect this one, test it carefully
         key: ValueKey("provider_pricing"),
      ),
       const ProviderFaqSection(
         key: ValueKey("provider_faq"),
       ),
      ProviderCtaSection(
        key: const ValueKey("provider_cta"),
        floatingParticlesController: _floatingParticlesController,
       ),
      FooterSection(
        key: const ValueKey("footer_section_provider"),
        scrollController: _scrollController,
      ),
    ];
    print("[ProviderServicesScreen - DEBUG] build: providerSections populated. Count: ${providerSections.length}");
    if (providerSections.isEmpty && mounted) { // Added mounted check
         print("[ProviderServicesScreen - DEBUG] build: providerSections IS EMPTY! Displaying empty message.");
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
              FadeEffect(duration: Duration(milliseconds: 800), curve: Curves.easeOut),
            ],
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: providerSections.isEmpty
                  ? [Container(height: 300, alignment:Alignment.center, child: const Text("No sections are currently enabled for testing.", style: TextStyle(fontSize: 18, color: Colors.orange)))]
                  : providerSections.map((section) {
                      print("[ProviderServicesScreen - DEBUG] build: Building section: ${section.key ?? section.runtimeType}");
                      return section;
                    }).toList(),
              ),
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
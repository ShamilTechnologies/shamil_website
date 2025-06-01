  import 'package:flutter/material.dart';
  import 'package:flutter_animate/flutter_animate.dart';
  import 'package:shamil_web/core/widgets/modern_app_bar.dart';
  import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
  import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';

  // Ensure these paths are correct and the widgets are defined
  import 'package:shamil_web/features/providers/widgets/provider_cta_section.dart';
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

    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      print("[ProviderServicesScreen - SECTION TEST] initState: Called");

      _scrollController = ScrollController();
      _floatingParticlesController = AnimationController(
        duration: const Duration(seconds: 25),
        vsync: this,
      )..repeat();
      _pageEntryController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );

      // Using a shorter delay now that we know the basic screen works.
      // This just ensures the loading indicator is briefly visible.
      Future.delayed(const Duration(milliseconds: 500), () {
        print("[ProviderServicesScreen - SECTION TEST] initState: Loading complete. Setting _isLoading to false.");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              print("[ProviderServicesScreen - SECTION TEST] initState: Triggering page entry animation.");
              _pageEntryController.forward();
            }
          });
        }
      });
    }

    @override
    void dispose() {
      print("[ProviderServicesScreen - SECTION TEST] dispose: Called");
      _scrollController.dispose();
      _floatingParticlesController.dispose();
      _pageEntryController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      print("[ProviderServicesScreen - SECTION TEST] build: Called. _isLoading = $_isLoading");

      if (_isLoading) {
        print("[ProviderServicesScreen - SECTION TEST] build: Showing loading indicator.");
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          appBar: AppBar(
            title: const Text("Loading Provider Sections..."),
            automaticallyImplyLeading: false, // Assuming ModernAppBar handles this
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      print("[ProviderServicesScreen - SECTION TEST] build: Attempting to build main content with sections.");

      // --- !!! IMPORTANT DEBUGGING STEP !!! ---
      // Add your sections back ONE BY ONE.
      // 1. Start with an empty list or just one simple container. Test.
      // 2. Add ProviderHeroSection. Test.
      // 3. Add ProviderHowItWorksSection. Test.
      // And so on...
      final List<Widget> providerSections = [
        // STEP 1: Start with this simple container. Does it show?
        // If yes, comment it out and proceed to uncomment your actual sections one by one.
        // Container(height: 200, color: Colors.greenAccent, alignment: Alignment.center, child: Text("Test Container - Start Here")),

        // STEP 2: Uncomment ProviderHeroSection ONLY. Test. If blank, this is the problem.
        ProviderHeroSection(key: const ValueKey("provider_hero"), floatingParticlesController: _floatingParticlesController),

        // STEP 3: If ProviderHeroSection worked, comment it back in, then uncomment ProviderHowItWorksSection. Test.
        ProviderHowItWorksSection(key: const ValueKey("provider_how_it_works"), scrollController: _scrollController),

        // STEP 4: Continue for each section...
        const ProviderPricingSection(key: ValueKey("provider_pricing")),
        // ProviderCtaSection(key: const ValueKey("provider_cta"), floatingParticlesController: _floatingParticlesController),
        // FooterSection(key: const ValueKey("footer_section_provider"), scrollController: _scrollController),
      ];
      print("[ProviderServicesScreen - SECTION TEST] build: providerSections populated. Count: ${providerSections.length}");
      if (providerSections.isEmpty){
          print("[ProviderServicesScreen - SECTION TEST] build: providerSections IS EMPTY! Displaying message.");
      }


      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: ModernAppBar( // Assuming ModernAppBar is working correctly
          scrollController: _scrollController,
        ),
        body: Animate(
          controller: _pageEntryController,
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 500), curve: Curves.easeOut),
            SlideEffect(begin: Offset(0, 0.02), end: Offset.zero, duration: Duration(milliseconds: 500), curve: Curves.easeOut)
          ],
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: providerSections.isEmpty
                    ? [Container(height: 300, alignment:Alignment.center, child: const Text("No sections are currently active in providerSections list.", style: TextStyle(fontSize: 18, color: Colors.red)))]
                    : providerSections.map((section) {
                        print("[ProviderServicesScreen - SECTION TEST] build: Building section: ${section.key ?? section.runtimeType}");
                        return section;
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
        ),
      );
    }
  }
// lib/features/provider/presentation/screens/provider_services_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For page entry animations
import 'package:shamil_web/core/widgets/modern_app_bar.dart';
import 'package:shamil_web/core/widgets/scroll_to_top_fab.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/provider_screen/provider_hero_section.dart';

// Corrected and standardized import paths for provider section widgets
// Make sure these files exist at these paths and define the respective classes
import 'package:shamil_web/features/providers/widgets/provider_cta_section.dart';
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
  late AnimationController _floatingParticlesController; // For sections that use it
  late AnimationController _pageEntryController; // For overall page entry

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _floatingParticlesController = AnimationController(
      duration: const Duration(seconds: 25), // Consistent duration for particle animations
      vsync: this,
    )..repeat();

    _pageEntryController = AnimationController(
      duration: const Duration(milliseconds: 500), // Slightly faster page entry animation
      vsync: this,
    );

    // Start page entry animation shortly after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageEntryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatingParticlesController.dispose();
    _pageEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the order of sections for the provider page.
    // This list makes the structure clean and easy to modify.
    final List<Widget> providerSections = [
      ProviderHeroSection(floatingController: _floatingParticlesController,),
      // ProviderFeaturesSection( 
      //   // Assuming ProviderFeaturesSection might use the scrollController for parallax or scroll-triggered animations.
      //   // If not, this parameter can be removed from its constructor.
      //   scrollController: _scrollController, 
      // ),
      ProviderHowItWorksSection(
        // Assuming ProviderHowItWorksSection might use the scrollController.
        scrollController: _scrollController, 
      ),
      const ProviderPricingSection(), // Assumed to be self-contained or uses a different animation mechanism.
      ProviderCtaSection(
        // ProviderCtaSection also uses the floatingParticlesController.
        floatingParticlesController: _floatingParticlesController,
      ),
      FooterSection( 
        scrollController: _scrollController, 
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ModernAppBar(
        scrollController: _scrollController,
        // The 'isProviderPage' parameter was removed as it caused an error.
        // If your ModernAppBar needs to behave differently on provider pages,
        // you must add 'isProviderPage' as a parameter to its constructor.
        // For example: final bool isProviderPage; and in constructor this.isProviderPage = false,
        // Then you could pass: isProviderPage: true,
        // onMenuTap: _showProviderMobileMenu, // Optional: Implement if you need a different mobile menu
      ),
      body: Animate( // Apply entry animation to the entire page content for a smooth load-in
        controller: _pageEntryController,
        effects: const [
          FadeEffect(duration: Duration(milliseconds: 500) , curve: Curves.easeOut), 
          SlideEffect(begin: Offset(0, 0.02), end: Offset.zero, duration: Duration(milliseconds: 500), curve: Curves.easeOut) 
        ],
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(), 
              child: Column(
                children: providerSections.map((section) {
                  // Each section is rendered directly.
                  // For more complex staggered animations per section,
                  // you could wrap each 'section' in its own Animate widget here,
                  // or handle entry animations within each section's own build method.
                  return section;
                }).toList(),
              ),
            ),
            // Scroll-to-top button, aligned to the bottom right
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Correct Instantiation: Ensure ScrollToTopButton is a class and imported correctly.
                // If your widget is named ScrollToTopFAB, use that name here.
                child: ScrollToTopFAB(scrollController: _scrollController), 
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optional: Placeholder for a provider-specific mobile menu if needed.
  // void _showProviderMobileMenu() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       // Build your provider-specific mobile menu UI here
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.6, 
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //            color: Theme.of(context).cardColor,
  //            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         child: const Center(child: Text("Provider Specific Mobile Menu")),
  //       );
  //     },
  //   );
  // }
}

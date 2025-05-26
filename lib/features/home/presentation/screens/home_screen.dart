// lib/features/home/presentation/screens/home_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shamil_web/core/widgets/modern_app_bar.dart'; // ✅ Correct import
import 'package:shamil_web/features/home/presentation/widgets/app_preview_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/benefits_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/download_cta_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/features_highlight_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/footer_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/hero_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/how_it_works_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/intro_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/testimonials_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/rocket_separator_section.dart';
import 'package:shamil_web/features/home/presentation/widgets/mobile_app_pages_section.dart';

/// 🚀 Modern Home Screen with Clean Design
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  
  // Section keys for navigation
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey(); 
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      
      // ✅ Using the correct ModernAppBar
      appBar: ModernAppBar(
        scrollController: _scrollController,
        onMenuTap: _showMobileMenu,
      ),
     
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(key: _heroKey, child: const HeroSection()),
            Container(key: _aboutKey, child: const IntroSection()),
            EnhancedRocketSeparatorSection(scrollController: _scrollController),
            MobileAppPagesSection(scrollController: _scrollController),
            Container(
              key: _featuresKey,
              child: FeaturesHighlightSection(scrollController: _scrollController),
            ),
            const BenefitsSection(),
            const HowItWorksSection(),
            const TestimonialsSection(),
            Container(key: _downloadKey, child: const DownloadCtaSection()),
            Container(key: _contactKey, child: const FooterSection()),
          ],
        ),
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
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.light
                  ? [
                      Colors.white.withOpacity(0.98),
                      Colors.grey.shade50.withOpacity(0.95),
                    ]
                  : [
                      const Color(0xFF1A2332).withOpacity(0.98),
                      const Color(0xFF0F1419).withOpacity(0.95),
                    ],
            ),
            border: Border.all(
              color: const Color(0xFF2A548D).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A548D).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A548D), Color(0xFFD8A31A)],
                        ),
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Navigation',
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
                    ),
                  ],
                ),
              ),
              
              // Menu Items
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildMenuItem(
                      'Features',
                      Icons.star_rounded,
                      'Discover powerful capabilities',
                      () => _scrollToSection(_featuresKey),
                      theme,
                    ),
                    _buildMenuItem(
                      'About',
                      Icons.info_rounded,
                      'Learn more about Shamil',
                      () => _scrollToSection(_aboutKey),
                      theme,
                    ),
                    _buildMenuItem(
                      'Download',
                      Icons.download_rounded,
                      'Get the app now',
                      () => _scrollToSection(_downloadKey),
                      theme,
                    ),
                    _buildMenuItem(
                      'Contact',
                      Icons.contact_support_rounded,
                      'Get in touch with us',
                      () => _scrollToSection(_contactKey),
                      theme,
                    ),
                    const SizedBox(height: 40),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2A548D).withOpacity(0.08),
                  const Color(0xFFD8A31A).withOpacity(0.02),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF2A548D).withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A548D), Color(0xFFD8A31A)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0,
      );
    }
  }
}
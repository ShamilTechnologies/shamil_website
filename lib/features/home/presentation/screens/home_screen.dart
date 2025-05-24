// lib/features/home/presentation/screens/home_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// 🔧 FIXED: Only import InnovativeAppBar from the correct location
import 'package:shamil_web/core/widgets/innovative_app_bar.dart';
// 🔧 FIXED: Import AppPreviewSection but make sure it doesn't contain InnovativeAppBar class
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

/// 🚀 Enhanced Home Screen with Ultra-Modern AppBar Integration
/// Features: Premium glassmorphism navigation, smooth scroll interactions,
/// responsive design, and viral user engagement elements
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  
  // Section keys for smooth navigation
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _downloadKey = GlobalKey(); 
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _pageAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageAnimationController.dispose();
    super.dispose();
  }

  // 🌐 Language Toggle Implementation
  void _toggleLanguage() {
    try {
      if (context.locale.languageCode == 'en') {
        context.setLocale(const Locale('ar')); // Switch to Arabic
      } else {
        context.setLocale(const Locale('en')); // Switch to English
      }
      
      // Show feedback to user
      _showLanguageChangeSnackBar();
    } catch (e) {
      // Handle any localization errors
      debugPrint('Language toggle error: $e');
    }
  }

  // 🌙 Theme Toggle Implementation
  void _toggleTheme() {
    // Note: You'll need to implement theme state management
    // This is a placeholder - you might use Provider, Bloc, or Riverpod
    // Example with Provider:
    // Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    
    // For now, showing a snackbar as placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              'Theme toggle feature - implement with your state management solution',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 🔍 Check if dark mode is active
  bool _isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  // 🗣️ Get current language
  String _currentLanguage() => context.locale.languageCode;

  // 📱 Language change feedback
  void _showLanguageChangeSnackBar() {
    final currentLang = _currentLanguage();
    final langName = currentLang == 'en' ? 'English' : 'العربية';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.language_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text('Language changed to $langName'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      
     
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
              child: _buildMainContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            key: _heroKey,
            child: const HeroSection(),
          ),
          Container(
            key: _aboutKey,
            child: const IntroSection(),
          ),
          // 🔧 NOTE: Make sure these sections don't conflict with AppBar
          EnhancedRocketSeparatorSection(
            scrollController: _scrollController,
          ),
          MobileAppPagesSection(
            scrollController: _scrollController,
          ),
          Container(
            key: _featuresKey,
            child: FeaturesHighlightSection(
              scrollController: _scrollController,
            ),
          ),
          const BenefitsSection(),
          const HowItWorksSection(),
          const TestimonialsSection(),

          Container(
            key: _downloadKey,
            child: const DownloadCtaSection(),
          ),
          Container(
            key: _contactKey,
            child: const FooterSection(),
          ),
        ],
      ),
    );
  }

  void _showEnhancedMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => _buildEnhancedMobileMenu(),
    );
  }

  Widget _buildEnhancedMobileMenu() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      Colors.grey.shade900.withOpacity(0.98),
                      Colors.black.withOpacity(0.95),
                    ]
                  : [
                      Colors.white.withOpacity(0.98),
                      Colors.grey.shade50.withOpacity(0.95),
                    ],
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
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
              // 🎯 Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              
              // 📱 Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Navigation',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
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
              
              // 📋 Menu Items
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildEnhancedMenuItem(
                      'Features',
                      Icons.star_rounded, 
                      'Discover powerful capabilities',
                      () => _scrollToSection(_featuresKey), 
                      theme
                    ),
                    _buildEnhancedMenuItem(
                      'About',
                      Icons.info_rounded, 
                      'Learn more about Shamil',
                      () => _scrollToSection(_aboutKey), 
                      theme
                    ),
                    _buildEnhancedMenuItem(
                      'Download',
                      Icons.download_rounded, 
                      'Get the app now',
                      () => _scrollToSection(_downloadKey), 
                      theme
                    ),
                    _buildEnhancedMenuItem(
                      'Contact',
                      Icons.contact_support_rounded, 
                      'Get in touch with us',
                      () => _scrollToSection(_contactKey), 
                      theme
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 🌐🌙 Language and Theme toggles for mobile
                    _buildMobileToggleSection(theme),
                    
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

  // 🔧 Mobile Toggle Section (Language & Theme)
  Widget _buildMobileToggleSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // 🌐 Language Toggle
          _buildMobileToggleItem(
            'Language',
            _currentLanguage().toUpperCase(),
            Icons.language_rounded,
            _toggleLanguage,
            theme,
          ),
          
          const SizedBox(height: 12),
          
          // 🌙 Theme Toggle
          _buildMobileToggleItem(
            'Theme',
            _isDarkMode() ? 'Dark' : 'Light',
            _isDarkMode() ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            _toggleTheme,
            theme,
          ),
        ],
      ),
    );
  }

  // 🔘 Mobile Toggle Item
  Widget _buildMobileToggleItem(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedMenuItem(
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
                  theme.colorScheme.primary.withOpacity(0.08),
                  theme.colorScheme.primary.withOpacity(0.02),
                ],
              ),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
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
                          color: theme.colorScheme.onSurface,
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
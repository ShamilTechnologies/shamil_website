// lib/core/widgets/modern_app_bar.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/navigation/app_router.dart'; // Corrected: Ensure this import provides AppRouter.providerServicesPath
import 'package:shamil_web/core/theme/theme_provider.dart';
import 'package:shamil_web/core/localization/locale_provider.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:responsive_framework/responsive_framework.dart';

// 🌊 Ultra Modern App Bar with Enhanced Animations & Corrected Navigation 🌊
class ModernAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final VoidCallback? onMenuTap; // For mobile menu

  const ModernAppBar({
    super.key,
    required this.scrollController,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100); // Adjusted height for a more prominent app bar

  @override
  ConsumerState<ModernAppBar> createState() => _ModernAppBarState();
}

class _ModernAppBarState extends ConsumerState<ModernAppBar>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _hoverController; // General hover effects for buttons if needed
  
  // State Variables
  double _scrollOffset = 0;
  double _logoRotation = 0; // For the rotating logo effect

  // Constants for styling
  static const _primaryColor = Color(0xFF2A548D); // Shamil Blue
  static const _goldColor = Color(0xFFD8A31A);    // Shamil Gold
  static const _logoSize = 60.0; // Slightly smaller logo for a sleeker look

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeAnimations() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200), // Quick hover transitions
      vsync: this,
    );
    // Other specific animation controllers can be initialized here if needed
  }

  void _setupScrollListener() {
    widget.scrollController.addListener(_onScroll);
  }

  void _disposeControllers() {
    _hoverController.dispose();
    // Ensure to remove listener to prevent memory leaks
    widget.scrollController.removeListener(_onScroll); 
  }

  void _onScroll() {
    if (!mounted) return; // Check if the widget is still in the tree
    
    final offset = widget.scrollController.offset;
    setState(() {
      _scrollOffset = offset;
      _logoRotation = (offset * 0.0015) % (2 * math.pi); // Slightly slower, smoother rotation
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    // Opacity transition for app bar background based on scroll
    final opacity = (_scrollOffset / 250.0).clamp(0.0, 1.0); // Start transition a bit earlier
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced vertical margin
      decoration: _buildAppBarDecoration(theme, opacity),
      child: AppBar(
        backgroundColor: Colors.transparent, // AppBar itself is transparent
        elevation: 0, // No shadow from AppBar widget, handled by container
        automaticallyImplyLeading: false, // We handle our own leading widget
        toolbarHeight: 70, // Consistent toolbar height
        leadingWidth: _logoSize + 24, // Adjusted leading width
        leading: _buildEnhancedLogo(),
        actions: _buildActions(isMobile, theme),
      ),
    );
  }

  // 🎨 AppBar background decoration with scroll-based effects
  BoxDecoration _buildAppBarDecoration(ThemeData theme, double opacity) {
    // Smoother background color transition
    final Color lightBgColor = Color.lerp(Colors.white.withOpacity(0.6), theme.colorScheme.surface.withOpacity(0.75), opacity)!;
    final Color darkBgColor = Color.lerp(Colors.black.withOpacity(0.4), theme.colorScheme.surface.withOpacity(0.65), opacity)!;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(30), // Slightly softer radius
      color: theme.brightness == Brightness.light ? lightBgColor : darkBgColor,
      border: Border.all(
        color: _primaryColor.withOpacity(0.08 + opacity * 0.12), // Subtle border, reactive
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04 + opacity * 0.06), // Softer shadow, reactive
          blurRadius: 15 + opacity * 10,
          offset: Offset(0, 4 + opacity * 4),
        ),
      ],
    );
  }

  // 🔧 Building action buttons for the AppBar
  List<Widget> _buildActions(bool isMobile, ThemeData theme) {
    return [
      if (!isMobile) ...[
        _buildJoinProviderButton(theme),
        const SizedBox(width: 10), // Reduced spacing
        _buildLanguageButton(theme),
        const SizedBox(width: 10),
        _buildThemeButton(theme),
      ] else
        _buildMobileMenuButton(theme),
      const SizedBox(width: 12), // Consistent end spacing
    ];
  }

  // 🖼️ Enhanced logo with rotation
  Widget _buildEnhancedLogo() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 5, bottom: 5, right: 5), // Adjusted padding for centering
      child: Transform.rotate(
        angle: _logoRotation,
        child: Image.asset(
          AppAssets.logo, // Make sure AppAssets.logo is correctly defined
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container( // Fallback if logo fails to load
            width: _logoSize,
            height: _logoSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_primaryColor, _goldColor]),
            ),
            child: Icon(Icons.rocket_launch, size: _logoSize * 0.55, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // 🚀 "Join as Provider" Button
  Widget _buildJoinProviderButton(ThemeData theme) {
    // Local hover state for individual button animations if needed, or use a shared controller
    bool isHovered = false; 

    return StatefulBuilder( // To manage local hover state if not using a global controller
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            scale: isHovered ? 1.08 : 1.0, // Enhanced hover scale
            duration: const Duration(milliseconds: 150),
            child: TextButton.icon(
              onPressed: () {
                // ✅ Corrected Navigation Path: Using AppRouter.providerServicesPath
                context.go(AppRouter.providerServicesPath); 
              },
              icon: Icon(Icons.storefront_rounded, size: 18, color: isHovered ? _goldColor : _primaryColor),
              label: Text(
                AppStrings.joinProvider.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600, // Bolder text
                  color: isHovered ? _goldColor : _primaryColor,
                  fontSize: 13, // Slightly smaller for app bar
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10), // Adjusted padding
                backgroundColor: (isHovered ? _primaryColor.withOpacity(0.1) : Colors.transparent), // Subtle background on hover
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Softer radius
                  side: BorderSide(color: isHovered ? _goldColor.withOpacity(0.7) : _primaryColor.withOpacity(0.4), width: 1)
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  // 🌍 Language Switcher Button
  Widget _buildLanguageButton(ThemeData theme) {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleLanguage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isHovered ? _primaryColor.withOpacity(0.1) : theme.colorScheme.surface.withOpacity(0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _primaryColor.withOpacity(isHovered ? 0.4 : 0.15), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isArabic ? 'EN' : 'AR', style: TextStyle(color: _primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Icon(Icons.translate, color: _primaryColor, size: 16),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  // 🌓 Theme Switcher Button
  Widget _buildThemeButton(ThemeData theme) {
    final themeMode = ref.watch(themeProvider);
    final isDark = _isDarkMode(themeMode);
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleTheme,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? (isDark ? Colors.amber.withOpacity(0.15) : _primaryColor.withOpacity(0.1)) : theme.colorScheme.surface.withOpacity(0.03),
                border: Border.all(
                  color: isDark ? Colors.amber.withOpacity(isHovered ? 0.6 : 0.3) : _primaryColor.withOpacity(isHovered ? 0.4 : 0.15),
                  width: 1,
                ),
              ),
              child: AnimatedSwitcher( // Smooth icon transition
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(isDark), // Important for AnimatedSwitcher
                  color: isDark ? Colors.amber : _primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  // 📱 Mobile Menu Button
  Widget _buildMobileMenuButton(ThemeData theme) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onMenuTap ?? () {}, // Call onMenuTap if provided
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? _primaryColor.withOpacity(0.08) : theme.colorScheme.surface.withOpacity(0.03),
                border: Border.all(color: _primaryColor.withOpacity(isHovered ? 0.35 : 0.15), width: 1),
              ),
              child: Icon(Icons.segment, color: _primaryColor, size: 20), // Using segment icon for menu
            ),
          ),
        );
      }
    );
  }

  // 🛠️ Helper methods for toggling theme and language
  void _toggleLanguage() {
    final currentLocale = context.locale;
    final newLocale = currentLocale.languageCode == 'ar' 
        ? const Locale('en') 
        : const Locale('ar');
    // Ensure LocaleProvider is correctly set up and accessible via ref
    ref.read(localeProvider.notifier).setLocale(context, newLocale); 
  }

  void _toggleTheme() {
    // Ensure ThemeProvider is correctly set up and accessible via ref
    ref.read(themeProvider.notifier).toggleTheme(); 
  }

  bool _isDarkMode(ThemeMode themeMode) {
    // Check current theme mode, considering system preference
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
  }
}
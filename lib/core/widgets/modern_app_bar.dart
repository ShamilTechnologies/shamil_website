// lib/core/widgets/modern_app_bar.dart

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/navigation/app_router.dart'; // Import AppRouter to access path constants
import 'package:shamil_web/core/theme/theme_provider.dart';
import 'package:shamil_web/core/localization/locale_provider.dart';
import 'package:shamil_web/core/constants/app_strings.dart'; // Import AppStrings
import 'package:responsive_framework/responsive_framework.dart';

/// 🌊 Ultra Modern App Bar with Enhanced Animations
class ModernAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final VoidCallback? onMenuTap;

  const ModernAppBar({
    super.key,
    required this.scrollController,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100); // Adjusted height if needed

  @override
  ConsumerState<ModernAppBar> createState() => _ModernAppBarState();
}

class _ModernAppBarState extends ConsumerState<ModernAppBar>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _hoverController;
  
  // State Variables
  double _scrollOffset = 0;
  double _logoRotation = 0;
  // Removed _isDownloading and _isDownloadHovered as the download button is removed

  // Constants
  static const _primaryColor = Color(0xFF2A548D);
  static const _goldColor = Color(0xFFD8A31A);
  static const _logoSize = 65.0; // Slightly adjusted logo size for balance

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
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  void _setupScrollListener() {
    widget.scrollController.addListener(_onScroll);
  }

  void _disposeControllers() {
    _hoverController.dispose();
    widget.scrollController.removeListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    
    final offset = widget.scrollController.offset;
    setState(() {
      _scrollOffset = offset;
      _logoRotation = (offset * 0.002) % (2 * math.pi); // Slightly reduced rotation speed
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    // Make opacity transition smoother and start a bit earlier
    final opacity = (_scrollOffset / 300).clamp(0.0, 1.0); 
    
    return Container(
      // Reduced margin for a sleeker look, more noticeable on smaller screens
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
      decoration: _buildAppBarDecoration(theme, opacity),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70, // Adjusted toolbar height
        leadingWidth: _logoSize + 32, // Adjust leadingWidth to fit logo + padding
        leading: _buildEnhancedLogo(),
        actions: _buildActions(isMobile, theme), // Pass theme to actions
      ),
    );
  }

  BoxDecoration _buildAppBarDecoration(ThemeData theme, double opacity) {
    // More subtle background transition, using surface color mixed with primary
    final Color lightBgColor = Color.lerp(Colors.white.withOpacity(0.5), theme.colorScheme.surface.withOpacity(0.5), opacity)!;
    final Color darkBgColor = Color.lerp(Colors.black.withOpacity(0.3), theme.colorScheme.surface.withOpacity(0.3), opacity)!;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(35), // Slightly less rounded
      color: theme.brightness == Brightness.light ? lightBgColor : darkBgColor,
      border: Border.all(
        color: _primaryColor.withOpacity(0.1 + opacity * 0.1), // Border opacity reacts to scroll
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05 + opacity * 0.07),
          blurRadius: 20 + opacity * 15, // Shadow intensity reacts to scroll
          offset: Offset(0, 5 + opacity * 5),
        ),
      ],
    );
  }

  List<Widget> _buildActions(bool isMobile, ThemeData theme) { // Added theme parameter
    return [
      if (!isMobile) ...[
        _buildJoinProviderButton(theme), // Pass theme
        const SizedBox(width: 12), // Adjusted spacing
        _buildLanguageButton(theme),   // Pass theme
        const SizedBox(width: 12), // Adjusted spacing
        _buildThemeButton(theme),      // Pass theme
      ] else
        _buildMobileMenuButton(theme), // Pass theme
      const SizedBox(width: 16), // Adjusted spacing
    ];
  }

  Widget _buildEnhancedLogo() {
    return Padding( // Changed Container to Padding
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 8), // Adjusted padding
      child: Transform.rotate(
        angle: _logoRotation,
        child: Image.asset(
          AppAssets.logo,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
              ),
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: _logoSize * 0.6,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // New "Join as Provider" Button
  Widget _buildJoinProviderButton(ThemeData theme) {
    bool isHovered = false; // Local hover state for this button

    return StatefulBuilder(
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            scale: isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: TextButton.icon(
              onPressed: () {
                // *** FIXED ERROR HERE ***
                // Changed AppRouter.providerJoinPath to AppRouter.providerServicesPath
                context.go(AppRouter.providerServicesPath); // Navigate using GoRouter 
              },
              icon: Icon(Icons.storefront_outlined, size: 18, color: isHovered ? _goldColor : _primaryColor),
              label: Text(
                AppStrings.joinProvider.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isHovered ? _goldColor : _primaryColor,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: (isHovered ? _primaryColor : _primaryColor.withOpacity(0.1)).withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: isHovered ? _goldColor.withOpacity(0.5) : _primaryColor.withOpacity(0.3), width: 1.5)
                ),
              ),
            ),
          ),
        );
      }
    );
  }


  Widget _buildLanguageButton(ThemeData theme) { // Added theme parameter
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
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjusted padding
              decoration: BoxDecoration(
                color: isHovered ? _primaryColor.withOpacity(0.15) : theme.colorScheme.surface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _primaryColor.withOpacity(isHovered ? 0.5 : 0.2),
                  width: 1,
                ),
                 boxShadow: isHovered ? [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArabic ? 'EN' : 'AR',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 13, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6), // Adjusted spacing
                  Icon(
                    Icons.translate_rounded, // Changed icon
                    color: _primaryColor,
                    size: 18, // Adjusted icon size
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildThemeButton(ThemeData theme) { // Added theme parameter
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
              duration: const Duration(milliseconds: 200),
              width: 42, // Adjusted size
              height: 42, // Adjusted size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? (isDark ? Colors.amber.withOpacity(0.2) : _primaryColor.withOpacity(0.15)) : theme.colorScheme.surface.withOpacity(0.05),
                border: Border.all(
                  color: isDark ? Colors.amber.withOpacity(isHovered ? 0.7 : 0.4) : _primaryColor.withOpacity(isHovered ? 0.5 : 0.2),
                  width: 1.5, // Adjusted border width
                ),
                boxShadow: isHovered ? [
                  BoxShadow(
                    color: (isDark ? Colors.amber : _primaryColor).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ] : [],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, // Changed icons
                  key: ValueKey(isDark),
                  color: isDark ? Colors.amber : _primaryColor,
                  size: 20, // Adjusted icon size
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildMobileMenuButton(ThemeData theme) { // Added theme parameter
     bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setButtonState) {
        return MouseRegion(
          onEnter: (_) => setButtonState(() => isHovered = true),
          onExit: (_) => setButtonState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onMenuTap ?? () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42, // Adjusted size
              height: 42, // Adjusted size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? _primaryColor.withOpacity(0.1) : theme.colorScheme.surface.withOpacity(0.05),
                border: Border.all(
                  color: _primaryColor.withOpacity(isHovered ? 0.4 : 0.2),
                  width: 1,
                ),
                 boxShadow: isHovered ? [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Icon(
                Icons.segment_rounded, // Changed icon
                color: _primaryColor,
                size: 22, // Adjusted icon size
              ),
            ),
          ),
        );
      }
    );
  }

  void _toggleLanguage() {
    final currentLocale = context.locale;
    final newLocale = currentLocale.languageCode == 'ar' 
        ? const Locale('en') 
        : const Locale('ar');
    ref.read(localeProvider.notifier).setLocale(context, newLocale);
  }

  void _toggleTheme() {
    ref.read(themeProvider.notifier).toggleTheme();
  }

  bool _isDarkMode(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
  }
  // Removed _handleDownload, _showDownloadDialog, _showMessage as download button is removed
}
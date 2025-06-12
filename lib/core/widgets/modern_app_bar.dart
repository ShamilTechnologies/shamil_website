// lib/core/widgets/modern_app_bar.dart

import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/navigation/app_router.dart';
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
  Size get preferredSize => const Size.fromHeight(100);

  @override
  ConsumerState<ModernAppBar> createState() => _ModernAppBarState();
}

class _ModernAppBarState extends ConsumerState<ModernAppBar>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _hoverController;

  // State Variables
  double _scrollOffset = 0;

  // Constants for styling
  static const _primaryColor = Color(0xFF2A548D); // Shamil Blue
  static const _goldColor = Color(0xFFD8A31A); // Shamil Gold
  static const _babyBlueColor = Color(0xFF89CFF0); // Baby Blue
  static const _logoSize = 60.0;
  // NEW: Defined a new, more vibrant hover color for light mode.
  static const _lightHoverColor = Color(0xFF0056b3);
  // NEW: Defined a new, brighter hover color for dark mode.
  static const _darkHoverColor = Color(0xFFFFC107);


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
      duration: const Duration(milliseconds: 200),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final opacity = (_scrollOffset / 250.0).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _buildAppBarDecoration(theme, opacity),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10 * opacity, sigmaY: 10 * opacity),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            leadingWidth: _logoSize + 24,
            leading: _buildEnhancedLogo(),
            actions: _buildActions(isMobile, theme),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildAppBarDecoration(ThemeData theme, double opacity) {
    final bool isLightMode = theme.brightness == Brightness.light;

    final Color glassBackgroundColor = isLightMode
        ? _babyBlueColor.withOpacity(0.15)
        : _goldColor.withOpacity(0.15);

    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: glassBackgroundColor,
      // REMOVED: The border property has been removed to make the AppBar borderless.
      boxShadow: [
        BoxShadow(
          color: (isLightMode ? _babyBlueColor : _goldColor).withOpacity(0.05 + opacity * 0.05),
          blurRadius: 15 + opacity * 10,
          offset: Offset(0, 4 + opacity * 4),
        ),
      ],
    );
  }

  List<Widget> _buildActions(bool isMobile, ThemeData theme) {
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;

    return [
      if (!isMobile) ...[
        if (currentPath == AppRouter.providerServicesPath)
          _buildGlassButton(
            theme: theme,
            text: "Home",
            icon: Icons.home_rounded,
            onPressed: () => context.go(AppRouter.homePath),
          )
        else
          _buildGlassButton(
            theme: theme,
            text: AppStrings.joinProvider.tr(),
            icon: Icons.storefront_rounded,
            onPressed: () => context.go(AppRouter.providerServicesPath),
          ),
        const SizedBox(width: 10),
        _buildLanguageButton(theme),
        const SizedBox(width: 10),
        _buildThemeButton(theme),
      ] else
        _buildMobileMenuButton(theme),
      const SizedBox(width: 12),
    ];
  }

  Widget _buildGlassButton({
    required ThemeData theme,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    bool isHovered = false;
    final isDarkMode = theme.brightness == Brightness.dark;
    final isLightMode = !isDarkMode;

    return StatefulBuilder(builder: (context, setButtonState) {
      final Color defaultColor = isLightMode ? _primaryColor : Colors.white;
      // UPDATED: The hover color now uses the new, more vibrant color constants.
      final Color hoverColor = isDarkMode ? _darkHoverColor : _lightHoverColor;

      return MouseRegion(
        onEnter: (_) => setButtonState(() => isHovered = true),
        onExit: (_) => setButtonState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedScale(
          scale: isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: TextButton.icon(
            onPressed: onPressed,
            icon: Icon(icon,
                size: 18, color: isHovered ? hoverColor : defaultColor),
            label: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isHovered ? hoverColor : defaultColor,
                fontSize: 13,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              // UPDATED: The background color on hover also uses the new hover colors.
              backgroundColor:
                  isHovered ? (isDarkMode ? _darkHoverColor.withOpacity(0.1) : _lightHoverColor.withOpacity(0.1)) : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  // UPDATED: The border on hover now uses the new hover colors for a more distinct effect.
                  side: BorderSide(
                      color: isHovered
                          ? hoverColor
                          : isLightMode ? _primaryColor.withOpacity(0.3) : Colors.white.withOpacity(0.3),
                      width: 1)),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEnhancedLogo() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 5, bottom: 5, right: 5),
      child: Image.asset(
        AppAssets.logo,
        width: _logoSize,
        height: _logoSize,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: _logoSize,
          height: _logoSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [_primaryColor, _goldColor]),
          ),
          child: Icon(Icons.rocket_launch,
              size: _logoSize * 0.55, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(ThemeData theme) {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';
    bool isHovered = false;
    final isLightMode = theme.brightness == Brightness.light;
    final isDarkMode = !isLightMode;
    
    return StatefulBuilder(builder: (context, setButtonState) {
      // UPDATED: Set default and hover colors based on the current theme.
      final Color defaultColor = isLightMode ? _primaryColor : Colors.white;
      final Color hoverColor = isDarkMode ? _darkHoverColor : _lightHoverColor;

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
              // UPDATED: The background color on hover uses the new hover colors.
              color: isHovered
                  ? (isLightMode ? _lightHoverColor.withOpacity(0.1) : _darkHoverColor.withOpacity(0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  // UPDATED: The border color now also uses the new hover colors.
                  color: isHovered ? hoverColor : defaultColor.withOpacity(isLightMode ? 0.4 : 0.2),
                  width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isArabic ? 'EN' : 'AR',
                    style: TextStyle(
                        // UPDATED: The text color now changes to the new hover color.
                        color: isHovered ? hoverColor : defaultColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                Icon(Icons.translate, color: isHovered ? hoverColor : defaultColor, size: 16),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildThemeButton(ThemeData theme) {
    final themeMode = ref.watch(themeProvider);
    final isDark = _isDarkMode(themeMode);
    bool isHovered = false;

    return StatefulBuilder(builder: (context, setButtonState) {
      return MouseRegion(
        onEnter: (_) => setButtonState(() => isHovered = true),
        onExit: (_) => setButtonState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _toggleTheme,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHovered
                  ? (isDark
                      ? Colors.amber.withOpacity(0.15)
                      : _primaryColor.withOpacity(0.1))
                  : Colors.black.withOpacity(0.05),
              border: Border.all(
                color: isDark
                    ? Colors.amber.withOpacity(isHovered ? 0.6 : 0.3)
                    : _primaryColor.withOpacity(isHovered ? 0.4 : 0.15),
                width: 1,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDark),
                color: isDark ? Colors.amber : _primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMobileMenuButton(ThemeData theme) {
    bool isHovered = false;
    return StatefulBuilder(builder: (context, setButtonState) {
      return MouseRegion(
        onEnter: (_) => setButtonState(() => isHovered = true),
        onExit: (_) => setButtonState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onMenuTap ?? () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHovered
                  ? _primaryColor.withOpacity(0.08)
                  : Colors.black.withOpacity(0.05),
              border: Border.all(
                  color: Colors.white.withOpacity(isHovered ? 0.35 : 0.15),
                  width: 1),
            ),
            child: Icon(Icons.segment, color: Colors.white, size: 20),
          ),
        ),
      );
    });
  }

  void _toggleLanguage() {
    final currentLocale = context.locale;
    final newLocale =
        currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    ref.read(localeProvider.notifier).setLocale(context, newLocale);
  }

  void _toggleTheme() {
    ref.read(themeProvider.notifier).toggleTheme();
  }

  bool _isDarkMode(ThemeMode themeMode) {
    if (themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }
}

// lib/core/widgets/modern_app_bar.dart

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/theme/theme_provider.dart';
import 'package:shamil_web/core/localization/locale_provider.dart';
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
  double _logoRotation = 0;
  bool _isDownloading = false;
  bool _isDownloadHovered = false;

  // Constants
  static const _primaryColor = Color(0xFF2A548D);
  static const _goldColor = Color(0xFFD8A31A);
  static const _logoSize = 85.0;

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
      _logoRotation = (offset * 0.003) % (2 * math.pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final opacity = (_scrollOffset / 400).clamp(0.0, 0.9);
    
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: _buildAppBarDecoration(theme, opacity),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 300,
        leading: _buildEnhancedLogo(),
        actions: _buildActions(isMobile),
      ),
    );
  }

  BoxDecoration _buildAppBarDecoration(ThemeData theme, double opacity) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: theme.brightness == Brightness.light
            ? [
                Colors.white.withOpacity(opacity * 0.95),
                Colors.white.withOpacity(opacity * 0.8),
              ]
            : [
                Colors.black.withOpacity(opacity * 0.9),
                Colors.grey.shade800.withOpacity(opacity * 0.7),
              ],
      ),
      border: Border.all(
        color: _primaryColor.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 35,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  List<Widget> _buildActions(bool isMobile) {
    return [
      if (!isMobile) ...[
        _buildCleanDownloadButton(),
        const SizedBox(width: 16),
        _buildLanguageButton(),
        const SizedBox(width: 16),
        _buildThemeButton(),
      ] else
        _buildMobileMenuButton(),
      const SizedBox(width: 24),
    ];
  }

  Widget _buildEnhancedLogo() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 18, bottom: 18, right: 12),
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

  Widget _buildCleanDownloadButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Clean theme-based colors
    final borderColor = isDark ? _goldColor : _primaryColor;
    final textColor = isDark ? _goldColor : _primaryColor;
    final hoverScale = _isDownloadHovered ? 1.15 : 1.0; // Bigger hover effect
    
    return MouseRegion(
      onEnter: (_) => _setDownloadHover(true),
      onExit: (_) => _setDownloadHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(hoverScale),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            color: Colors.transparent,
            boxShadow: _isDownloadHovered ? [
              BoxShadow(
                color: borderColor.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ] : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleDownload,
              borderRadius: BorderRadius.circular(12),
              splashColor: borderColor.withOpacity(0.1),
              highlightColor: borderColor.withOpacity(0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDownloadIcon(textColor),
                    const SizedBox(width: 8),
                    _buildDownloadText(textColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadIcon(Color iconColor) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isDownloading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(iconColor),
              ),
            )
          : Icon(
              key: const ValueKey('download'),
              Icons.download_rounded,
              color: iconColor,
              size: 18,
            ),
    );
  }

  Widget _buildDownloadText(Color textColor) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      child: Text(_isDownloading ? 'Loading...' : 'Download'),
    );
  }

  Widget _buildLanguageButton() {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';
    
    return GestureDetector(
      onTap: _toggleLanguage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? 'EN' : 'AR',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.language_rounded,
              color: _primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton() {
    final themeMode = ref.watch(themeProvider);
    final isDark = _isDarkMode(themeMode);
    
    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: isDark ? Colors.amber : _primaryColor,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.amber : _primaryColor).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              key: ValueKey(isDark),
              color: isDark ? Colors.amber : _primaryColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton() {
    return GestureDetector(
      onTap: widget.onMenuTap ?? () {},
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          border: Border.all(
            color: _primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.menu_rounded,
          color: _primaryColor,
          size: 24,
        ),
      ),
    );
  }

  // ===== EVENT HANDLERS =====

  void _setDownloadHover(bool isHovered) {
    setState(() => _isDownloadHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
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

  Future<void> _handleDownload() async {
    if (_isDownloading) return;
    
    setState(() => _isDownloading = true);
    
    try {
      await _showDownloadDialog();
    } catch (e) {
      _showMessage('Download failed. Try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  // ===== UTILITY METHODS =====

  Future<void> _showDownloadDialog() async {
    final theme = Theme.of(context);
    
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: theme.colorScheme.surface,
            border: Border.all(color: _primaryColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Download Shamil',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
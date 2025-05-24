// lib/core/widgets/innovative_app_bar.dart

import 'dart:html' as html; // 📁 For web file downloads
import 'dart:math' as math;
// 📊 For binary data handling
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🎨 For loading assets
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/widgets/language_switcher.dart';
import 'package:shamil_web/core/widgets/theme_switcher.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 🚀 INNOVATIVE APP BAR WITH ROTATING LOGO & DOWNLOAD FEATURE 🚀
/// Features: Continuous logo rotation, glassmorphism design, smart download system
class InnovativeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController; // Note: This is the ScrollController from the parent
  final VoidCallback? onMenuTap;

  const InnovativeAppBar({
    super.key,
    required this.scrollController,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<InnovativeAppBar> createState() => _InnovativeAppBarState();
}

class _InnovativeAppBarState extends State<InnovativeAppBar>
    with TickerProviderStateMixin {
  
  // 🎭 Animation Controllers
  late AnimationController _logoRotationController;
  late AnimationController _appBarAnimationController; // Renamed from _scrollController to avoid confusion
  late AnimationController _downloadController;
  
  // 📊 State Variables
  double _scrollOffset = 0;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    
    // 🔄 Continuous Logo Rotation (Never stops!)
    _logoRotationController = AnimationController(
      duration: const Duration(seconds: 8), // Smooth 8-second rotation
      vsync: this,
    )..repeat(); // 🔁 Loop forever!
    
    // 📜 Scroll-aware animations for the AppBar itself
    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // 📥 Download button animation
    _downloadController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // 👂 Listen to scroll changes from the parent's ScrollController
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _logoRotationController.dispose();
    _appBarAnimationController.dispose();
    _downloadController.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  // 📜 Handle scroll changes for dynamic effects
  void _onScroll() {
    final offset = widget.scrollController.offset;
    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        _scrollOffset = offset;
      });
    }
    
    // 🌊 Animate AppBar based on scroll (e.g., for background opacity or other effects)
    if (offset > 100) { // Example threshold
      if (mounted) _appBarAnimationController.forward();
    } else {
      if (mounted) _appBarAnimationController.reverse();
    }
  }

  // 📥 Smart Download Handler
  Future<void> _handleDownload() async {
    if (_isDownloading) return; // 🚫 Prevent multiple downloads
    
    if (mounted) setState(() => _isDownloading = true);
    if (mounted) _downloadController.forward();
    
    try {
      // 🎯 Show download options dialog
      await _showDownloadOptions();
    } catch (e) {
      // ❌ Handle download error
      if (mounted) _showErrorSnackBar('Download failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
        _downloadController.reverse();
      }
    }
  }

  // 📱 Show Download Options Dialog
  Future<void> _showDownloadOptions() async {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => Dialog( // Use dialogContext
        backgroundColor: Colors.transparent,
        child: Container(
          width: isMobile ? double.infinity : 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.brightness == Brightness.light
                  ? [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.85),
                    ]
                  : [
                      Colors.grey.shade900.withOpacity(0.95),
                      Colors.black.withOpacity(0.9),
                    ],
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎯 Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.download_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Download Shamil App', // Consider localizing
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Choose your platform', // Consider localizing
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext), // Use dialogContext
                    icon: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 📱 Download Options
              _buildDownloadOption(
                'Android APK',
                'shamil-app-android.apk',
                Icons.android_rounded,
                theme.colorScheme.primary,
                () => _downloadFile('android', dialogContext), // Pass dialogContext
              ),
              
              const SizedBox(height: 12),
              
              _buildDownloadOption(
                'Windows EXE',
                'shamil-app-windows.exe',
                Icons.desktop_windows_rounded,
                Colors.blue,
                () => _downloadFile('windows', dialogContext), // Pass dialogContext
              ),
              
              const SizedBox(height: 12),
              
              _buildDownloadOption(
                'macOS DMG',
                'shamil-app-macos.dmg',
                Icons.laptop_mac_rounded,
                Colors.grey.shade700,
                () => _downloadFile('macos', dialogContext), // Pass dialogContext
              ),
              
              const SizedBox(height: 12),
              
              _buildDownloadOption(
                'iOS IPA',
                'shamil-app-ios.ipa',
                Icons.phone_iphone_rounded,
                Colors.black,
                () => _downloadFile('ios', dialogContext), // Pass dialogContext
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📦 Build Download Option Widget
  Widget _buildDownloadOption(
    String title,
    String filename,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            color: theme.colorScheme.surface.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: iconColor.withOpacity(0.1),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      filename,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.download_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📁 Download File Function
  Future<void> _downloadFile(String platform, BuildContext dialogContext) async {
    Navigator.pop(dialogContext); // Close dialog using its own context
    
    if (!mounted) return;

    try {
      final String content = _generateAppFileContent(platform);
      final List<int> bytes = content.codeUnits;
      
      final blob = html.Blob([Uint8List.fromList(bytes)], 'application/octet-stream');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'shamil-app-$platform.${_getFileExtension(platform)}')
        ..click();
      
      html.Url.revokeObjectUrl(url);
      
      if (mounted) _showSuccessSnackBar('Download started successfully!');
      
    } catch (e) {
      if (mounted) _showErrorSnackBar('Download failed. Please try again.');
    }
  }

  // 📝 Generate Sample App Content (Replace with actual app binaries or asset paths)
  String _generateAppFileContent(String platform) {
    // For actual file downloads, you would typically load ByteData from assets
    // or fetch from a URL, not generate text content like this.
    // Example: final ByteData data = await rootBundle.load('assets/downloads/shamil-app-$platform.${_getFileExtension(platform)}');
    // final List<int> bytes = data.buffer.asUint8List();
    return '''
# Shamil App - $platform Version (Sample Placeholder)

This is a placeholder file for the Shamil App ${platform.toUpperCase()} version.
In a real application, this would be the actual application binary.

Platform: ${platform.toUpperCase()}
Version: 1.0.0
Build Date: ${DateTime.now().toIso8601String()}

Thank you for choosing Shamil App!

---
© ${DateTime.now().year} Shamil App. All rights reserved.
    ''';
  }

  // 📋 Get File Extension
  String _getFileExtension(String platform) {
    switch (platform) {
      case 'android': return 'apk';
      case 'windows': return 'exe';
      case 'macos': return 'dmg';
      case 'ios': return 'ipa'; // Note: Direct IPA download/install is usually restricted
      default: return 'txt';
    }
  }

  void _showSnackBar(String message, Color backgroundColor, IconData iconData) {
     if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ✅ Show Success Message
  void _showSuccessSnackBar(String message) {
    _showSnackBar(message, Colors.green, Icons.check_circle_rounded);
  }

  // ❌ Show Error Message
  void _showErrorSnackBar(String message) {
     _showSnackBar(message, Colors.red, Icons.error_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    
    // 🌊 Dynamic background opacity based on scroll for the AppBar container
    // This uses the AnimationController `_appBarAnimationController` which is driven by scroll offset
    final backgroundOpacity = _appBarAnimationController.drive(Tween<double>(begin: 0.0, end: 0.95)).value;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_appBarAnimationController, _logoRotationController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            // 🌈 Glassmorphism background for the container housing the AppBar
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.light
                  ? [
                      Colors.white.withOpacity(backgroundOpacity),
                      Colors.white.withOpacity(backgroundOpacity * 0.8),
                    ]
                  : [
                      Colors.black.withOpacity(backgroundOpacity),
                      Colors.grey.shade900.withOpacity(backgroundOpacity * 0.8),
                    ],
            ),
            // ✨ Dynamic border
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withOpacity(backgroundOpacity * 0.2), // Softer border
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // AppBar itself is transparent
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            
            // 🎯 Leading: Rotating Logo
            leadingWidth: isMobile ? 60 : 80,
            leading: Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: _logoRotationController.value * 2 * math.pi, // Corrected pi usage
                child: Image.asset(
                  AppAssets.logo, // Make sure AppAssets.logo is correctly defined
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.rocket_launch_rounded, // Fallback icon
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
            ),
            
            // 🏷️ Title (Hidden on mobile to save space)
            title: !isMobile ? Text(
              'Shamil', // Consider localizing
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1.2,
              ),
            ) : null,
            
            // ⚙️ Actions
            actions: [
              if (!isMobile) ...[
                // 📥 Download Button for desktop
                AnimatedBuilder(
                  animation: _downloadController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_downloadController.value * 0.05), // Subtle scale animation
                      child: Container(
                        margin: const EdgeInsets.only(right: AppDimensions.paddingSmall),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _handleDownload,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingMedium,
                                vertical: AppDimensions.paddingSmall,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary, // Using secondary for gradient
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isDownloading)
                                    SizedBox(
                                      width: 16, height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.download_rounded,
                                      color: theme.colorScheme.onPrimary,
                                      size: 18,
                                    ),
                                  const SizedBox(width: AppDimensions.paddingSmall),
                                  Text(
                                    _isDownloading ? 'Downloading...' : 'Download', // Consider localizing
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // 🌐 Language Switcher
                const LanguageSwitcher(),
                const SizedBox(width: AppDimensions.paddingSmall),
                
                // 🌙 Theme Switcher
                const ThemeSwitcher(),
              ] else ...[
                // 📱 Mobile Menu Button
                IconButton(
                  onPressed: widget.onMenuTap, // Use the callback from the widget
                  icon: Icon(
                    Icons.menu_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
              ],
              const SizedBox(width: AppDimensions.paddingSmall), // Consistent right padding
            ],
          ),
        );
      },
    );
  }
}
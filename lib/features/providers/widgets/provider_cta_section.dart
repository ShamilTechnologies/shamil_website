import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

// Simple model for OS download options
class DesktopPlatform {
  final String name;
  final IconData icon;
  final String downloadUrl;
  final Color accentColor;

  const DesktopPlatform({
    required this.name,
    required this.icon,
    required this.downloadUrl,
    required this.accentColor,
  });
}

class ProviderCtaSection extends StatefulWidget {
  final AnimationController floatingParticlesController;

  const ProviderCtaSection({
    super.key,
    required this.floatingParticlesController,
  });

  @override
  State<ProviderCtaSection> createState() => _ProviderCtaSectionState();
}

class _ProviderCtaSectionState extends State<ProviderCtaSection>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _downloadIconController;
  late AnimationController _platformsController;
  
  // State management
  bool _showPlatforms = false;
  String? _selectedPlatform;
  
  // Desktop platforms configuration
  final List<DesktopPlatform> _platforms = [
    const DesktopPlatform(
      name: 'Windows',
      icon: Icons.window_rounded,
      downloadUrl: 'https://example.com/downloads/shamil-desktop-windows.zip',
      accentColor: Color(0xFF0078D4), // Windows blue
    ),
    const DesktopPlatform(
      name: 'macOS',
      icon: Icons.apple_rounded,
      downloadUrl: 'https://example.com/downloads/shamil-desktop-macos.zip',
      accentColor: Color(0xFF333333), // Apple black
    ),
    const DesktopPlatform(
      name: 'Linux',
      icon: Icons.computer_rounded,
      downloadUrl: 'https://example.com/downloads/shamil-desktop-linux.zip',
      accentColor: Color(0xFFE95420), // Ubuntu orange
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _downloadIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _platformsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _downloadIconController.dispose();
    _platformsController.dispose();
    super.dispose();
  }

  void _togglePlatformSelection() {
    setState(() {
      _showPlatforms = !_showPlatforms;
      if (_showPlatforms) {
        _platformsController.forward();
      } else {
        _platformsController.reverse();
      }
    });
  }

  Future<void> _downloadForPlatform(DesktopPlatform platform) async {
    setState(() {
      _selectedPlatform = platform.name;
    });

    // Add a small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 300));

    final uri = Uri.parse(platform.downloadUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    // Reset after download starts
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _selectedPlatform = null;
          _showPlatforms = false;
        });
        _platformsController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * (isMobile ? 1.0 : 1.2),
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: _buildSectionDecoration(theme),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(theme, isMobile),
              const SizedBox(height: AppDimensions.spacingExtraLarge * 2),
              _buildDownloadSection(theme, isMobile),
              const SizedBox(height: AppDimensions.spacingExtraLarge * 1.5),
              _buildTrustIndicators(theme),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildSectionDecoration(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF1A1D21),
                const Color(0xFF2A2D31),
                const Color(0xFF1A1D21),
              ]
            : [
                const Color(0xFFF5F7FA),
                const Color(0xFFE9ECEF),
                const Color(0xFFF5F7FA),
              ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Animated icon with floating effect
        AnimatedBuilder(
          animation: widget.floatingParticlesController,
          builder: (context, child) {
            final floatOffset = math.sin(widget.floatingParticlesController.value * 2 * math.pi) * 10;
            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryGold,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.desktop_windows_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          },
        ).animate().scale(delay: 100.ms, duration: 600.ms, curve: Curves.elasticOut),
        
        const SizedBox(height: AppDimensions.spacingLarge),
        
        // Title
        Text(
          ProviderStrings.ctaTitle.tr(),
          textAlign: TextAlign.center,
          style: (isMobile ? theme.textTheme.headlineMedium : theme.textTheme.displaySmall)
              ?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        
        const SizedBox(height: AppDimensions.spacingMedium),
        
        // Subtitle
        Text(
          ProviderStrings.ctaSubtitle.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildDownloadSection(ThemeData theme, bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: _showPlatforms ? (isMobile ? 280 : 200) : 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main download button
          if (!_showPlatforms)
            _buildMainDownloadButton(theme)
          else
            _buildPlatformSelection(theme, isMobile),
        ],
      ),
    );
  }

  Widget _buildMainDownloadButton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = 1.0 + (_pulseController.value * 0.05);
        final glowOpacity = 0.3 + (_pulseController.value * 0.2);
        
        return Transform.scale(
          scale: pulseScale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withOpacity(glowOpacity),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _togglePlatformSelection,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGold, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _downloadIconController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _downloadIconController.value * 2 * math.pi,
                            child: const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        ProviderStrings.downloadDesktopApp.tr(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    ).animate().scale(
      delay: 400.ms,
      duration: 600.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildPlatformSelection(ThemeData theme, bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ProviderStrings.selectYourOS.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLarge),
        Wrap(
          spacing: AppDimensions.paddingMedium,
          runSpacing: AppDimensions.paddingMedium,
          alignment: WrapAlignment.center,
          children: _platforms.map((platform) {
            final isSelected = _selectedPlatform == platform.name;
            final index = _platforms.indexOf(platform);
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _platformsController,
                curve: Interval(
                  index * 0.1,
                  0.5 + (index * 0.1),
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: _buildPlatformButton(platform, isSelected, theme),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        TextButton(
          onPressed: _togglePlatformSelection,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformButton(DesktopPlatform platform, bool isSelected, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _downloadForPlatform(platform),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? platform.accentColor.withOpacity(0.1)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? platform.accentColor
                  : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: platform.accentColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                platform.icon,
                size: 40,
                color: isSelected
                    ? platform.accentColor
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Text(
                platform.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? platform.accentColor
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustIndicators(ThemeData theme) {
    return Wrap(
      spacing: AppDimensions.paddingLarge * 1.5,
      runSpacing: AppDimensions.paddingMedium,
      alignment: WrapAlignment.center,
      children: [
        _buildTrustIndicator(
          theme,
          Icons.verified_user_rounded,
          ProviderStrings.uptimeIndicator.tr(),
          AppColors.primary,
        ),
        _buildTrustIndicator(
          theme,
          Icons.support_agent_rounded,
          ProviderStrings.supportIndicator.tr(),
          AppColors.primaryGold,
        ),
        _buildTrustIndicator(
          theme,
          Icons.business_rounded,
          ProviderStrings.trustedByIndicator.tr(),
          AppColors.accent,
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3);
  }

  Widget _buildTrustIndicator(
    ThemeData theme,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

// Enhanced step data model for desktop app journey
class DesktopAppStep {
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final Color accentColor;
  final String animationTag;
  final List<String> features;

  const DesktopAppStep({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.accentColor,
    required this.animationTag,
    required this.features,
  });
}

class ProviderHowItWorksSection extends StatefulWidget {
  final ScrollController scrollController;

  const ProviderHowItWorksSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<ProviderHowItWorksSection> createState() =>
      _ProviderHowItWorksSectionState();
}

class _ProviderHowItWorksSectionState extends State<ProviderHowItWorksSection>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _progressController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  
  // Interaction state
  int _activeStep = 0;
  bool _isAutoPlaying = true;
  
  // Desktop app journey steps
  final List<DesktopAppStep> _steps = [
    const DesktopAppStep(
      titleKey: "Download Desktop App",
      descriptionKey: "Get Shamil Desktop for Windows, macOS, or Linux. One-click installation, no complex setup required.",
      icon: Icons.download_for_offline_rounded,
      accentColor: AppColors.primary,
      animationTag: "download",
      features: ["2MB lightweight app", "Auto-updates", "Offline mode"],
    ),
    const DesktopAppStep(
      titleKey: "Quick Setup & Login",
      descriptionKey: "Launch the app and sign in with your provider account. Your dashboard syncs instantly across all devices.",
      icon: Icons.login_rounded,
      accentColor: AppColors.primaryGold,
      animationTag: "setup",
      features: ["Secure authentication", "Cloud sync", "Multi-device access"],
    ),
    const DesktopAppStep(
      titleKey: "Manage Everything",
      descriptionKey: "Access powerful tools: real-time bookings, customer management, analytics, and automated workflows.",
      icon: Icons.dashboard_customize_rounded,
      accentColor: AppColors.accent,
      animationTag: "manage",
      features: ["Live notifications", "Advanced analytics", "Team collaboration"],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoPlay();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _startAutoPlay() {
    if (!_isAutoPlaying) return;
    
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isAutoPlaying) {
        setState(() {
          _activeStep = (_activeStep + 1) % _steps.length;
        });
        _progressController.reset();
        _progressController.forward();
      }
    });
    
    _progressController.forward();
  }

  void _selectStep(int index) {
    setState(() {
      _activeStep = index;
      _isAutoPlaying = false;
    });
    _progressController.reset();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
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
      color: theme.colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              _buildHeader(theme, isMobile),
              SizedBox(height: isMobile ? 40 : 60),
              if (isMobile)
                _buildMobileLayout(theme)
              else
                _buildDesktopLayout(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // Animated badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                "GET STARTED IN 3 STEPS",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate()
         .fadeIn(delay: 100.ms)
         .slideY(begin: -0.2),

        const SizedBox(height: 20),

        // Title
        Text(
          "Your Journey to Digital Excellence",
          textAlign: TextAlign.center,
          style: (isMobile ? theme.textTheme.headlineMedium : theme.textTheme.displaySmall)
              ?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
        ).animate()
         .fadeIn(delay: 200.ms)
         .slideY(begin: 0.2),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          "Transform your business in minutes with Shamil Desktop",
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ).animate()
         .fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Column(
      children: [
        // Interactive timeline
        _buildInteractiveTimeline(theme),
        const SizedBox(height: 60),
        
        // Active step detail
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildStepDetail(theme, _steps[_activeStep], _activeStep),
        ),
      ],
    );
  }

  Widget _buildInteractiveTimeline(ThemeData theme) {
    return Container(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress line
          Positioned.fill(
            child: Row(
              children: List.generate(_steps.length - 1, (index) {
                final isActive = index < _activeStep;
                final isProgressing = index == _activeStep - 1;
                
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? _steps[index + 1].accentColor
                          : theme.dividerColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: isProgressing && _isAutoPlaying
                        ? LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(
                              _steps[index + 1].accentColor,
                            ),
                          )
                        : null,
                  ),
                );
              }),
            ),
          ),
          
          // Step nodes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_steps.length, (index) {
              return _buildTimelineNode(theme, index);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(ThemeData theme, int index) {
    final step = _steps[index];
    final isActive = index == _activeStep;
    final isCompleted = index < _activeStep;
    
    return GestureDetector(
      onTap: () => _selectStep(index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulseScale = isActive 
                ? 1.0 + (_pulseController.value * 0.08)
                : 1.0;
                
            return Transform.scale(
              scale: pulseScale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Node circle
                  Container(
                    width: isActive ? 80 : 60,
                    height: isActive ? 80 : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive || isCompleted
                          ? step.accentColor
                          : theme.cardColor,
                      border: Border.all(
                        color: isActive
                            ? step.accentColor
                            : theme.dividerColor.withOpacity(0.3),
                        width: isActive ? 3 : 2,
                      ),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: step.accentColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: Icon(
                      step.icon,
                      size: isActive ? 32 : 24,
                      color: isActive || isCompleted
                          ? Colors.white
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Step number
                  Text(
                    "Step ${index + 1}",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? step.accentColor
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).animate(delay: Duration(milliseconds: 400 + index * 100))
     .fadeIn()
     .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildStepDetail(ThemeData theme, DesktopAppStep step, int index) {
    return Container(
      key: ValueKey(step.animationTag),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: step.accentColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: step.accentColor.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Visual representation
          Expanded(
            flex: 1,
            child: _buildStepVisual(theme, step, index),
          ),
          
          const SizedBox(width: 60),
          
          // Content
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: step.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "STEP ${index + 1}",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: step.accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  step.titleKey,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  step.descriptionKey,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Features
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: step.features.map((feature) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: step.accentColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          feature,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 400.ms)
     .slideX(begin: 0.1);
  }

  Widget _buildStepVisual(ThemeData theme, DesktopAppStep step, int index) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final floatOffset = math.sin(_floatingController.value * 2 * math.pi) * 10;
        
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  step.accentColor.withOpacity(0.1),
                  step.accentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: step.accentColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: _buildStepIllustration(step, index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIllustration(DesktopAppStep step, int index) {
    switch (index) {
      case 0: // Download illustration
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.computer,
              size: 80,
              color: step.accentColor.withOpacity(0.2),
            ),
            Positioned(
              bottom: 20,
              child: Icon(
                Icons.download_rounded,
                size: 40,
                color: step.accentColor,
              ),
            ),
          ],
        );
        
      case 1: // Setup illustration
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 80,
              color: step.accentColor.withOpacity(0.2),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Icon(
                Icons.check_circle_rounded,
                size: 30,
                color: Colors.green,
              ),
            ),
          ],
        );
        
      case 2: // Dashboard illustration
        return Icon(
          Icons.dashboard_rounded,
          size: 100,
          color: step.accentColor,
        );
        
      default:
        return const SizedBox();
    }
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isActive = index == _activeStep;
        
        return GestureDetector(
          onTap: () => _selectStep(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isActive ? step.accentColor.withOpacity(0.1) : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? step.accentColor : theme.dividerColor.withOpacity(0.3),
                width: isActive ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isActive ? step.accentColor : step.accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.icon,
                    color: isActive ? Colors.white : step.accentColor,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Step ${index + 1}: ${step.titleKey}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isActive ? step.accentColor : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.descriptionKey,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ).animate(delay: Duration(milliseconds: 200 + index * 100))
         .fadeIn()
         .slideX(begin: 0.1);
      }),
    );
  }
}
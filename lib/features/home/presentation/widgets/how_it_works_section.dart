// lib/features/home/presentation/widgets/how_it_works_section.dart

import 'dart:async'; // Add Timer import
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:responsive_framework/responsive_framework.dart';

//region 📊 Data Models
/// Model representing each step in the Shamil workflow
class ShamildWorkflowStep {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData primaryIcon;
  final IconData decorativeIcon;
  final Color gradientStart;
  final Color gradientEnd;
  final String emoji;
  final List<String> keyFeatures;

  const ShamildWorkflowStep({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.primaryIcon,
    required this.decorativeIcon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.emoji,
    required this.keyFeatures,
  });
}

/// Enhanced card animation state for smooth physics
class CardAnimationState {
  final double offsetY;
  final double scale;
  final double opacity;
  final double rotation;
  final bool isVisible;

  const CardAnimationState({
    this.offsetY = 0.0,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.isVisible = true,
  });

  CardAnimationState copyWith({
    double? offsetY,
    double? scale,
    double? opacity,
    double? rotation,
    bool? isVisible,
  }) {
    return CardAnimationState(
      offsetY: offsetY ?? this.offsetY,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
//endregion

/// 🌟 Enhanced How It Works Section with Shamil Design System
/// Features: Stacked card effect, physics-based animations, premium glassmorphism
class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with TickerProviderStateMixin {

  //region 🎮 Controllers & State Management
  late AnimationController _entryController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _cardStackController;
  late AnimationController _swipeController; // New controller for swipe animations
  
  int _currentStep = 0;
  bool _hasAnimatedEntry = false;
  bool _isAnimating = false; // Prevent multiple simultaneous animations
  
  // Auto-play timer for automatic card switching
  Timer? _autoPlayTimer;
  static const Duration _autoPlayDuration = Duration(seconds: 4);
  //endregion

  //region 🎨 Shamil Design Configuration
  /// Shamil brand colors and design tokens
  static const Color _shamildBlue = Color(0xFF2A548D);
  static const Color _shamildGold = Color(0xFFD8A31A);
  static const Color _shamildBlueLight = Color(0xFF6385C3);
  static const Color _shamildGoldLight = Color(0xFFE0C068);
  
  /// Enhanced card stacking configuration for better visual effect
  static const double _cardSpacing = 32.0;
  static const double _cardOffsetIncrement = 28.0; // More pronounced upward offset
  static const double _cardScaleDecrement = 0.12; // More noticeable scale difference
  static const double _maxCardRotation = 0.035; // Slightly more rotation
  static const double _swipeThreshold = 50.0; // Swipe sensitivity
  //endregion

  //region 📋 Workflow Steps Data
  final List<ShamildWorkflowStep> _workflowSteps = [
    const ShamildWorkflowStep(
      id: 'discover',
      titleKey: AppStrings.step1Title,
      descriptionKey: AppStrings.step1Desc,
      primaryIcon: Icons.search_rounded,
      decorativeIcon: Icons.explore_rounded,
      gradientStart: _shamildBlue,
      gradientEnd: _shamildBlueLight,
      emoji: '🔍',
      keyFeatures: ['AI-powered search', 'Location-based results', 'Smart filters'],
    ),
    const ShamildWorkflowStep(
      id: 'book',
      titleKey: AppStrings.step2Title,
      descriptionKey: AppStrings.step2Desc,
      primaryIcon: Icons.calendar_today_rounded,
      decorativeIcon: Icons.schedule_rounded,
      gradientStart: _shamildGold,
      gradientEnd: _shamildGoldLight,
      emoji: '📅',
      keyFeatures: ['Real-time availability', 'Instant confirmation', 'Smart scheduling'],
    ),
    const ShamildWorkflowStep(
      id: 'enjoy',
      titleKey: AppStrings.step3Title,
      descriptionKey: AppStrings.step3Desc,
      primaryIcon: Icons.celebration_rounded,
      decorativeIcon: Icons.star_rounded,
      gradientStart: _shamildBlue,
      gradientEnd: _shamildGold,
      emoji: '✨',
      keyFeatures: ['Quality guarantee', 'Real-time tracking', 'Easy rebooking'],
    ),
  ];
  //endregion

  //region 🔄 Lifecycle Management
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _startAutoPlay(); // Start automatic card switching
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _entryController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _cardStackController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  /// 🎭 Initialize all animation controllers
  void _initializeAnimations() {
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _cardStackController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  /// 🚀 Start coordinated animation sequence
  void _startAnimationSequence() {
    // Start floating animation immediately
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    
    // Trigger entry animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _entryController.forward();
        _cardStackController.forward();
        setState(() => _hasAnimatedEntry = true);
      }
    });
  }

  /// ⏰ Start automatic card switching
  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(_autoPlayDuration, (timer) {
      if (mounted && !_isAnimating) {
        _nextStep();
      }
    });
  }

  /// ⏸️ Stop automatic card switching (when user interacts)
  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  /// ▶️ Restart automatic card switching after user interaction
  void _restartAutoPlay() {
    _stopAutoPlay();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _startAutoPlay();
    });
  }
  //endregion

  //region 🎯 Interaction Handlers
  /// Handle step navigation with smooth transitions
  void _navigateToStep(int stepIndex) {
    if (stepIndex == _currentStep || stepIndex >= _workflowSteps.length || _isAnimating) return;
    
    _stopAutoPlay();
    _performCardSwipe(stepIndex);
    _restartAutoPlay();
  }

  /// 🔄 Perform smooth card swipe animation
  Future<void> _performCardSwipe(int targetStep) async {
    if (_isAnimating) return;
    
    setState(() => _isAnimating = true);
    
    // Animate the swipe transition
    await _swipeController.forward();
    
    // Update the current step
    setState(() => _currentStep = targetStep);
    
    // Reset and restart card stack animation
    _cardStackController.reset();
    await _cardStackController.forward();
    
    // Reset swipe controller and animation state
    _swipeController.reset();
    setState(() => _isAnimating = false);
  }

  /// ➡️ Navigate to next step
  void _nextStep() {
    final nextStep = (_currentStep + 1) % _workflowSteps.length;
    _navigateToStep(nextStep);
  }

  /// ⬅️ Navigate to previous step
  void _previousStep() {
    final prevStep = _currentStep == 0 ? _workflowSteps.length - 1 : _currentStep - 1;
    _navigateToStep(prevStep);
  }

  /// Calculate enhanced card animation state with better stacking
  CardAnimationState _calculateCardState(int cardIndex, bool isMobile) {
    final distanceFromCurrent = cardIndex - _currentStep;
    final absDistance = distanceFromCurrent.abs();
    
    // Show more cards for better depth perception
    final isVisible = absDistance <= 2 && cardIndex >= _currentStep;
    
    if (!isVisible) {
      return const CardAnimationState(isVisible: false, opacity: 0.0);
    }
    
    // Enhanced stacking calculations for more dramatic effect
    final stackOffset = absDistance * _cardOffsetIncrement;
    final scaleReduction = absDistance * _cardScaleDecrement;
    final rotationAngle = distanceFromCurrent * _maxCardRotation;
    
    // Create more dramatic opacity differences
    double opacity = 1.0;
    if (cardIndex != _currentStep) {
      opacity = math.max(0.4, 1.0 - (absDistance * 0.25));
    }
    
    return CardAnimationState(
      offsetY: -stackOffset, // Negative for upward movement
      scale: math.max(0.7, 1.0 - scaleReduction), // Prevent too small cards
      opacity: opacity,
      rotation: rotationAngle,
      isVisible: true,
    );
  }

  /// 👆 Handle card tap with haptic feedback
  void _handleCardTap(int stepIndex) {
    // Add haptic feedback for better UX
    // HapticFeedback.lightImpact(); // Uncomment if haptic feedback is needed
    _navigateToStep(stepIndex);
  }

  /// 🖱️ Handle swipe gestures for better mobile experience
  void _handlePanEnd(DragEndDetails details) {
    if (_isAnimating) return;
    
    final velocity = details.velocity.pixelsPerSecond.dx;
    
    if (velocity.abs() > _swipeThreshold) {
      if (velocity > 0) {
        _previousStep(); // Swipe right = previous
      } else {
        _nextStep(); // Swipe left = next
      }
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    
    return Container(
      decoration: _buildShamildBackground(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingPageHorizontal,
          vertical: isMobile ? 80 : 120,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // 🏆 Section Header
                _buildShamildHeader(theme, isMobile),
                
                SizedBox(height: isMobile ? 60 : 100),
                
                // 🎠 Main Card Stack Display
                _buildCardStackSection(theme, isMobile),
                
                SizedBox(height: isMobile ? 40 : 60),
                
                // 🔘 Step Navigation
                _buildStepNavigation(theme, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //region 🎨 UI Building Methods
  /// Build Shamil-themed gradient background
  BoxDecoration _buildShamildBackground(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: theme.brightness == Brightness.light
            ? [
                const Color(0xFFFCFCFD),
                _shamildBlue.withOpacity(0.03),
                _shamildGold.withOpacity(0.02),
                const Color(0xFFFFFFFF),
              ]
            : [
                const Color(0xFF0F172A),
                const Color(0xFF1E293B),
                _shamildBlue.withOpacity(0.1),
                const Color(0xFF0F172A),
              ],
      ),
    );
  }

  /// 🏆 Build premium section header
  Widget _buildShamildHeader(ThemeData theme, bool isMobile) {
    return Column(
      children: [
        // ✨ Animated badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _shamildBlue.withOpacity(0.1),
                _shamildGold.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: _shamildBlue.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _shamildBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _shamildBlue.withOpacity(0.4 + _pulseController.value * 0.3),
                          blurRadius: 4 + _pulseController.value * 6,
                          spreadRadius: _pulseController.value * 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                '🚀 How Shamil Works',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _shamildBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate(controller: _entryController)
         .fadeIn(delay: 200.ms, duration: 600.ms)
         .slideY(begin: -0.2, curve: Curves.easeOutCubic),

        const SizedBox(height: 32),

        // 🎯 Main title with Shamil gradient
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [_shamildBlue, _shamildGold, _shamildBlue],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            AppStrings.howItWorksTitle.tr(),
            style: (isMobile 
                ? theme.textTheme.displaySmall 
                : theme.textTheme.displayLarge)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate(controller: _entryController)
         .fadeIn(delay: 400.ms, duration: 800.ms)
         .slideY(begin: 0.2, curve: Curves.easeOutCubic),

        const SizedBox(height: 20),

        // 📝 Subtitle
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Experience the seamless journey from discovery to enjoyment with our intelligent platform',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ).animate(controller: _entryController)
         .fadeIn(delay: 600.ms, duration: 600.ms)
         .slideY(begin: 0.2, curve: Curves.easeOutCubic),
      ],
    );
  }

  /// 🎠 Build the main card stack section with enhanced interactions
  Widget _buildCardStackSection(ThemeData theme, bool isMobile) {
    final cardHeight = isMobile ? 400.0 : 460.0; // Slightly taller cards
    final cardWidth = isMobile ? 340.0 : 400.0; // Slightly wider cards

    return GestureDetector(
      onPanEnd: _handlePanEnd, // Add swipe gesture support
      child: SizedBox(
        height: cardHeight + 120, // More extra space for dramatic stacking
        width: cardWidth + 40, // Extra width for rotation effect
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 🌟 Enhanced background glow effect
            _buildBackgroundGlow(theme),
            
            // ⬅️ Previous button (left side)
            Positioned(
              left: -20,
              child: _buildNavigationButton(
                theme,
                Icons.chevron_left_rounded,
                _previousStep,
                'Previous Step',
              ),
            ),
            
            // ➡️ Next button (right side)
            Positioned(
              right: -20,
              child: _buildNavigationButton(
                theme,
                Icons.chevron_right_rounded,
                _nextStep,
                'Next Step',
              ),
            ),
            
            // 🃏 Enhanced stacked cards (render in order for proper layering)
            ...List.generate(_workflowSteps.length, (index) {
              return _buildAnimatedCard(
                theme,
                _workflowSteps[index],
                index,
                isMobile,
                cardWidth,
                cardHeight,
              );
            }),
            
            // 🔄 Loading indicator during transitions
            if (_isAnimating)
              Positioned(
                bottom: -40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _shamildBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _shamildBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(_shamildBlue),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Switching...',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _shamildBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔘 Build navigation button
  Widget _buildNavigationButton(
    ThemeData theme,
    IconData icon,
    VoidCallback onPressed,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isAnimating ? null : onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _shamildBlue.withOpacity(0.9),
                  _shamildGold.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _shamildBlue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  /// 🌟 Build dynamic background glow
  Widget _buildBackgroundGlow(ThemeData theme) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatingController, _pulseController]),
      builder: (context, child) {
        return Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _shamildBlue.withOpacity(0.1 + _pulseController.value * 0.05),
                _shamildGold.withOpacity(0.05 + _pulseController.value * 0.03),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  /// 🃏 Build individual animated card with enhanced effects
  Widget _buildAnimatedCard(
    ThemeData theme,
    ShamildWorkflowStep step,
    int stepIndex,
    bool isMobile,
    double cardWidth,
    double cardHeight,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([_cardStackController, _floatingController, _swipeController]),
      builder: (context, child) {
        final cardState = _calculateCardState(stepIndex, isMobile);
        
        if (!cardState.isVisible) {
          return const SizedBox.shrink();
        }

        // Enhanced floating effect with different patterns for each card
        final floatingOffset = stepIndex == _currentStep 
            ? math.sin(_floatingController.value * 2 * math.pi) * 8
            : math.sin(_floatingController.value * 2 * math.pi + stepIndex) * 3;

        // Add swipe animation effect
        final swipeOffset = _isAnimating ? _swipeController.value * 20 : 0.0;

        return Transform.translate(
          offset: Offset(
            stepIndex == _currentStep ? swipeOffset : 0, 
            cardState.offsetY + floatingOffset,
          ),
          child: Transform.scale(
            scale: cardState.scale,
            child: Transform.rotate(
              angle: cardState.rotation,
              child: AnimatedOpacity(
                opacity: cardState.opacity,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: () => _handleCardTap(stepIndex),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => _stopAutoPlay(),
                    onExit: (_) => _restartAutoPlay(),
                    child: _buildShamildCard(
                      theme,
                      step,
                      stepIndex == _currentStep,
                      cardWidth,
                      cardHeight,
                      isMobile,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 💎 Build premium Shamil-styled card
  Widget _buildShamildCard(
    ThemeData theme,
    ShamildWorkflowStep step,
    bool isActive,
    double cardWidth,
    double cardHeight,
    bool isMobile,
  ) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [step.gradientStart, step.gradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: step.gradientStart.withOpacity(isActive ? 0.4 : 0.2),
            blurRadius: isActive ? 25 : 15,
            spreadRadius: isActive ? 2 : 0,
            offset: Offset(0, isActive ? 12 : 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            child: _buildCardContent(theme, step, isActive, isMobile),
          ),
        ),
      ),
    );
  }

  /// 📝 Build card content layout
  Widget _buildCardContent(
    ThemeData theme,
    ShamildWorkflowStep step,
    bool isActive,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🎭 Header with emoji and decorative icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  step.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            Icon(
              step.decorativeIcon,
              color: Colors.white.withOpacity(0.6),
              size: 32,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // 🏷️ Title
        Text(
          step.titleKey.tr(),
          style: (isMobile 
              ? theme.textTheme.headlineMedium 
              : theme.textTheme.headlineLarge)?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // 📖 Description
        Text(
          step.descriptionKey.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        const Spacer(),
        
        // ✨ Key features
        if (isActive) ...[
          ...step.keyFeatures.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 16),
        ],
        
        // 👆 Enhanced interaction hint with auto-play indicator
        if (isActive)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Icon(
                        Icons.touch_app_rounded,
                        color: Colors.white.withOpacity(0.7 + _pulseController.value * 0.3),
                        size: 16,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to explore • Auto-switching',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// 🔘 Build step navigation indicators
  Widget _buildStepNavigation(ThemeData theme, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_workflowSteps.length, (index) {
        final isActive = index == _currentStep;
        final step = _workflowSteps[index];
        
        return GestureDetector(
          onTap: () => _navigateToStep(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: isActive ? 50 : 12,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: isActive
                  ? LinearGradient(
                      colors: [step.gradientStart, step.gradientEnd],
                    )
                  : LinearGradient(
                      colors: [
                        theme.colorScheme.outline.withOpacity(0.3),
                        theme.colorScheme.outline.withOpacity(0.2),
                      ],
                    ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: step.gradientStart.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ).animate(delay: (index * 100).ms)
         .fadeIn(duration: 600.ms)
         .slideY(begin: 0.2, curve: Curves.easeOutCubic);
      }),
    );
  }
  //endregion
}
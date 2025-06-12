// lib/features/home/presentation/widgets/how_it_works_section.dart

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
// import 'package:shamil_web/core/constants/app_strings.dart'; // Assuming AppStrings.howItWorksTitle etc. are defined
import 'package:responsive_framework/responsive_framework.dart';

//region 🎨 Shamil Brand Colors (centralized for this section)
const Color _shamilBlue = Color(0xFF2A548D);
const Color _shamilGold = Color(0xFFD8A31A);
const Color _shamilBlueLight = Color(0xFF6385C3); // Accent for blue cards
const Color _shamilGoldLight = Color(0xFFE0C068); // Accent for gold cards
//endregion

//region 📊 Data Models
class ShamildStep {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final String illustration;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> features;

  const ShamildStep({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.illustration,
    required this.primaryColor,
    required this.secondaryColor,
    this.features = const [],
  });
}
//endregion

class EnhancedStepsSection extends StatefulWidget {
  const EnhancedStepsSection({super.key});

  @override
  State<EnhancedStepsSection> createState() => _EnhancedStepsSectionState();
}

class _EnhancedStepsSectionState extends State<EnhancedStepsSection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundAnimationController;
  late Animation<Alignment> _gradientBeginAlignment;
  late Animation<Alignment> _gradientEndAlignment;

  int _currentStep = 0;
  double _pageOffset = 0.0;

  static const double _cardAspectRatio = 0.70;
  static const double _cardMaxRotation = 0.05;
  static const double _cardMaxScale = 0.12;

  final List<ShamildStep> _steps = [
    ShamildStep(
      id: 'discover',
      titleKey: 'Discover Services'.tr(),
      descriptionKey:
          'Browse and find the perfect service providers near you with smart filters and AI recommendations.'
              .tr(),
      icon: Icons.explore_outlined,
      illustration: '🔍',
      primaryColor: _shamilBlue,
      secondaryColor: _shamilBlueLight,
      features: [
        'Location-based search'.tr(),
        'Smart filters'.tr(),
        'AI recommendations'.tr(),
      ],
    ),
    ShamildStep(
      id: 'book',
      titleKey: 'Book Instantly'.tr(),
      descriptionKey:
          'Schedule appointments with just a few taps. See real-time availability and get instant confirmations.'
              .tr(),
      icon: Icons.calendar_today_outlined,
      illustration: '📅',
      primaryColor: _shamilGold,
      secondaryColor: _shamilGoldLight,
      features: [
        'Real-time slots'.tr(),
        'Instant booking'.tr(),
        'Smart scheduling'.tr(),
      ],
    ),
    ShamildStep(
      id: 'access',
      titleKey: 'Easy Access'.tr(),
      descriptionKey:
          'Use QR codes or NFC tags for seamless check-ins. No more waiting in lines or paperwork.'
              .tr(),
      icon: Icons.qr_code_2_rounded,
      illustration: '🎫',
      primaryColor: _shamilBlue,
      secondaryColor: _shamilBlueLight,
      features: ['QR check-in'.tr(), 'NFC support'.tr(), 'Digital passes'.tr()],
    ),
    ShamildStep(
      id: 'manage',
      titleKey: 'Manage Everything'.tr(),
      descriptionKey:
          'Track your bookings, manage subscriptions, and access your history all in one place.'
              .tr(),
      icon: Icons.dashboard_outlined,
      illustration: '📊',
      primaryColor: _shamilGold,
      secondaryColor: _shamilGoldLight,
      features: [
        'Booking history'.tr(),
        'Subscription management'.tr(),
        'Analytics'.tr(),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: _currentStep,
    )..addListener(_onPageScroll);

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 30), // Slowed down for smoother visual
      vsync: this,
    )..repeat(reverse: true); // Gradient will shift back and forth

    // Define sequences for gradient alignment animation
    _gradientBeginAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
    ]).animate(_backgroundAnimationController);

    _gradientEndAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
    ]).animate(_backgroundAnimationController);
  }

  void _onPageScroll() {
    if (_pageController.hasClients) {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  void _goToStep(int index) {
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450), // Slightly faster page snap
      curve: Curves.easeInOutCubic,
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _goToStep(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return SizedBox(
      height: isMobile ? 700 : 780, // Adjusted height slightly for mobile
      child: Stack(
        children: [
          _buildAnimatedBackground(theme), // Main animated gradient background
          _buildSubtleDotPattern(theme), // Layered subtle dot pattern
          Column(
            children: [
              _buildHeader(theme, isMobile),
              Expanded(child: _buildCardsArea(theme, isMobile)),
              _buildNavigationControls(theme, isMobile),
              SizedBox(
                height:
                    isMobile
                        ? AppDimensions.paddingMedium
                        : AppDimensions.paddingLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        List<Color> gradientColors;
        if (theme.brightness == Brightness.light) {
          gradientColors = [
            Colors.grey.shade50,
            _shamilBlue.withOpacity(0.03),
            _shamilGold.withOpacity(0.02),
            Colors.grey.shade100,
          ];
        } else {
          gradientColors = [
            const Color(0xFF0A0E1A),
            _shamilBlue.withOpacity(0.08),
            _shamilGold.withOpacity(0.05),
            const Color(0xFF0D131C),
          ];
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _gradientBeginAlignment.value,
              end: _gradientEndAlignment.value,
              colors: gradientColors,
              stops: const [
                0.0,
                0.35,
                0.65,
                1.0,
              ], // Adjusted stops for smoother transition
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtleDotPattern(ThemeData theme) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation:
            _backgroundAnimationController, // Can use the same or a different controller
        builder: (context, child) {
          return CustomPaint(
            painter: _BackgroundPatternPainter(
              animation: _backgroundAnimationController.value,
              color:
                  theme.brightness == Brightness.light
                      ? _shamilBlue.withOpacity(0.012) // Even more subtle
                      : _shamilGold.withOpacity(0.006), // Even more subtle
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(
        top:
            isMobile
                ? AppDimensions.paddingLarge
                : AppDimensions.paddingExtraLarge,
        bottom: AppDimensions.paddingSmall, // Reduced bottom padding
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _shamilBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusCircle,
              ),
              border: Border.all(
                color: _shamilBlue.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              'How It Works'.tr(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: _shamilBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
          const SizedBox(height: AppDimensions.spacingMedium - 4), // Reduced
          Text(
            'Your Journey with Shamil'.tr(),
            style: (isMobile
                    ? theme.textTheme.headlineSmall
                    : theme.textTheme.displaySmall)
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: theme.colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: AppDimensions.spacingSmall - 2), // Reduced
          Padding(
            // Added padding for better text wrapping on mobile
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSmall,
            ),
            child: Text(
              'Four simple steps to transform your service experience.'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: isMobile ? 15 : null, // Slightly smaller on mobile
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsArea(ThemeData theme, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            isMobile
                ? constraints.maxWidth *
                    0.72 // Slightly increase visible part of side cards
                : math.min(
                  350.0,
                  constraints.maxWidth * 0.33,
                ); // Max card width
        final cardHeight = cardWidth / _cardAspectRatio;

        return Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ), // Smoother physics
              onPageChanged: (index) {
                setState(() => _currentStep = index);
                HapticFeedback.selectionClick();
              },
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return _buildStepCardView(theme, index, cardWidth, cardHeight);
              },
            ),
            if (!isMobile) ...[
              Positioned(
                left: AppDimensions.paddingMedium, // Closer to cards
                child: _buildNavigationArrow(
                  theme,
                  Icons.arrow_back_ios_new_rounded, // Changed icon
                  _currentStep > 0,
                  _previousStep,
                ),
              ),
              Positioned(
                right: AppDimensions.paddingMedium, // Closer to cards
                child: _buildNavigationArrow(
                  theme,
                  Icons.arrow_forward_ios_rounded, // Changed icon
                  _currentStep < _steps.length - 1,
                  _nextStep,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStepCardView(
    ThemeData theme,
    int index,
    double cardWidth,
    double cardHeight,
  ) {
    final difference = (_pageOffset - index).abs();
    final isActive =
        difference < 0.5; // Card is "active" if it's the most centered

    // Smoother interpolation for scale and rotation
    final double progress = math.min(
      1.0,
      difference,
    ); // 0 for active, 1 for fully off-center

    final scale = 1.0 - (progress * _cardMaxScale);
    final rotationY =
        (_pageOffset - index) *
        _cardMaxRotation *
        (1 - progress * 0.5); // Reduce rotation for further cards
    final opacity = math.max(
      0.0,
      1.0 - progress * 0.5,
    ); // Non-active cards fade more

    return Center(
      child: Transform(
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..scale(scale)
              ..rotateY(rotationY),
        alignment: Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150), // Faster opacity change
          opacity: opacity,
          child: StepCardView(
            step: _steps[index],
            isActive: isActive, // Pass isActive directly
            width: cardWidth,
            height: cardHeight,
            onTap: () => _goToStep(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationArrow(
    ThemeData theme,
    IconData icon,
    bool isEnabled,
    VoidCallback onTap,
  ) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isEnabled ? 1.0 : 0.15, // More faded when disabled
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircle),
          child: Container(
            padding: const EdgeInsets.all(
              AppDimensions.paddingSmall - 2,
            ), // Slightly smaller padding
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(
                0.6,
              ), // More translucent
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6, // Softer shadow
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24, // Slightly smaller icon
              color:
                  isEnabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.25),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls(ThemeData theme, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (index) {
              final isActive = index == _currentStep;
              final step = _steps[index];
              return GestureDetector(
                onTap: () => _goToStep(index),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 400,
                  ), // Smoother transition
                  curve: Curves.easeInOutCubic,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ), // Reduced margin
                  width: isActive ? 30 : 8, // More distinct active indicator
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4), // Pill shape
                    color:
                        isActive
                            ? step.primaryColor
                            : theme.colorScheme.outline.withOpacity(
                              0.2,
                            ), // More subtle inactive
                    boxShadow:
                        isActive
                            ? [
                              BoxShadow(
                                color: step.primaryColor.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 1),
                              ),
                            ]
                            : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppDimensions.spacingSmall + 2),
          Text(
            'Step ${_currentStep + 1} of ${_steps.length}'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              // Use bodySmall for better hierarchy
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  //endregion
}

class StepCardView extends StatefulWidget {
  final ShamildStep step;
  final bool isActive;
  final double width;
  final double height;
  final VoidCallback onTap;

  const StepCardView({
    super.key,
    required this.step,
    required this.isActive,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<StepCardView> createState() => _StepCardViewState();
}

class _StepCardViewState extends State<StepCardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200), // Faster hover
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        if (mounted) setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        if (mounted) setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform:
              Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0), // Reduced hover lift
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusLarge + 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.step.primaryColor.withOpacity(
                  _isHovered ? 1.0 : 0.95,
                ), // Slightly change opacity on hover
                widget.step.secondaryColor.withOpacity(
                  _isHovered ? 0.90 : 0.80,
                ),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.step.primaryColor.withOpacity(
                  widget.isActive ? (_isHovered ? 0.25 : 0.18) : 0.08,
                ),
                blurRadius: widget.isActive ? (_isHovered ? 28 : 22) : 12,
                spreadRadius: widget.isActive ? (_isHovered ? 2 : 0) : -3,
                offset: Offset(0, widget.isActive ? (_isHovered ? 14 : 10) : 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge + 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            AppDimensions.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium - 2,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            widget.step.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Text(
                          widget.step.illustration,
                          style: TextStyle(
                            fontSize: widget.isActive ? 40 : 36,
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingMedium + 4),
                    Text(
                      widget
                          .step
                          .titleKey, // No .tr() as it's already a direct string from model
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ResponsiveValue(
                              context,
                              defaultValue: 22.0,
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: MOBILE,
                                  value: 20.0,
                                ),
                              ],
                            ).value,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingSmall),
                    Text(
                      widget.step.descriptionKey, // No .tr()
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.82),
                        height: 1.4,
                        fontSize:
                            ResponsiveValue(
                              context,
                              defaultValue: 14.0,
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: MOBILE,
                                  value: 13.0,
                                ),
                              ],
                            ).value,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                if (widget.step.features.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        widget.step.features
                            .take(2)
                            .map(
                              (feature) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppDimensions.spacingSmall - 4,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.20),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 7,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppDimensions.spacingSmall - 2,
                                    ),
                                    Expanded(
                                      child: Text(
                                        feature
                                            .tr(), // Assuming features are keys for localization
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(
                                                0.70,
                                              ),
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  final double animation;
  final Color color;

  _BackgroundPatternPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final spacing = 90.0; // Wider spacing
    final offset =
        animation * spacing * 0.3; // Even slower movement for subtlety

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(
          Offset(x + offset, y + offset * 0.6),
          1.2,
          paint,
        ); // Smaller, fainter dots
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPatternPainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.color != color;
}

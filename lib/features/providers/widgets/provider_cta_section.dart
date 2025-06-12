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

class FloatingParticle {
  Offset position;
  double radius;
  Color color;
  double speed;
  double opacity;
  double angle;

  FloatingParticle({
    required this.position,
    required this.radius,
    required this.color,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}

class ParticlePainter extends CustomPainter {
  final List<FloatingParticle> particles;
  final Animation<double> animation;

  ParticlePainter({required this.particles, required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    if (size.isEmpty || particles.isEmpty) return;

    for (var particle in particles) {
      double dx = math.cos(particle.angle) * particle.speed * 0.1;
      double dy = math.sin(particle.angle) * particle.speed * 0.1;
      double newX = particle.position.dx + dx;
      double newY = particle.position.dy - dy;

      if (newX < -particle.radius) newX = size.width + particle.radius;
      if (newX > size.width + particle.radius) newX = -particle.radius;
      if (newY < -particle.radius) newY = size.height + particle.radius;
      if (newY > size.height + particle.radius) newY = -particle.radius;
      particle.position = Offset(newX, newY);

      final double dynamicPulseOpacity = (0.5 +
              (math.sin(animation.value * 2 * math.pi + particle.angle * 2) +
                      1) /
                  4)
          .clamp(0.1, 1.0);
      paint.color =
          particle.color.withOpacity(particle.opacity * dynamicPulseOpacity);
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
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
  List<FloatingParticle> _particles = [];
  final int _numParticles = 25;
  final math.Random _random = math.Random();
  late AnimationController _pulseButtonController;
  bool _particlesInitialized = false;

  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _menuAnimationController;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _pulseButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _initParticles(Size size) {
    if (_particlesInitialized || !mounted || size.isEmpty) return;
    _particlesInitialized = true;
    _particles = List.generate(_numParticles, (index) {
      return FloatingParticle(
        position: Offset(
            _random.nextDouble() * size.width, _random.nextDouble() * size.height),
        radius: _random.nextDouble() * 1.5 + 0.5,
        color: _random.nextBool()
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.primaryGold.withOpacity(0.2),
        speed: _random.nextDouble() * 0.25 + 0.05,
        opacity: _random.nextDouble() * 0.4 + 0.1,
        angle: _random.nextDouble() * 2 * math.pi,
      );
    });
    setState(() {});
  }

  @override
  void dispose() {
    _pulseButtonController.dispose();
    _menuAnimationController.dispose();
    _hideDownloadMenu();
    super.dispose();
  }

  void _showDownloadMenu() {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideDownloadMenu,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: offset.dy - 10,
              left: offset.dx + size.width / 2,
              child: _buildDownloadMenu(),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _menuAnimationController.forward();
  }

  void _hideDownloadMenu() {
    if (!_isMenuOpen) return;
    _isMenuOpen = false;
    _menuAnimationController.reverse().then((_) {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }

  Widget _buildDownloadMenu() {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _menuAnimationController, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0.2),
          end: const Offset(-0.5, -1),
        ).animate(CurvedAnimation(parent: _menuAnimationController, curve: Curves.easeOutCubic)),
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                width: 280,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: Text(
                        ProviderStrings.selectYourOS.tr(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white.withOpacity(0.9) : AppColors.primary,
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
                    _buildMenuItem(
                      icon: Icons.window_rounded,
                      label: ProviderStrings.downloadForWindows.tr(),
                      url: 'https://example.com/downloads/shamil-desktop-windows.zip',
                    ),
                    _buildMenuItem(
                      icon: Icons.apple_rounded,
                      label: ProviderStrings.downloadForMacOS.tr(),
                      url: 'https://example.com/downloads/shamil-desktop-macos.zip',
                    ),
                    _buildMenuItem(
                      icon: Icons.computer_rounded,
                      label: ProviderStrings.downloadForLinux.tr(),
                      url: 'https://example.com/downloads/shamil-desktop-linux.zip',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () async {
        _hideDownloadMenu();
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      hoverColor: AppColors.primary.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const shamilBlue = AppColors.primary;
    const shamilGold = AppColors.primaryGold;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * 1.2,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.brightness == Brightness.dark
              ? [
                  shamilBlue.withOpacity(0.85),
                  shamilGold.withOpacity(0.7),
                  shamilBlue.withOpacity(0.85)
                ]
              : [
                  shamilBlue,
                  Color.lerp(shamilBlue, shamilGold, 0.55)!,
                  shamilGold
                ],
          begin: const FractionalOffset(0.0, 0.5),
          end: const FractionalOffset(1.0, 0.5),
          stops: const [0.0, 0.5, 1.0],
          transform: const GradientRotation(math.pi / 40),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (!_particlesInitialized &&
                    constraints.hasBoundedWidth &&
                    constraints.biggest.width > 0) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _initParticles(constraints.biggest));
                }
                if (_particles.isNotEmpty) {
                  return CustomPaint(
                    size: constraints.biggest,
                    painter: ParticlePainter(
                        particles: _particles,
                        animation: widget.floatingParticlesController),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ProviderStrings.ctaTitle.tr(),
                textAlign: TextAlign.center,
                style: Helpers.responsiveValue(
                  context,
                  mobile: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5),
                  desktop: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
              const SizedBox(height: AppDimensions.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium),
                child: Text(
                  ProviderStrings.ctaSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ),
              const SizedBox(height: AppDimensions.spacingLarge * 1.8),
              AnimatedBuilder(
                animation: _pulseButtonController,
                builder: (context, child) {
                  final pulseScale = 1.0 + (_pulseButtonController.value * 0.035);
                  return Transform.scale(
                    scale: pulseScale,
                    child: child,
                  );
                },
                child: CustomButton(
                  key: _buttonKey,
                  text: ProviderStrings.downloadDesktopApp.tr(),
                  onPressed: () {
                    _isMenuOpen ? _hideDownloadMenu() : _showDownloadMenu();
                  },
                  backgroundColor: AppColors.white,
                  foregroundColor: shamilBlue,
                  elevation: 12,
                  icon: const Icon(Icons.download_for_offline_outlined, size: 24),
                ),
              ).animate().fadeIn(delay: 400.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 600.ms,
                  curve: Curves.elasticOut),
              const SizedBox(height: AppDimensions.spacingLarge * 1.5),
              Wrap(
                spacing: AppDimensions.paddingLarge,
                runSpacing: AppDimensions.paddingMedium,
                alignment: WrapAlignment.center,
                children: [
                  _buildTrustIndicator(theme, Icons.shield_outlined,
                      ProviderStrings.uptimeIndicator.tr()),
                  // ** FIX IS HERE **: Corrected the icon name from support_agent__rounded
                  _buildTrustIndicator(theme, Icons.support_agent_rounded,
                      ProviderStrings.supportIndicator.tr()),
                  _buildTrustIndicator(theme, Icons.people_alt_outlined,
                      ProviderStrings.trustedByIndicator.tr()),
                ],
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicator(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.85), size: 18),
        const SizedBox(width: AppDimensions.spacingSmall - 2),
        Text(
          text,
          style:
              theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.85)),
        ),
      ],
    );
  }
}
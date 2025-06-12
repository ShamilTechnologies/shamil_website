// lib/features/home/presentation/widgets/shamil_showcase_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_assets.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ShamilShowcaseSection extends StatefulWidget {
  final ScrollController scrollController;

  const ShamilShowcaseSection({
    super.key,
    required this.scrollController,
  });

  @override
  State<ShamilShowcaseSection> createState() => _ShamilShowcaseSectionState();
}

class _ShamilShowcaseSectionState extends State<ShamilShowcaseSection> {
  final GlobalKey _sectionKey = GlobalKey();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    // Initial check after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || _sectionKey.currentContext == null) return;

    final renderBox = _sectionKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollPosition = position.dy;

    // Show when at least 30% of the widget is visible
    final shouldBeVisible = scrollPosition < screenHeight * 0.7;

    if (_isVisible != shouldBeVisible) {
      setState(() => _isVisible = shouldBeVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final Color phoneScreenBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.white;

    return Container(
      key: _sectionKey,
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * 1.5,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ResponsiveRowColumn(
            layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowSpacing: AppDimensions.paddingLarge * 2,
            columnSpacing: AppDimensions.paddingLarge * 2,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: _buildPhoneMockup(phoneScreenBackgroundColor, isMobile),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: _buildTextContent(theme, isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneMockup(Color screenBackgroundColor, bool isMobile) {
    return PhoneMockup(
      appInterfaceAsset: AppAssets.shamilAppInterface,
      screenBackgroundColor: screenBackgroundColor,
      defaultWidth: isMobile ? 200 : 260,
    )
        .animate(target: _isVisible ? 1 : 0)
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutCubic)
        .slideX(begin: -0.3, curve: Curves.easeOutCubic);
  }

  Widget _buildTextContent(ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(left: isMobile ? 0 : AppDimensions.paddingLarge * 3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            "Experience Shamil in Action",
            style: (isMobile ? theme.textTheme.headlineMedium : theme.textTheme.displaySmall)
                ?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          )
              .animate(target: _isVisible ? 1 : 0, delay: 150.ms)
              .fadeIn(duration: 600.ms),

          const SizedBox(height: AppDimensions.spacingMedium),

          Text(
            "Discover how Shamil transforms your service booking experience with intelligent features and seamless interface design.",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.85),
              height: 1.65,
              fontSize: isMobile ? 16 : 18,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
          )
              .animate(target: _isVisible ? 1 : 0, delay: 300.ms)
              .fadeIn(duration: 600.ms),
        ],
      )
          .animate(target: _isVisible ? 1 : 0)
          .slideX(begin: 0.3, curve: Curves.easeOutCubic),
    );
  }
}

class PhoneMockup extends StatelessWidget {
  final String appInterfaceAsset;
  final Color screenBackgroundColor;
  final double? defaultWidth;

  const PhoneMockup({
    super.key,
    required this.appInterfaceAsset,
    required this.screenBackgroundColor,
    this.defaultWidth,
  });

  @override
  Widget build(BuildContext context) {
    final double phoneWidth = defaultWidth ?? 
        ResponsiveValue(
          context,
          defaultValue: 240.0,
          conditionalValues: [
            Condition.smallerThan(name: TABLET, value: 220.0),
            Condition.largerThan(name: DESKTOP, value: 280.0),
          ],
        ).value;

    final double phoneHeight = phoneWidth * (19.5 / 9);
    final double phoneBorderRadius = phoneWidth * 0.12;
    final double screenPaddingFactor = phoneWidth * 0.04;
    final double bezelThickness = screenPaddingFactor * 0.6;
    final double screenCornerRadius = phoneBorderRadius - bezelThickness;
    final double imageCornerRadius = screenCornerRadius * 0.85;
    final double notchHeight = phoneHeight * 0.035;
    final double notchWidth = phoneWidth * 0.35;

    return Container(
      width: phoneWidth,
      height: phoneHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(phoneBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(bezelThickness),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenCornerRadius),
        child: Container(
          color: screenBackgroundColor,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageCornerRadius),
                  child: Image.asset(
                    appInterfaceAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: phoneWidth * 0.3,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Shamil App\nInterface",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: phoneWidth * 0.06,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenPaddingFactor * 0.5,
                child: Container(
                  width: notchWidth,
                  height: notchHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(notchHeight / 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // Import AppColors for white

// ✨ Enhanced Custom Button with Viral Potential ✨
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary; // When true, applies the outline style
  final Widget? icon;
  final Color? backgroundColor; // Prop to override theme's background
  final Color? foregroundColor; // Prop to override theme's foreground (text/icon)
  final BorderSide? side;      // Prop to override theme's border
  final double? elevation;     // Prop to override theme's elevation
  final WidgetStateProperty<Color?>? overlayColor; // Prop to override hover/splash
  final Duration animationDuration; // Duration for hover animation
  final double hoverScale; // Scale factor on hover
  final Gradient? gradient; // 🆕 Gradient background option!
  final bool shimmerEffect; // 🆕 Option for a subtle shimmer on hover!

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.elevation,
    this.overlayColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.hoverScale = 1.05,
    this.gradient, // ✨ New property for gradient background
    this.shimmerEffect = false, // ✨ New property for shimmer effect
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin { // Added TickerProviderStateMixin for shimmer
  bool _isHovered = false;
  late AnimationController _shimmerController; // ✨ Controller for shimmer effect

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Shimmer animation duration
    );
    if (widget.shimmerEffect) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose(); // Dispose shimmer controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonStyle? baseThemeStyle = theme.elevatedButtonTheme.style;
    ButtonStyle specificStyle;

    // 🎨 Determine button style (Primary or Secondary)
    if (widget.isSecondary) {
      // --- Outline Button Style ---
      specificStyle = ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        foregroundColor: widget.foregroundColor ?? AppColors.textWhite, // Default secondary foreground is white
        side: widget.side ?? BorderSide(color: theme.colorScheme.primary, width: 1.5),
        elevation: widget.elevation ?? 0.0,
      ).merge(baseThemeStyle?.copyWith(
          elevation: WidgetStateProperty.all(widget.elevation ?? 0.0),
          backgroundColor: WidgetStateProperty.all(widget.backgroundColor ?? Colors.transparent),
          overlayColor: widget.overlayColor ?? WidgetStateProperty.all(AppColors.white.withOpacity(0.15)),
          side: widget.side != null ? WidgetStateProperty.all(widget.side) : null,
          foregroundColor: widget.foregroundColor != null ? WidgetStateProperty.all(widget.foregroundColor) : WidgetStateProperty.all(AppColors.textWhite),
      ));
    } else {
      // --- Primary Button Style ---
      specificStyle = baseThemeStyle ?? const ButtonStyle();
      specificStyle = specificStyle.copyWith(
        backgroundColor: widget.gradient == null && widget.backgroundColor != null
            ? WidgetStateProperty.all(widget.backgroundColor)
            : (widget.gradient == null ? null : WidgetStateProperty.all(Colors.transparent)), // Transparent if gradient
        foregroundColor: widget.foregroundColor != null ? WidgetStateProperty.all(widget.foregroundColor) : null,
        side: widget.side != null ? WidgetStateProperty.all(widget.side) : null,
        elevation: widget.gradient != null ? WidgetStateProperty.all(0.0) : (widget.elevation != null ? WidgetStateProperty.all(widget.elevation) : null), // No elevation if gradient by default
        overlayColor: widget.overlayColor,
      );
    }

    // Determine the final foreground color for the icon
    Color? currentForegroundColor = specificStyle.foregroundColor?.resolve({});
    currentForegroundColor ??= widget.isSecondary
          ? AppColors.textWhite
          : theme.colorScheme.onPrimary;

    // ✨ Button content with optional shimmer
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(color: currentForegroundColor),
            child: widget.icon!,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
        ],
        Text(widget.text),
      ],
    );

    // Apply shimmer effect if enabled and hovered
    if (widget.shimmerEffect && _isHovered) {
      buttonContent = AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcIn, // Blend shimmer with text/icon color
            shaderCallback: (bounds) {
              final shimmerValue = _shimmerController.value;
              return LinearGradient(
                colors: [
                  currentForegroundColor!,
                  Colors.white.withOpacity(0.8), // Shimmer color
                  currentForegroundColor,
                ],
                stops: [
                  shimmerValue - 0.5, // Control shimmer width and speed
                  shimmerValue,
                  shimmerValue + 0.5,
                ],
                begin: const Alignment(-1.5, -0.5), // Angle shimmer from top-left
                end: const Alignment(1.5, 0.5),
                tileMode: TileMode.clamp,
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: buttonContent,
      );
    }
    
    // 🏗️ Build the button structure
    Widget button = ElevatedButton(
      style: specificStyle,
      onPressed: widget.onPressed,
      child: buttonContent,
    );

    // Wrap with gradient if provided
    if (widget.gradient != null && !widget.isSecondary) {
      button = Ink( // Use Ink for correct splash effect on gradient
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: specificStyle.shape?.resolve({}) is RoundedRectangleBorder
              ? ((specificStyle.shape!.resolve({}) as RoundedRectangleBorder).borderRadius as BorderRadius?)
              : BorderRadius.circular(AppDimensions.borderRadiusMedium), // Fallback
        ),
        child: ElevatedButton(
          style: specificStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0), // Ensure no default elevation with gradient
          ),
          onPressed: widget.onPressed,
          child: buttonContent,
        ),
      );
    }

    // 🖱️ Mouse region for hover effects
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? widget.hoverScale : 1.0,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
        child: button,
      ),
    );
  }
}
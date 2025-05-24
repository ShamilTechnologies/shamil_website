import 'package:flutter/material.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // Import AppColors for white

// Convert to StatefulWidget for hover animation state
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
    this.animationDuration = const Duration(milliseconds: 200), // Default duration
    this.hoverScale = 1.05, // Default scale increase
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Get the base style from the global ElevatedButtonTheme defined in AppTheme.dart
    final ButtonStyle? baseThemeStyle = theme.elevatedButtonTheme.style;

    ButtonStyle specificStyle;

    if (widget.isSecondary) {
      // --- Define Outline Button Style ---
      specificStyle = ElevatedButton.styleFrom(
        // Default background is transparent for outline style
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        // *** CHANGED: Default foreground is white for secondary button ***
        foregroundColor: widget.foregroundColor ?? AppColors.textWhite,
        // Default border uses theme's primary color (or override)
        side: widget.side ?? BorderSide(color: theme.colorScheme.primary, width: 1.5),
        // Default elevation is 0 for flat outline look
        elevation: widget.elevation ?? 0.0,
        // DO NOT set overlayColor directly in styleFrom if using the prop
      ).merge(baseThemeStyle?.copyWith(
          // Ensure elevation and background are definitely overridden
          elevation: WidgetStateProperty.all(widget.elevation ?? 0.0),
          backgroundColor: WidgetStateProperty.all(widget.backgroundColor ?? Colors.transparent),
          // Apply the overlayColor prop if provided, otherwise use default outline overlay (now using white with opacity)
          overlayColor: widget.overlayColor ?? WidgetStateProperty.all(AppColors.white.withOpacity(0.15)),
          // Apply side prop if provided
          side: widget.side != null ? WidgetStateProperty.all(widget.side) : null,
          // Apply foreground override if provided
          foregroundColor: widget.foregroundColor != null ? WidgetStateProperty.all(widget.foregroundColor) : WidgetStateProperty.all(AppColors.textWhite),
      ));

    } else {
      // --- Define Primary Button Style ---
      // Construct ButtonStyle directly to handle MaterialStateProperty overrides correctly.
      specificStyle = baseThemeStyle ?? const ButtonStyle();

      // Apply overrides if props are provided, wrapping simple values with MaterialStateProperty.all()
      specificStyle = specificStyle.copyWith(
        backgroundColor: widget.backgroundColor != null ? WidgetStateProperty.all(widget.backgroundColor) : null,
        foregroundColor: widget.foregroundColor != null ? WidgetStateProperty.all(widget.foregroundColor) : null,
        side: widget.side != null ? WidgetStateProperty.all(widget.side) : null,
        elevation: widget.elevation != null ? WidgetStateProperty.all(widget.elevation) : null,
        overlayColor: widget.overlayColor, // Directly use the overlayColor prop
      );
    }

    // Determine the final foreground color for the icon, considering overrides and theme.
    Color? currentForegroundColor = specificStyle.foregroundColor?.resolve({});
    currentForegroundColor ??= widget.isSecondary
          ? AppColors.textWhite // Default secondary foreground is white
          : theme.colorScheme.onPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click, // Show click cursor on hover
      child: AnimatedScale(
        scale: _isHovered ? widget.hoverScale : 1.0, // Apply scale based on hover state
        duration: widget.animationDuration, // Use animation duration prop
        curve: Curves.easeInOut, // Smooth animation curve
        child: ElevatedButton(
          style: specificStyle, // Use the calculated specific style
          onPressed: widget.onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min, // Don't take full width unless needed
            children: [
              if (widget.icon != null) ...[
                IconTheme( // Apply the determined foreground color to the icon
                  data: IconThemeData(color: currentForegroundColor),
                  child: widget.icon!,
                ),
                const SizedBox(width: AppDimensions.spacingSmall),
              ],
              Text(widget.text), // Text widget will inherit its color from ButtonStyle.foregroundColor
            ],
          ),
        ),
      ),
    );
  }
}

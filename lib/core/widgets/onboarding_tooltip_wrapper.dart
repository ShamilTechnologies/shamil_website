// lib/core/widgets/onboarding_tooltip_wrapper.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart'; // For localized tooltip messages

// A wrapper around Flutter's Tooltip to provide a consistent style for onboarding.
class OnboardingTooltipWrapper extends StatelessWidget {
  final String messageKey; // Localization key for the tooltip message
  final Widget child;      // The widget that the tooltip will describe
  final bool show;         // Controls whether the tooltip should be actively trying to show (e.g., for a sequence)
  final bool preferBelow;  // Whether the tooltip should prefer to be displayed below the child
  final Duration showDuration; // How long the tooltip should be visible when triggered
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;

  const OnboardingTooltipWrapper({
    super.key,
    required this.messageKey,
    required this.child,
    this.show = true, // By default, assume it should be active if used
    this.preferBelow = false,
    this.showDuration = const Duration(seconds: 4),
    this.padding,
    this.margin,
    this.verticalOffset,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // If 'show' is false, just return the child without the tooltip functionality.
    // This can be used to conditionally disable tooltips in an onboarding sequence.
    if (!show) {
      return child;
    }

    // Use Flutter's built-in Tooltip widget.
    return Tooltip(
      message: messageKey.tr(), // Get the localized message
      preferBelow: preferBelow, // Preferred position of the tooltip
      showDuration: showDuration, // How long it stays visible
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Default padding
      margin: margin, // Margin around the tooltip
      verticalOffset: verticalOffset ?? 24.0, // Default vertical offset from the child

      // Custom decoration for the tooltip to match Shamil's branding
      decoration: BoxDecoration(
        // Use a theme-aware color, e.g., secondary color (Gold) or a dark surface
        color: theme.colorScheme.secondary.withOpacity(0.95), // Gold with slight transparency
        // Or for a more standard dark tooltip:
        // color: theme.brightness == Brightness.dark
        //     ? Colors.grey.shade700.withOpacity(0.9)
        //     : Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium), // Consistent border radius
        boxShadow: [ // Subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      // Text style for the tooltip message
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSecondary, // Text color that contrasts with the tooltip background
        // Or for standard dark tooltip:
        // color: Colors.white,
      ),
      // The child widget that triggers the tooltip on long press (or hover on web/desktop).
      child: child,
    );
  }
}

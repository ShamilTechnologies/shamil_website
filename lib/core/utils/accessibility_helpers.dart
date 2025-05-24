// lib/core/utils/accessibility_helpers.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // For localized semantic labels

// Helper function to determine an accessible text color based on a background color.
Color getAccessibleTextColor(
  Color backgroundColor, {
  Color lightTextColor = Colors.white,
  Color darkTextColor = Colors.black87,
}) {
  final double luminance = backgroundColor.computeLuminance();
  if (luminance > 0.5) {
    return darkTextColor;
  } else {
    return lightTextColor;
  }
}

// Helper widget to build an accessible custom interactive element (e.g., a custom button).
// This wraps a child widget with Semantics and a GestureDetector.
//
// @param labelKey The localization key for the semantic label describing the button's action.
// @param onPressed The callback function when the element is tapped.
// @param child The visual representation of the button/interactive element.
// @param isButton Optional: Whether this element should be treated as a button by accessibility services (default: true).
// @param isLink Optional: Whether this element should be treated as a link.
// @param hintKey Optional: Localization key for a hint (e.g., "Double tap to activate").
class AccessibleWidgetWrapper extends StatelessWidget {
  final String labelKey; // Localization key for the main accessibility label
  final VoidCallback? onPressed; // Action to perform
  final Widget child;         // The widget to make accessible
  final bool isButton;
  final bool isLink;
  final String? hintKey;      // Localization key for an accessibility hint

  const AccessibleWidgetWrapper({
    super.key,
    required this.labelKey,
    this.onPressed,
    required this.child,
    this.isButton = true, // Most interactive elements are button-like
    this.isLink = false,
    this.hintKey,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Indicates to accessibility services that this is a button.
      button: isButton && !isLink, // If it's a link, button semantics might be redundant
      link: isLink,
      // The primary label read by screen readers. Should be concise and descriptive.
      label: labelKey.tr(),
      // A hint provides additional information on how to interact (e.g., "Double tap to open").
      hint: hintKey?.tr(),
      // If there's an onPressed callback, it's an enabled interactive element.
      enabled: onPressed != null,
      // Describes the action that will occur if the user activates the control.
      onTapHint: onPressed != null ? (isLink ? "Opens link".tr() : "Activates button".tr()) : null, // TODO: Localize these generic hints
      // The child widget that provides the visual interface.
      child: GestureDetector(
        onTap: onPressed, // Makes the child tappable.
        child: child,
      ),
    );
  }
}

// Example Usage:
//
// AccessibleWidgetWrapper(
//   labelKey: AppStrings.customButtonLabel, // "Submit form"
//   hintKey: AppStrings.customButtonHint,   // "Double tap to submit your details"
//   onPressed: () { /* handle tap */ },
//   child: Container(
//     padding: const EdgeInsets.all(12),
//     decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
//     child: const Text("Custom Submit", style: TextStyle(color: Colors.white)),
//   ),
// )

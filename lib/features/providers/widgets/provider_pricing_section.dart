import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart'; // Temporarily commented for hardcoded strings
// import 'package:flutter_animate/flutter_animate.dart'; // You can re-add if needed, removed for max simplicity now
// import 'package:shamil_web/core/constants/app_strings.dart'; // Temporarily commented
import 'package:shamil_web/core/widgets/custom_button.dart'; // Assuming this is working
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

// Data class for pricing plans
class PricingPlanData {
  final String id; // Added id for keying
  final String name; // Direct string
  final String target; // Direct string
  final String price;  // Direct string
  final List<String> features; // Direct strings
  final bool isPopular;
  final String ctaText; // Direct string
  final VoidCallback onCtaPressed;
  final Color highlightColor;
  final String popularTagText; // Direct string

  const PricingPlanData({
    required this.id,
    required this.name,
    required this.target,
    required this.price,
    required this.features,
    this.isPopular = false,
    required this.ctaText,
    required this.onCtaPressed,
    required this.highlightColor,
    this.popularTagText = "MOST POPULAR", // Default hardcoded
  });
}

// Main Section Widget
class ProviderPricingSection extends StatelessWidget {
  const ProviderPricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);
    print("[ProviderPricingSection] build: isMobile = $isMobile");

    final List<PricingPlanData> plans = [
      PricingPlanData(
        id: "base",
        name: "Base Plan",
        target: "For individuals & small teams",
        price: "\$19/mo",
        features: [
          "Bookings: Basic",
          "Subscriptions: Limited",
          "NFC/QR: Standard",
          "Analytics: Standard",
          "Support: Email",
        ],
        ctaText: "Choose Plan",
        onCtaPressed: () { print("Base Plan CTA Pressed"); },
        highlightColor: AppColors.primary.withOpacity(0.7),
      ),
      PricingPlanData(
        id: "pro",
        name: "Pro Plan",
        target: "For growing businesses",
        price: "\$49/mo",
        features: [
          "Bookings: Advanced",
          "Subscriptions: Multiple",
          "NFC/QR: Higher Limits",
          "Analytics: Enhanced",
          "Support: Priority Chat",
          "Advanced Customer Segmentation",
        ],
        isPopular: true,
        popularTagText: "POPULAR CHOICE",
        ctaText: "Choose Plan",
        onCtaPressed: () { print("Pro Plan CTA Pressed"); },
        highlightColor: AppColors.primaryGold,
      ),
      PricingPlanData(
        id: "enterprise",
        name: "Enterprise Plan",
        target: "For large scale operations",
        price: "Custom Pricing",
        features: [
          "Bookings: Fully Custom",
          "Subscriptions: Custom Rules",
          "NFC/QR: Custom High Volume",
          "Analytics: Advanced BI",
          "Support: Dedicated Manager",
          "API Access & Integrations",
        ],
        ctaText: "Contact Us",
        onCtaPressed: () { print("Enterprise Plan CTA Pressed"); },
        highlightColor: AppColors.accent.withOpacity(0.8),
      ),
    ];

    return Container(
      key: const ValueKey("ProviderPricingSectionContainer"),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppDimensions.paddingSectionVertical * 0.8 : AppDimensions.paddingSectionVertical,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      color: theme.brightness == Brightness.light ? Colors.grey.shade100 : theme.colorScheme.surfaceVariant, // Slightly different color for testing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Flexible Pricing For Everyone", // Hardcoded
            textAlign: TextAlign.center,
            style: Helpers.responsiveValue(
              context,
              mobile: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface) ?? TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              desktop: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface) ?? TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
          ), // .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1), // Animations removed for stability test
          const SizedBox(height: AppDimensions.spacingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
            child: Text(
              "Find the perfect plan tailored to your business needs and scale as you grow.", // Hardcoded
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.75),
                height: 1.5,
              ) ?? TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.75), height: 1.5),
            ), // .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge * 1.2), // Slightly reduced
          isMobile
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: plans.map((plan) =>
                    Padding(
                      key: ValueKey("MobilePlan_${plan.id}"),
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingLarge),
                      child: _PricingCard(plan: plan, theme: theme)
                      // .animate().fadeIn(delay: (300 + plans.indexOf(plan) * 100).ms) // Animations removed
                    )
                  ).toList(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: plans.map((plan) =>
                    Expanded(
                      key: ValueKey("DesktopPlan_${plan.id}"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
                        child: _PricingCard(plan: plan, theme: theme)
                        // .animate().fadeIn(delay: (400 + plans.indexOf(plan) * 150).ms) // Animations removed
                      ),
                    )
                  ).toList(),
                ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Text(
            "All plans come with our satisfaction guarantee.", // Hardcoded
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ) ?? TextStyle(fontStyle: FontStyle.italic, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ), // .animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}

// StatefulWidget for the Pricing Card
class _PricingCard extends StatefulWidget {
  final PricingPlanData plan;
  final ThemeData theme;

  const _PricingCard({
    // Key is automatically handled by StatefulWidget if needed by parent
    required this.plan,
    required this.theme,
  });

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final theme = widget.theme;
    final popularScale = plan.isPopular && _isHovered ? 1.03 : (plan.isPopular ? 1.01 : 1.0);
    final popularElevation = plan.isPopular ? (_isHovered ? 20.0 : 15.0) : (_isHovered ? 10.0 : 5.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(popularScale),
        transformAlignment: Alignment.center,
        child: Card(
          elevation: popularElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge + 8),
            side: BorderSide(
              color: plan.isPopular ? AppColors.primaryGold : ( _isHovered ? plan.highlightColor : theme.dividerColor.withOpacity(0.5)),
              width: plan.isPopular ? 3 : (_isHovered ? 2 : 1.5),
            ),
          ),
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min, // CRITICAL: Allows Column to determine its height by content
              children: [
                if (plan.isPopular)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(AppDimensions.borderRadiusLarge + 4),
                          bottomLeft: Radius.circular(AppDimensions.borderRadiusMedium),
                        ),
                      ),
                      child: Text(
                        plan.popularTagText.toUpperCase(), // Using direct string from plan
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textOnGold, fontWeight: FontWeight.bold) ??
                            TextStyle(color: AppColors.textOnGold ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                if (!plan.isPopular)
                   // Adjust height to match your popular badge's typical height for alignment
                  const SizedBox(height: 29), // You might need to adjust this value

                Text(
                  plan.name, // Direct string
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: plan.highlightColor) ??
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: plan.highlightColor),
                ),
                Text(
                  plan.target, // Direct string
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)) ??
                      TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                Text(
                  plan.price, // Direct string
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface) ??
                      TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),

                // Features List - NOT wrapped in Expanded
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plan.features.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: plan.highlightColor.withOpacity(0.8), size: 20),
                        const SizedBox(width: AppDimensions.spacingSmall),
                        Expanded(
                          child: Text(
                            plan.features[i], // Direct strings
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8)) ??
                                TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),
                CustomButton(
                  text: plan.ctaText, // Direct string
                  onPressed: plan.onCtaPressed,
                  backgroundColor: plan.isPopular ? AppColors.primaryGold : plan.highlightColor,
                  foregroundColor: plan.isPopular ? AppColors.textOnGold : Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
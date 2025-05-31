// lib/features/provider/presentation/widgets/provider_pricing_section.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart'; // For Shamil colors

class PricingPlanData {
  final String nameKey;
  final String targetKey;
  final String priceKey;
  final List<String> features; // Direct strings, not keys, for simplicity here
  final bool isPopular;
  final String ctaKey;
  final VoidCallback onCtaPressed;
  final Color highlightColor;

  const PricingPlanData({
    required this.nameKey,
    required this.targetKey,
    required this.priceKey,
    required this.features,
    this.isPopular = false,
    required this.ctaKey,
    required this.onCtaPressed,
    required this.highlightColor,
  });
}

class ProviderPricingSection extends StatelessWidget {
  const ProviderPricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);

    // Define pricing plans data
    final List<PricingPlanData> plans = [
      PricingPlanData(
        nameKey: ProviderStrings.basePlanName,
        targetKey: ProviderStrings.basePlanTarget,
        priceKey: ProviderStrings.basePlanPrice,
        features: [
          "${ProviderStrings.pricingFeatureBookings.tr()}: ${ProviderStrings.bookingsBasic.tr()}",
          "${ProviderStrings.pricingFeatureSubscriptions.tr()}: ${ProviderStrings.subscriptionsLimited.tr()}",
          "${ProviderStrings.pricingFeatureNfcQr.tr()}: ${ProviderStrings.nfcQrStandard.tr()}",
          "${ProviderStrings.pricingFeatureAnalytics.tr()}: ${ProviderStrings.analyticsStandard.tr()}",
          "${ProviderStrings.pricingFeatureSupport.tr()}: ${ProviderStrings.supportEmail.tr()}",
        ],
        ctaKey: ProviderStrings.choosePlan,
        onCtaPressed: () { /* TODO: Handle Base Plan CTA */ },
        highlightColor: AppColors.primary.withOpacity(0.7),
      ),
      PricingPlanData(
        nameKey: ProviderStrings.proPlanName,
        targetKey: ProviderStrings.proPlanTarget,
        priceKey: ProviderStrings.proPlanPrice,
        features: [
          "${ProviderStrings.pricingFeatureBookings.tr()}: ${ProviderStrings.bookingsAdvanced.tr()}",
          "${ProviderStrings.pricingFeatureSubscriptions.tr()}: ${ProviderStrings.subscriptionsMultiple.tr()}",
          "${ProviderStrings.pricingFeatureNfcQr.tr()}: ${ProviderStrings.nfcQrHigherLimits.tr()}",
          "${ProviderStrings.pricingFeatureAnalytics.tr()}: ${ProviderStrings.analyticsEnhanced.tr()}",
          "${ProviderStrings.pricingFeatureSupport.tr()}: ${ProviderStrings.supportPriorityChat.tr()}",
          "Advanced Customer Segmentation", // Example of an extra feature
        ],
        isPopular: true,
        ctaKey: ProviderStrings.choosePlan,
        onCtaPressed: () { /* TODO: Handle Pro Plan CTA */ },
        highlightColor: AppColors.primaryGold,
      ),
      PricingPlanData(
        nameKey: ProviderStrings.enterprisePlanName,
        targetKey: ProviderStrings.enterprisePlanTarget,
        priceKey: ProviderStrings.enterprisePlanPrice,
        features: [
          "${ProviderStrings.pricingFeatureBookings.tr()}: ${ProviderStrings.bookingsFullyCustom.tr()}",
          "${ProviderStrings.pricingFeatureSubscriptions.tr()}: ${ProviderStrings.subscriptionsCustomRules.tr()}",
          "${ProviderStrings.pricingFeatureNfcQr.tr()}: ${ProviderStrings.nfcQrCustomHighVolume.tr()}",
          "${ProviderStrings.pricingFeatureAnalytics.tr()}: ${ProviderStrings.analyticsAdvancedBI.tr()}",
          "${ProviderStrings.pricingFeatureSupport.tr()}: ${ProviderStrings.supportDedicatedManager.tr()}",
          "API Access & Integrations", // Example
          "Custom SLAs", // Example
        ],
        ctaKey: ProviderStrings.contactUs,
        onCtaPressed: () { /* TODO: Handle Enterprise Plan CTA */ },
        highlightColor: AppColors.accent.withOpacity(0.8),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppDimensions.paddingSectionVertical * 0.8 : AppDimensions.paddingSectionVertical,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      color: theme.brightness == Brightness.light ? Colors.grey.shade100 : theme.colorScheme.surface.withOpacity(0.8),
      child: Column(
        children: [
          Text(
            ProviderStrings.pricingSectionTitle.tr(),
            textAlign: TextAlign.center,
            style: Helpers.responsiveValue(
              context,
              mobile: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              desktop: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
          const SizedBox(height: AppDimensions.spacingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
            child: Text(
              ProviderStrings.pricingSectionSubtitle.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.75),
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ),
          const SizedBox(height: AppDimensions.spacingExtraLarge * 1.5),
          isMobile
              ? Column(
                  children: plans.map((plan) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingLarge),
                      child: _PricingCard(plan: plan, theme: theme).animate().fadeIn(delay: (300 + plans.indexOf(plan) * 100).ms)
                    )
                  ).toList(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align cards to top if heights differ
                  children: plans.map((plan) => 
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
                        child: _PricingCard(plan: plan, theme: theme).animate().fadeIn(delay: (400 + plans.indexOf(plan) * 150).ms)
                      ),
                    )
                  ).toList(),
                ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Text(
            ProviderStrings.moneyBackGuarantee.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}

class _PricingCard extends StatefulWidget {
  final PricingPlanData plan;
  final ThemeData theme;

  const _PricingCard({required this.plan, required this.theme});

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
                        ProviderStrings.mostPopular.tr().toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textOnGold, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (!plan.isPopular) const SizedBox(height: 29), // Placeholder for alignment with popular badge
                
                Text(
                  plan.nameKey.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: plan.highlightColor),
                ),
                Text(
                  plan.targetKey.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: AppDimensions.spacingMedium),
                Text(
                  plan.priceKey.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true, // Important if inside another scrollable or fixed height
                    physics: const NeverScrollableScrollPhysics(), // If card has fixed height
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
                              plan.features[i], // Features are already translated
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLarge),
                CustomButton(
                  text: plan.ctaKey.tr(),
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

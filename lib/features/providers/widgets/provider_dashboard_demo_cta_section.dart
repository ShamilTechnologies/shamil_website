// lib/features/providers/widgets/provider_dashboard_demo_cta_section.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/widgets/custom_button.dart';
import 'package:shamil_web/features/demo/simplified_dashboard_demo_screen.dart';
import 'package:shamil_web/core/utils/helpers.dart';

class ProviderDashboardDemoCtaSection extends StatelessWidget {
  const ProviderDashboardDemoCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Helpers.responsiveValue(context, mobile: true, desktop: false);

    return Container(
      key: const ValueKey("ProviderDashboardDemoCtaSection"),
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSectionVertical * (isMobile ? 0.8 : 1.0),
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.brightness == Brightness.light
              ? [
                  AppColors.lightPageBackground,
                  AppColors.accent.withOpacity(0.05),
                  AppColors.lightPageBackground,
                ]
              : [
                  AppColors.darkPageBackground,
                  AppColors.accent.withOpacity(0.1),
                  AppColors.darkPageBackground.withBlue(AppColors.darkPageBackground.blue + 5),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ProviderStrings.providerDemoCtaTitle.tr(),
                textAlign: TextAlign.center,
                style: Helpers.responsiveValue<TextStyle?>(
                  context,
                  mobile: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  desktop: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 500.ms),
              const SizedBox(height: AppDimensions.spacingMedium),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
                child: Text(
                  ProviderStrings.providerDemoCtaCaption.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.75),
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 500.ms),
              ),
              const SizedBox(height: AppDimensions.spacingLarge * 1.2),
              CustomButton(
                text: ProviderStrings.providerDemoCtaButtonText.tr(),
                icon: const Icon(Icons.rocket_launch_outlined, size: 20),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SimplifiedDashboardDemoScreen(),
                    ),
                  );
                },
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.textOnGold,
                elevation: 5.0,
                hoverScale: 1.05,
                shimmerEffect: true, 
              ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.8, 0.8), duration: 500.ms, curve: Curves.elasticOut),
            ],
          ),
        ),
      ),
    );
  }
}
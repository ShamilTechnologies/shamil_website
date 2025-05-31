// lib/features/provider/presentation/widgets/provider_how_it_works_section.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_strings.dart';
import 'package:shamil_web/core/utils/helpers.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

class HowItWorksStepData {
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final Color accentColor;

  const HowItWorksStepData({
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.accentColor,
  });
}

class ProviderHowItWorksSection extends StatefulWidget {
  final ScrollController scrollController;

  const ProviderHowItWorksSection({super.key, required this.scrollController});

  @override
  State<ProviderHowItWorksSection> createState() =>
      _ProviderHowItWorksSectionState();
}

class _ProviderHowItWorksSectionState extends State<ProviderHowItWorksSection> {
  final List<HowItWorksStepData> _steps = [
    const HowItWorksStepData(
      titleKey: ProviderStrings.stepSignUpTitle,
      descriptionKey: ProviderStrings.stepSignUpDesc,
      icon: Icons.person_add_alt_1_rounded,
      accentColor: AppColors.primary, // Shamil Blue
    ),
    const HowItWorksStepData(
      titleKey: ProviderStrings.stepAcceptBookingsTitle,
      descriptionKey: ProviderStrings.stepAcceptBookingsDesc,
      icon: Icons.calendar_month_rounded,
      accentColor: AppColors.primaryGold, // Shamil Gold
    ),
    const HowItWorksStepData(
      titleKey: ProviderStrings.stepGrowBusinessTitle,
      descriptionKey: ProviderStrings.stepGrowBusinessDesc,
      icon: Icons.trending_up_rounded,
      accentColor: AppColors.accent, // Lighter Blue
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile =
        Helpers.responsiveValue(context, mobile: true, desktop: false);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? AppDimensions.paddingSectionVertical * 0.8
            : AppDimensions.paddingSectionVertical,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      color: theme.brightness == Brightness.light
          ? Colors.white
          : theme.colorScheme.surface.withOpacity(0.95),
      child: Column(
        children: [
          Text(
            ProviderStrings.howItWorksSectionTitle.tr(),
            textAlign: TextAlign.center,
            style: Helpers.responsiveValue(
              context,
              mobile: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface),
              desktop: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface),
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppDimensions.spacingExtraLarge * 1.5),
          isMobile
              ? _buildMobileLayout(theme)
              : _buildDesktopLayout(theme),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _steps.length,
      itemBuilder: (context, index) {
        return _StepItem(
          step: _steps[index],
          index: index,
          isMobile: true,
          isLast: index == _steps.length - 1,
          totalSteps: _steps.length,
        )
            .animate()
            .fadeIn(delay: (200 + index * 150).ms, duration: 500.ms)
            .slideX(
                begin: (index.isEven ? -0.2 : 0.2), duration: 500.ms);
      },
      separatorBuilder: (context, index) => SizedBox(
          height: AppDimensions.paddingLarge,
          child: Center(
            child: Icon(
              Icons.arrow_downward_rounded,
              color: _steps[index+1].accentColor.withOpacity(0.5),
              size: 24,
            ),
          )
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    List<Widget> items = [];
    for (int i = 0; i < _steps.length; i++) {
      items.add(
        Expanded( // Ensure StepItem takes up available space
          child: _StepItem(
            step: _steps[i],
            index: i,
            isMobile: false,
            isLast: i == _steps.length - 1,
            totalSteps: _steps.length,
          ).animate().fadeIn(delay: (300 + i * 200).ms).slideY(
              begin: 0.2, duration: 600.ms, curve: Curves.easeOutExpo),
        ),
      );
      if (i < _steps.length - 1) {
        items.add(
          Expanded( // Connecting line should also be flexible
            child: _ConnectingLine(
              color: _steps[i + 1].accentColor.withOpacity(0.6),
              isVertical: false,
            )
                .animate()
                .fadeIn(delay: (400 + i * 200).ms)
                .scaleX(
                    delay: (400 + i * 200).ms,
                    duration: 400.ms,
                    curve: Curves.easeInOut),
          ),
        );
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}

class _StepItem extends StatelessWidget {
  final HowItWorksStepData step;
  final int index;
  final bool isMobile;
  final bool isLast;
  final int totalSteps;


  const _StepItem({
    required this.step,
    required this.index,
    required this.isMobile,
    required this.isLast,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign = isMobile ? TextAlign.center : TextAlign.left;
    final crossAxisAlignment =
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    final content = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium + 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: step.accentColor.withOpacity(0.1),
            border: Border.all(
                color: step.accentColor.withOpacity(0.6), width: 2.5),
          ),
          child: Icon(step.icon,
              size: isMobile ? 32 : 40, color: step.accentColor),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Text(
          step.titleKey.tr(),
          textAlign: textAlign,
          style: (isMobile
                  ? theme.textTheme.titleLarge
                  : theme.textTheme.headlineSmall)
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: step.accentColor,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSmall),
        Padding(
          padding: isMobile ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
          child: Text(
            step.descriptionKey.tr(),
            textAlign: textAlign,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.75),
              height: 1.6,
            ),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge)),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: content,
        ),
      );
    }

    // Desktop layout:
    // For desktop, we want the content to be centered within its Expanded space.
    // The timeline effect with alternating layouts is handled by the parent Row structure.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Align to top
      children: [
        // This padding helps with the alternating visual rhythm for desktop
        if (!isMobile && index.isOdd) 
            SizedBox(height: AppDimensions.paddingSectionVertical * 0.5), 
        content,
        if (!isMobile && index.isEven && !isLast) 
            SizedBox(height: AppDimensions.paddingSectionVertical * 0.5),
      ],
    );
  }
}

class _ConnectingLine extends StatelessWidget {
  final Color color;
  final bool isVertical;
  const _ConnectingLine({required this.color, this.isVertical = true});

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Container(
        height: AppDimensions.paddingLarge, // Length of the vertical line
        width: 2.5,
        color: color,
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall / 2),
      );
    }
    // Horizontal line for desktop
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.paddingMedium + 4 + (40/2) ), // Align with center of icons
      height: 2.5,
      constraints: const BoxConstraints(minWidth: 50), // Ensure line is visible
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

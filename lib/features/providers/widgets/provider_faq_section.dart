import 'package:flutter/material.dart';
// Ensure this is set up correctly
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shamil_web/core/constants/app_dimensions.dart';
import 'package:shamil_web/core/constants/app_colors.dart';
// import 'package:shamil_web/core/constants/app_strings.dart'; // Assuming your keys are here or directly in FaqItem
import 'package:responsive_framework/responsive_framework.dart';

class FaqItem {
  final String questionKey; // Ensure these keys exist in your localization files if using .tr()
  final String answerKey;   // Or that they are the direct strings if not using .tr() here
  final IconData icon;

  const FaqItem({
    required this.questionKey,
    required this.answerKey,
    required this.icon,
  });
}

class ProviderFaqSection extends StatefulWidget {
  const ProviderFaqSection({super.key});

  @override
  State<ProviderFaqSection> createState() => _ProviderFaqSectionState();
}

class _ProviderFaqSectionState extends State<ProviderFaqSection>
    with TickerProviderStateMixin {

  // Using direct strings as per your provided code for _faqItems.
  // If these were meant to be keys from ProviderStrings, you'd use .tr() on them.
  final List<FaqItem> _faqItems = const [
    FaqItem(
      questionKey: "How quickly can I get started with Shamil?", // Direct string
      answerKey: "You can start using Shamil within minutes! Simply sign up, complete your provider profile, add your services, and you're ready to accept bookings. Our onboarding process is designed to be quick and intuitive.",
      icon: Icons.rocket_launch_rounded,
    ),
    FaqItem(
      questionKey: "What payment methods does Shamil support?", // Direct string
      answerKey: "Shamil supports multiple payment methods including credit/debit cards, digital wallets, bank transfers, and cash payments. We handle all the payment processing securely, and funds are transferred to your account automatically.",
      icon: Icons.payment_rounded,
    ),
    FaqItem(
      questionKey: "Can I customize my booking rules and availability?", // Direct string
      answerKey: "Absolutely! You have complete control over your availability, booking rules, cancellation policies, and service durations. Set buffer times between appointments, block out holidays, and create recurring schedules with ease.",
      icon: Icons.schedule_rounded,
    ),
    FaqItem(
      questionKey: "How does the subscription management work?", // Direct string
      answerKey: "Our subscription management allows you to create membership plans, recurring services, and package deals. Set up automatic renewals, track member benefits, and manage multiple subscription tiers all from one dashboard.",
      icon: Icons.card_membership_rounded,
    ),
    FaqItem(
      questionKey: "Is my business data secure with Shamil?", // Direct string
      answerKey: "Security is our top priority. We use enterprise-grade encryption, secure cloud infrastructure, and regular security audits. Your data is backed up continuously and you maintain full ownership. We're also GDPR compliant.",
      icon: Icons.security_rounded,
    ),
    FaqItem(
      questionKey: "What kind of support do I get?", // Direct string
      answerKey: "We offer comprehensive support including 24/7 chat support, video tutorials, documentation, and dedicated account managers for Pro and Enterprise plans. Our team is always ready to help you succeed.",
      icon: Icons.support_agent_rounded,
    ),
  ];

  final Map<int, bool> _expandedItems = {};
  final Map<int, AnimationController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _faqItems.length; i++) {
      _controllers[i] = AnimationController(
        duration: const Duration(milliseconds: 300), // Animation duration
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpanded(int index) {
    setState(() {
      // Default to false if not present, then toggle
      final bool isCurrentlyExpanded = _expandedItems[index] ?? false;
      _expandedItems[index] = !isCurrentlyExpanded;

      if (_expandedItems[index]!) {
        _controllers[index]?.forward();
      } else {
        _controllers[index]?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    print("[ProviderFaqSection] build: isMobile = $isMobile");

    return Container(
      key: const ValueKey("ProviderFaqSectionContainer"),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: AppDimensions.paddingPageHorizontal,
      ),
      color: theme.colorScheme.surface, // Use a distinct color if needed for debugging section visibility
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900), // Max width for content
          child: Column(
            children: [
              _buildHeader(theme, isMobile),
              SizedBox(height: isMobile ? 40 : 60),
              _buildFaqList(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isMobile) {
    // Using hardcoded strings for header as per your provided code
    // If these need to be localized, ensure ProviderStrings.providerFaqTitle etc. exist and use .tr()
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1),AppColors.primaryGold.withOpacity(0.1)]),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withOpacity(0.2),width: 1),
          ),
          child: Text(
            "💡 Frequently Asked Questions", // Hardcoded as per your snippet
            style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ) ?? TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
        const SizedBox(height: 24),
        Text(
          "Everything You Need to Know", // Hardcoded
          style: (isMobile ? theme.textTheme.headlineMedium : theme.textTheme.displaySmall)
                ?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface) ??
              TextStyle(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        const SizedBox(height: 16),
        Text(
          "Can't find what you're looking for? Contact our support team anytime.", // Hardcoded
          style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ) ?? TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.7)),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildFaqList(ThemeData theme) {
    if (_faqItems.isEmpty) {
      return const Text("No FAQ items to display.");
    }
    return Column(
      children: List.generate(
        _faqItems.length,
        (index) => _buildFaqItem(theme, index).animate(delay: Duration(milliseconds: 100 * index + 600)) // Staggered animation
            .fadeIn(duration: 600.ms)
            .slideX(begin: index.isEven ? -0.1 : 0.1),
      ),
    );
  }

  Widget _buildFaqItem(ThemeData theme, int index) {
    final item = _faqItems[index];
    final isExpanded = _expandedItems[index] ?? false;
    final controller = _controllers[index];

    if (controller == null) {
      // Should not happen if initState is correct
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor, // Use cardColor for better theme adaptability
        border: Border.all(
          color: isExpanded ? AppColors.primary.withOpacity(0.4) : theme.colorScheme.outline.withOpacity(0.3),
          width: isExpanded ? 2.0 : 1.5, // Slightly thicker when expanded
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded ? AppColors.primary.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            blurRadius: isExpanded ? 15 : 8,
            spreadRadius: isExpanded ? 1 : 0,
            offset: Offset(0, isExpanded ? 6 : 3),
          ),
        ],
      ),
      child: Material( // Material for InkWell splash
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleExpanded(index),
          borderRadius: BorderRadius.circular(18), // Slightly smaller than container for visual padding
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20), // Consistent padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10), // Slightly smaller icon padding
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10), // Softer radius
                      ),
                      child: Icon(item.icon, color: AppColors.primary, size: 22), // Slightly smaller icon
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.questionKey, // Direct string
                        style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ) ?? TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(width: 8), // Space before icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.125 : 0, // Rotates 45 degrees
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.expand_more_rounded, color: AppColors.primary, size: 28), // Larger icon
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic), // Smoother curve
                  axisAlignment: -1.0, // Ensures it expands downwards
                  child: Padding( // Added Padding for the answer content
                    padding: const EdgeInsets.only(top: 16.0, left: 0, right: 0), // Only top padding relative to question
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: theme.colorScheme.outline.withOpacity(0.2), height: 1),
                        const SizedBox(height: 16),
                        Text(
                          item.answerKey, // Direct string
                          style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.85), // Slightly more contrast
                                height: 1.5, // Improved line spacing
                              ) ?? TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withOpacity(0.85), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
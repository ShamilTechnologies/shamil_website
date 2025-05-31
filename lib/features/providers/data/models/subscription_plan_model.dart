// lib/features/provider/data/models/subscription_plan_model.dart

import 'package:flutter/material.dart'; // For Color

// Using keys from ProviderStrings for plan details
enum PlanTierIdentifier { base, pro, enterprise }

@immutable
class SubscriptionPlanModel {
  final String id; // e.g., "shamil_base_monthly"
  final PlanTierIdentifier tierIdentifier;
  final String nameKey; // From ProviderStrings, e.g., ProviderStrings.basePlanName
  final String targetAudienceKey; // From ProviderStrings
  final String priceDisplayKey; // From ProviderStrings, e.g., ProviderStrings.basePlanPrice
  final String billingCycleKey;   // From ProviderStrings, e.g., ProviderStrings.perMonth
  
  // This list will contain keys from ProviderStrings for detailed feature comparison
  // The value for each key will be specific to this plan
  // e.g., { ProviderStrings.pricingFeatureBookings: ProviderStrings.bookingsBasic }
  final Map<String, String> detailedFeatures; 

  final bool isPopular;
  final String ctaButtonKey; // From ProviderStrings
  final Color highlightColor; 
  final Color ctaButtonTextColor;
  final int? monthlyBookingLimit;
  final int? staffAccounts;
  final bool hasAdvancedReporting;
  final bool hasDedicatedSupport;

  const SubscriptionPlanModel({
    required this.id,
    required this.tierIdentifier,
    required this.nameKey,
    required this.targetAudienceKey,
    required this.priceDisplayKey,
    required this.billingCycleKey,
    required this.detailedFeatures,
    this.isPopular = false,
    required this.ctaButtonKey,
    required this.highlightColor,
    required this.ctaButtonTextColor,
    this.monthlyBookingLimit,
    this.staffAccounts,
    this.hasAdvancedReporting = false,
    this.hasDedicatedSupport = false,
  });
}

// lib/features/provider/data/repositories/provider_repository.dart

import 'package:flutter/material.dart';
import 'package:shamil_web/features/providers/data/models/business_analytics_model.dart';
import 'package:shamil_web/features/providers/data/models/provider_model.dart';
import 'package:shamil_web/features/providers/data/models/subscription_plan_model.dart'; // For DateTimeRange

// Abstract class defining the contract for provider-related data operations.
// Concrete implementations (e.g., FirebaseProviderRepository, ApiProviderRepository)
// will provide the actual data fetching and manipulation logic.
abstract class ProviderRepository {
  /// Fetches the profile for a specific provider by their ID.
  Future<ProviderModel> getProviderProfile(String providerId);

  /// Creates a new provider profile.
  /// Returns the created ProviderModel, typically with a server-generated ID.
  Future<ProviderModel> createProviderProfile(ProviderModel providerData);

  /// Updates an existing provider's profile.
  /// Returns true if successful, false otherwise.
  Future<bool> updateProviderProfile(ProviderModel provider);

  /// Fetches a list of available subscription plans for providers.
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();

  /// Subscribes a provider to a specific plan.
  /// May return information about the subscription status or an updated ProviderModel.
  Future<void> subscribeToPlan({required String providerId, required String planId});

  /// Cancels a provider's current subscription.
  Future<void> cancelSubscription(String providerId);

  /// Fetches business analytics data for a provider.
  /// [dateRange] specifies the period for which to fetch analytics.
  Future<BusinessAnalyticsModel> getBusinessAnalytics({
    required String providerId,
    required DateTimeRange dateRange,
  });

  /// Checks if a business name is already taken.
  Future<bool> isBusinessNameAvailable(String businessName);

  /// Uploads a file (e.g., logo, cover image) for a provider.
  /// Returns the URL of the uploaded file.
  // Future<String> uploadProviderFile(String providerId, File file, String fileType); // File type from dart:io - consider Uint8List for web

  // Example for service management by provider
  // Future<List<ProviderServiceModel>> getProviderServices(String providerId);
  // Future<ProviderServiceModel> addOrUpdateProviderService(String providerId, ProviderServiceModel service);
  // Future<void> deleteProviderService(String providerId, String serviceId);
}

// Note: You would then create concrete implementations of this repository, for example:
// class FirebaseProviderRepository implements ProviderRepository {
//   // ... Firebase specific implementation ...
// }
//
// class ApiProviderRepository implements ProviderRepository {
//   // ... HTTP API specific implementation ...
// }

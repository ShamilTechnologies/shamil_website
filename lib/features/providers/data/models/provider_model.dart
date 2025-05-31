// lib/features/provider/data/models/provider_model.dart

import 'package:flutter/foundation.dart';

enum ProviderVerificationStatus { pending, verified, rejected, needsReview }
enum ProviderCategory { salon, spa, clinic, fitness, education, homeServices, automotive, events, freelance, other }
enum BusinessSize { individual, small, medium, large }

@immutable
class ProviderModel {
  final String id;
  final String businessName;
  final String contactEmail; // Primary contact email
  final String phoneNumber;  // Primary contact phone
  final String? websiteUrl;
  final String? logoUrl;
  final String? coverImageUrl;
  final String shortDescription; // For cards or brief views
  final String detailedBio;    // For the provider's profile page
  final List<ProviderCategory> categories; // Can belong to multiple categories
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String stateOrRegion; // e.g., Governorate
  final String postalCode;
  final String countryCode; // e.g., "EG"
  final double averageRating;
  final int totalReviews;
  final ProviderVerificationStatus verificationStatus;
  final DateTime memberSince;
  final DateTime lastProfileUpdate;
  final BusinessSize businessSize;
  final List<String> serviceIdsOffered; // List of IDs for services they provide
  final Map<String, String> socialMediaLinks; // e.g., {"facebook": "url", "instagram": "url"}
  final bool isFeatured; // To highlight certain providers
  final String? vatNumber;
  final String? commercialRegistrationNumber;

  const ProviderModel({
    required this.id,
    required this.businessName,
    required this.contactEmail,
    required this.phoneNumber,
    this.websiteUrl,
    this.logoUrl,
    this.coverImageUrl,
    required this.shortDescription,
    required this.detailedBio,
    required this.categories,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.stateOrRegion,
    required this.postalCode,
    required this.countryCode,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.verificationStatus = ProviderVerificationStatus.pending,
    required this.memberSince,
    required this.lastProfileUpdate,
    required this.businessSize,
    this.serviceIdsOffered = const [],
    this.socialMediaLinks = const {},
    this.isFeatured = false,
    this.vatNumber,
    this.commercialRegistrationNumber,
  });

  // Add fromJson, toJson, copyWith, props for Equatable if needed
}
